module BallotsHelper

  def existing_choices_not_on_ballot(poll, current_ballot)
    choices = {}
    sets_of_choices = poll.ballots.clone
    sets_of_choices << poll
    sets_of_choices.each do |set|
      set.choices.each do |choice|
        if current_ballot.choices.select {|c| c.slug == choice.slug}.empty? && choice.original.present?
          choices[choice.slug] = choice.original if choice.original.present?
        end
      end
    end
    choices.to_a.shuffle
  end

  def group_invitation_url(poll)
    if @poll.invitation_key
      vote_on_ballot_url(@poll.id, @poll.invitation_key)
    else
      'disabled'
    end
  end

end
