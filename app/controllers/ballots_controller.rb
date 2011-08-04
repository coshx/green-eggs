class BallotsController < ApplicationController
  # GET /ballots
  # GET /ballots.json
  def index
    @ballots = Ballot.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ballots }
    end
  end

  # GET /ballots/1
  # GET /ballots/1.json
  def show
    @ballot = Ballot.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ballot }
    end
  end

  # GET /ballots/new
  # GET /ballots/new.json
  def new
    #@ballot = Ballot.new
    #@ballot = Poll.find(params[:poll_id]).ballots.create
    @poll = Poll.find(params[:poll_id])

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /ballots/1/edit
  def edit
    @ballot = Ballot.find(params[:id])
  end

  # POST /ballots
  # POST /ballots.json
  def create
    @poll = Poll.find(params[:poll_id])
    emails = params[:emails].split(/\s*,\s*/).uniq
    emails.each do |e|
      @poll.ballots.create(email: e)
    end
    redirect_to @poll 
  end

  # PUT /ballots/1
  # PUT /ballots/1.json
  def update
    @ballot = Ballot.find(params[:id])

    respond_to do |format|
      if @ballot.update_attributes(params[:ballot])
        format.html { redirect_to @ballot, notice: 'Ballot was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @ballot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ballots/1
  # DELETE /ballots/1.json
  def destroy
    @ballot = Ballot.find(params[:id])
    @ballot.destroy

    respond_to do |format|
      format.html { redirect_to ballots_url }
      format.json { head :ok }
    end
  end
end
