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
    @poll = Poll.first(:conditions => {:invitation_key => params[:poll_id]})
    @poll ||= Poll.find(params[:poll_id] || params[:id])
    if @poll.present? && params[:ballot_key].blank? && @poll.invitation_key.present?
      if cookies["#{@poll.id}-ballot-key"].present?
        @ballot = @poll.ballots.where(:key => cookies["#{@poll.id}-ballot-key"]).first
      else
        @ballot = @poll.ballots.create(:email => "anonymous@greeneg.gs")
        cookies["#{@poll.id}-ballot-key"] = {:value => @ballot.key, :expires => 10.years.from_now}
      end
      redirect_to vote_on_ballot_path(:poll_id => @poll.id, :ballot_key => @ballot.key)
    else
      @ballot = @poll.ballots.where(:key => params[:ballot_key]).first
      render :file => File.join(Rails.root, "public", "404"), :status => 404 if !@ballot.present?
    end
  end
end
