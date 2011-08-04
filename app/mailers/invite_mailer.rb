class InviteMailer < ActionMailer::Base
  default from: "noreply@greeneg.gs"

  def invite_to_vote_email(ballot)
    @ballot = ballot
    mail(:to => ballot.email,
         :subject => "Invitation to vote on #{ballot.poll.name}")
  end
end
