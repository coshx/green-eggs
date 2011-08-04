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
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.find(params[:ballot_id])

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
    debugger
    emails.each do |e|
      b = @poll.ballots.create(email: e)
      b.choices.create(:original => "")
      InviteMailer.invite_to_vote_email(b).deliver
    end
    redirect_to @poll, :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  # PUT /ballots/1.json
  def update
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.find(params[:ballot_id])
    respond_to do |format|
      if @ballot.update_attributes(params[:ballot])
        format.html { redirect_to vote_on_ballot_path(:ballot_id => @ballot.id, :poll_id => @poll.id), notice: 'Ballot was successfully updated.' }
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