class BallotsController < ApplicationController
  # GET /ballots
  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.find(params[:ballot_id])
  end

  # GET /ballots/new
  def new
    @poll = Poll.find(params[:id])
    if @poll.owner_key != params[:owner_key]
      render :file => File.join(Rails.root, "public", "404.html"), :status => 404 if @poll.owner_key != params[:owner_key]
    end
  end

  # GET /ballots/1/edit
  def edit
    @ballot = Ballot.find(params[:id])
  end

  # POST /ballots
  def create
    @poll = Poll.find(params[:poll_id])
    emails = params[:emails].split(/\s*,\s*/).reject { |s| s.strip.empty? }.uniq
    emails.each do |e|
      b = @poll.ballots.create(email: e)
      b.choices.create
    end
    redirect_to poll_admin_path(:id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  def update
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.find(params[:ballot_id])
    if @ballot.update_attributes(params[:ballot])
      redirect_to poll_results_path(:ballot_id => @ballot.id, :id => @poll.id), notice: 'Your vote was successfully recorded'
    end
  end

  # DELETE /ballots/1
  def destroy
    @ballot = Ballot.find(params[:id])
    @ballot.destroy

    format.html { redirect_to ballots_url }
  end
end
