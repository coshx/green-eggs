class Api::BallotsController < ApplicationController
  include BallotsHelper
  before_filter :load_poll_and_ballot, :only => [:show, :update]
  before_filter :check_admin_key_and_load_poll, :only => [:create]

  # GET /ballots
  def index
    @ballots = Ballot.all
  end

  # GET /ballots/1
  def show
    @choices = existing_choices_not_on_ballot(@poll, @ballot)
    render @choices.as_json
  end

  # POST /ballots
  def create
    emails = params[:emails].split(/\s*,\s*/).reject { |s| s.strip.empty? }.uniq
    invitationMsg = params[:invitationMsg]
    emails.each do |e|
      @poll.ballots.create(email: e, invitationMessage: invitationMsg)
    end
    redirect_to api_poll_admin_path(:poll_id => @poll.id, :owner_key => @poll.owner_key, :only_path => false), :notice => "Successfully invited #{emails.join(",")}"
  end

  # PUT /ballots/1
  def update

    if params[:voting] == "true"
      @ballot.choices.delete_all
    end

    if params[:ballot][:choices]
      params[:ballot][:choices].each_with_index do |original, index|
        @ballot.choices.create(:original => original[:original], :priority => index)
        @ballot.inspect
      end
    end
    if user_signed_in?
      @ballot.user_id = current_user._id
      @ballot.save!
    end
    render json:@poll.to_json
  end
end
