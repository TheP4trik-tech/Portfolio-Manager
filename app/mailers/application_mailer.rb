class ApplicationMailer < ActionMailer::Base
  default from: "Acme <onboarding@resend.dev>" # this domain must be verified with Resend

  layout "mailer"
end
