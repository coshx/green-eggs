class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId do |exception|
    render :file => File.join(Rails.root, "public", "404"), :status => 404
  end

  private

  def check_admin_key_and_load_poll
    @poll = Poll.find(params[:poll_id] || params[:id])
    render :file => File.join(Rails.root, "public", "404"), :status => 404 if @poll.owner_key != params[:owner_key]
  end

  def load_poll_and_ballot
    @poll = Poll.find(params[:poll_id] || params[:id])
    if @poll.invitation_key && @poll.invitation_key == params[:ballot_key]
      @ballot = @poll.ballots.create(:email => "anonymous@greeneg.gs")
      redirect_to vote_on_ballot_path(:poll_id => @poll.id, :ballot_key => @ballot.key)
    else
      @ballot = @poll.ballots.where(:key => params[:ballot_key]).first
      render :file => File.join(Rails.root, "public", "404"), :status => 404 if !@ballot.present?
    end
  end
end
