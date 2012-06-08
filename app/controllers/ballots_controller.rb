class BallotsController < ApplicationController
  include BallotsHelper
  before_filter :load_poll_and_ballot, :only => [:show, :edit, :update]
  before_filter :check_admin_key_and_load_poll, :only => [:new, :create]

  # GET /ballots
  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
    @choices = existing_choices_not_on_ballot(@poll, @ballot)
  end

  # GET /ballots/new
  def new
  end

  # GET /ballots/1/edit
  def edit
  end

  # POST /ballots
  def create
    emails = params[:emails].split(/\s*,\s*/).reject { |s| s.strip.empty? }.uniq
    invitationMsg = params[:invitationMsg]
    emails.each do |e|
      @poll.ballots.create(email: e, invitationMessage: invitationMsg)
    end
    redirect_to poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  def update
    if params[:choices]
      @ballot.choices.delete_all
      params[:choices].each_with_index do |original, index|
        @ballot.choices.create(:original => original, :priority => index)
      end
    end

    @ballot.update_attributes(params[:ballot])
    flash[:notice] = 'Your vote was successfully recorded'
    render :js => "$(function() { window.location = '#{poll_results_path(:ballot_key => @ballot.key, :poll_id => @poll.id)}'});"
  end
end
