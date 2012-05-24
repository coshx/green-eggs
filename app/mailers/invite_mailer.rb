class InviteMailer < ActionMailer::Base
  default from: "GreenEggs <bot@greeneg.gs>"

  def invite_to_vote(ballot)
    @ballot = ballot
    @poll = ballot.poll
    mail(:to => ballot.email,
         :subject => "Invitation to vote on #{ballot.poll.name}")
  end
end
