import { AuthService as Auth } from '@formidablejs/framework'
import { Route } from '@formidablejs/framework'
import { ServiceResolver } from '@formidablejs/framework'

export class RouterServiceResolver < ServiceResolver

	def boot
		Route.group { middleware: ['session'] }, do

			# disable all auth routes except for the login and logout routes.
			Auth.routes({
				register: false
				email: false
				password: false
			})

			require '../../routes/auth'
			require '../../routes/web'

		Route.group { middleware: ['jwt'], prefix: 'api' }, do
			require '../../routes/api'

		self
