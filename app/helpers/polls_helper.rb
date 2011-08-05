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

    if related
      extra_results = {}
      results.each do |r|
        original = r[1][:original]
        tally = r[1][:tally]
        response = Wordnik.word.get_related_words(original, :useCanonical => 'true')
        if response && !response.empty?
          related = response[0]["words"]
        else
          related = []
        end
        related.each do |original|
          slug = original.downcase.gsub(/[^a-z0-9]+/, '')
          extra_results[slug] ||= {}
          extra_results[slug][:original] ||= original       
          extra_results[slug][:tally] ||= 0.0 
          extra_results[slug][:tally] += ((tally * 0.25)*(1.0 / related.size))
        end
        if !related.empty?
           tally = tally * 0.75
        end
        extra_results[r[0]] ||= {}
        extra_results[r[0]][:original] ||= original
        extra_results[r[0]][:tally] ||= 0.0
        extra_results[r[0]][:tally] += tally
      end
      results = extra_results.to_a.collect {|r| r[1]}.sort {|x,y| y[:tally] <=> x[:tally] }
    else
      results = results.to_a.collect {|r| r[1]}.sort {|x,y| y[:tally] <=> x[:tally] }
    end
    results
  end

end
