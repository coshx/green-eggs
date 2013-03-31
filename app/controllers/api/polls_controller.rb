class Api::PollsController < ApplicationController
  before_filter :check_admin_key_and_load_poll, :only => [:edit, :update, :destroy, :choices, :remind_voters]
  before_filter :load_poll_and_ballot, :only => [:show]
  include BallotsHelper

  # GET /polls
  def index
    @polls = Poll.all
  end

  # GET /polls/1
  def show
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # GET /polls/1/edit
  def edit
  end

  # POST /polls
  def create
    # library docs for github: https://github.com/peter-murach/github
    # private repo checkbox perhaps to see if auth is required?
    # and send user back to form suggesting checking private box if repo is 404
    if params[:repository_url]
      uri = URI.parse(params[:repository_url])
      matched = uri.path.split("/").reject {|s| s.blank?}
      user = matched[0]
      repo = matched[1]
      github = Github.new(:user => user, :repo => repo)
      issues = github.issues.list_repo(user, repo) # ignores closed issues by default
      params["poll"]["name"] = Poll.generate_unique_name("What are the most important open issues for #{user}/#{repo} ?")
      params["poll"]["description"] = params[:repository_url]
      params["poll"]["allow_user_choices"] = false
    end
    @poll = Poll.new(params[:poll])
    seed_poll_with_issues(@poll, issues) if issues
    if @poll.save
      redirect_to api_poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), notice: 'Poll was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /polls/1
  def update
    respond_to do |format|
      format.html do
        if @poll.update_attributes(params[:poll])
          redirect_to api_poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key), notice: 'Poll was successfully updated.'
        else
          render action: "edit"
        end
      end

      format.json do
        if params["use_invitation_key"] == "true"
          @poll.generate_invitation_key
        else
          @poll.invitation_key = nil
        end

        @poll.save!
        render :json => { group_link: group_invitation_url(@poll), shortened_group_link: shortened_group_invitation_url(@poll) }
      end
    end
  end

  # GET /:poll_id/admin/choices
  def choices
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
    redirect_to api_polls_url
  end

  # GET /github
  def from_gh_issues
    redirect_to new_poll_url(:from_github_issues => true)
  end

  # POST /:poll_id/admin/remind_voters
  def remind_voters
    if @poll.last_reminder_sent_at.present? && (Time.now - @poll.last_reminder_sent_at < 1.hour)
      flash[:error] = "You can only send reminder emails every hour.  The last one was sent at #{@poll.last_reminder_sent_at}"
    else
      @poll.ballots.each {|b| b.send_reminder_email}
      @poll.last_reminder_sent_at = Time.now
      @poll.save
      flash[:notice] = "Successfully sent reminder email(s)"
    end
    redirect_to api_poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key)
  end

  private
  def seed_poll_with_issues(poll, issues)
    issues.each do |issue|
      poll.choices.create(:original => issue.title, :link => issue.html_url)
    end
  end
end
