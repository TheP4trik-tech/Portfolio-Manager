class ApplicationMailer < ActionMailer::Base
  default from: "<noreply@railfinancemanager.online>" # this domain must be verified with Resend

  layout "mailer"
end
