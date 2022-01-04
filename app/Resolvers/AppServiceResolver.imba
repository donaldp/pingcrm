import { AuthService as Auth } from '@formidablejs/framework'
import { die } from '@formidablejs/framework/lib/Support/Helpers'
import { Redirect } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { ResetPassword } from '../Mail/ResetPassword'
import { ServiceResolver } from '@formidablejs/framework'
import { URL } from '@formidablejs/framework'
import { VerifyEmail } from '../Mail/VerifyEmail'
import type { FastifyReply } from 'fastify'

export class AppServiceResolver < ServiceResolver

	def boot
		Auth.verificationMailer(VerifyEmail)
		Auth.resetPasswordMailer(ResetPassword)

		Auth.onAuthenticated do(request\Request, reply\FastifyReply, user\Object, protocol\String)
			if protocol != 'web' then return

			die do
				Redirect.to(request.session!.pull('redirectPath', URL.route('home')))

		Auth.onSessionDestroyed do(request\Request, reply\FastifyReply, protocol\String)
			if protocol != 'web' then return

			die do
				Redirect.route('login.show')
