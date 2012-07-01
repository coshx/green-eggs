module PollsHelper

  def ballots_cast_message(poll)
    "#{poll.ballots.cast.count} ballots cast, with #{poll.ballots.outstanding.count} outstanding"
  end

end
