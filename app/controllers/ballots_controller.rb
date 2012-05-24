class BallotsController < ApplicationController
  before_filter :load_poll_and_ballot, :only => [:show, :edit, :update]
  before_filter :check_admin_key_and_load_poll, :only => [:new, :create]

  # GET /ballots
  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
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
    description = params[:description]
    emails.each do |e|
      @poll.ballots.create(email: e)
    end
    redirect_to poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :description => @poll.description, :only_path => false), :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  def update
    @ballot.choices.delete_all
    if @ballot.update_attributes(params[:ballot])
      redirect_to poll_results_path(:ballot_key => @ballot.key, :poll_id => @poll.id), notice: 'Your vote was successfully recorded'
    end
  end
end
