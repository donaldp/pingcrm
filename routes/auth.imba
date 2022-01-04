import { AuthenticationController } from '../app/Http/Controllers/AuthenticationController'
import { Route } from '@formidablejs/framework'

Route.group { middleware: ['guest'] }, do
	Route.get('login', [AuthenticationController, 'login']).name('login.show')
