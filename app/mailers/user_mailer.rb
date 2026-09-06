class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"
  layout "mailer"
  default from: "<noreply@railfinancemanager.online>"
end
