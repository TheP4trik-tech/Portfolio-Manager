class ApplicationMailer < ActionMailer::Base
  default from: "<railsfinancemanager.online@resend.dev>" # this domain must be verified with Resend

  layout "mailer"
end
