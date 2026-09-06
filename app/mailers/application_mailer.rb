class ApplicationMailer < ActionMailer::Base
  default from: "<noreply@railsfinancemanager.online>" # this domain must be verified with Resend

  layout "mailer"
end
