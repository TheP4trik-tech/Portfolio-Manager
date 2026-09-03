class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  layout "mailer"
  default from: "Acme <onboarding@resend.dev>" # this domain must be verified with Resend
end
