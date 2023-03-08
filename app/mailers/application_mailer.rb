class ApplicationMailer < ActionMailer::Base
  default from: ENV["TRACKER_MAIL_SENDER"]
  layout "mailer"
end
