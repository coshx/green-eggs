module BallotsHelper

  def existing_choices_not_on_ballot(poll, current_ballot)
    choices = {}
    sets_of_choices = poll.ballots.clone
    sets_of_choices << poll
    sets_of_choices.each do |set|
      set.choices.each do |choice|
        if current_ballot.choices.select {|c| c.slug == choice.slug}.empty? && choice.original.present?
          choices[choice.slug] = choice if choice.original.present?
        end
      end
    end
    choices.map {|k,v| v}.shuffle
  end

  def group_invitation_url(poll)
    if @poll.invitation_key
      group_link_url(@poll.id)
    else
      'disabled'
    end
  end

  def shortened_group_invitation_url(poll)
    if @poll.invitation_key
      if Rails.env.production?
        "http://grneg.gs#{group_link_path(:poll_id => @poll.invitation_key)}"
      else
        group_link_url(:poll_id => @poll.invitation_key)
      end
    else
      'disabled'
    end
  end
end
