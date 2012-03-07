class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Mongoid::Errors::DocumentNotFound, BSON::InvalidObjectId do |exception|
    render :file => File.join(Rails.root, "public", "404"), :status => 404
  end

  private
  def check_admin_key_and_load_poll
    @poll = Poll.find(params[:poll_id])
    render :file => File.join(Rails.root, "public", "404"), :status => 404 if @poll.owner_key != params[:owner_key]
  end

  def load_poll_and_ballot
    @poll = Poll.find(params[:poll_id])
    @ballot = @poll.ballots.where(:key => params[:ballot_key]).limit(1).first
    render :file => File.join(Rails.root, "public", "404"), :status => 404 if !@ballot.present?
  end
end
