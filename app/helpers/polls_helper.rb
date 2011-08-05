module PollsHelper

  def calculate_results(poll)
    results = {}
    poll.ballots.each do |b|
      num_choices = b.choices.size
      ballot_handicap = num_choices.to_f / (1..num_choices).sum
      b.choices.each do |c|
        if c.slug 
          results[c.slug] ||= {}
          results[c.slug][:original] ||= c.original       
          results[c.slug][:tally] ||= 0.0 
          results[c.slug][:tally] += (((num_choices - c.priority) / num_choices.to_f) * ballot_handicap)
        end
      end
    end
    results = results.to_a.collect {|r| r[1]}.sort {|x,y| y[:tally] <=> x[:tally] }
  end

end
