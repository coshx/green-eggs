module BallotsHelper

  def existing_choices_not_on_ballot(poll, current_ballot)
    choices = {}
    poll.ballots.each do |ballot|
      ballot.choices.each do |choice|
        if current_ballot.choices.select {|c| c.slug == choice.slug}.empty? && choice.original.present?
          choices[choice.slug] = choice.original if choice.original.present?
        end
      end
    end
    choices.to_a.shuffle
  end

end
