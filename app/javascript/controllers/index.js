// Import and register all your controllers from the importmap via controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import PasswordVisibility from '@stimulus-components/password-visibility'
import { application } from 'controllers/application'
import Notification from '@stimulus-components/notification'

application.register('notification', Notification)

application.register('password-visibility', PasswordVisibility)
eagerLoadControllersFrom("controllers", application)
