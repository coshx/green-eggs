module PollsHelper

  def calculate_results(poll, related=false)
    results = {}
 
    poll.ballots.each do |b|
      b.sort_by_priority
      num_choices = b.choices.size
      ballot_handicap = num_choices.to_f / (1..num_choices).sum
      b.choices.each do |c|
        if c.slug 
          results[c.slug] ||= {}
          results[c.slug][:original] ||= c.original       
          results[c.slug][:tally] ||= 0.0 
          results[c.slug][:tally] += (((num_choices - c.priority) / num_choices.to_f) * ballot_handicap) / poll.ballots.cast.count
        end
      end
    end

    results
  end
end
