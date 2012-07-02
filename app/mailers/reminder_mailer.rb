class ReminderMailer < ActionMailer::Base
  default from: "GreenEggs <bot@greeneg.gs>"

  def send_reminder(ballot)
    @ballot = ballot
    @poll = ballot.poll
    mail(:to => ballot.email,
         :subject => "Reminder to vote on #{ballot.poll.name}")
  end
end
