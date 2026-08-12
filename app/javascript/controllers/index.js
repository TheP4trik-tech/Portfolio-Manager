// Import and register all your controllers from the importmap via controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import { application } from 'controllers/application'
import PasswordVisibility from '@stimulus-components/password-visibility'

application.register('password-visibility', PasswordVisibility)
eagerLoadControllersFrom("controllers", application)
