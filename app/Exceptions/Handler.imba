import { RedirectException } from './RedirectException'
import { ExceptionHandler } from '@formidablejs/framework'
import { handleException } from '@formidablejs/framework/lib/Foundation/Exceptions/Handler/handleException'
import { Redirect } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { FastifyReply } from '@formidablejs/framework'
import { AuthorizationException } from '@formidablejs/framework/lib/Auth/Exceptions'

export class Handler < ExceptionHandler

	def handle error, request\Request, reply\FastifyReply
		if error instanceof AuthorizationException
			request.session!.set('redirectPath', request.url!)

			return Redirect.route('login.show')

		if error instanceof RedirectException
			return Redirect.to(error.message)
