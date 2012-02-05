class OwnerMailer < ActionMailer::Base
  default from: "GreenEggs <bot@greeneg.gs>"

  def send_admin_link(poll)
    @poll = poll
    mail(:to => poll.owner_email,
         :subject => "Poll created: #{poll.name}")
  end
end
