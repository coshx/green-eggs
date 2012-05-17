class PollsController < ApplicationController
  before_filter :check_admin_key_and_load_poll, :only => [:edit, :update, :destroy, :choices]
  before_filter :load_poll_and_ballot, :only => [:show]

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
    @poll = Poll.new(params[:poll])
    if @poll.save
      redirect_to poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), notice: 'Poll was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /polls/1
  def update
    respond_to do |format|
      format.html do
        if @poll.update_attributes(params[:poll])
          redirect_to poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key), notice: 'Poll was successfully updated.'
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
        render :json => { invitation_key: @poll.invitation_key }
      end
    end
  end

  # GET /:poll_id/admin/choices
  def choices
    @poll.choices.build
  end

  # DELETE /polls/1
  def destroy
    @poll.destroy
    redirect_to polls_url
  end

end
