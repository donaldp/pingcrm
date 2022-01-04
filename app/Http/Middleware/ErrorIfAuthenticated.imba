import { ErrorIfAuthenticated as Middleware } from '@formidablejs/framework'
import { ForbiddenException } from '@formidablejs/framework/lib/Http/Exceptions'
import { Request } from '@formidablejs/framework'
import { Redirect } from '@formidablejs/framework'
import { die } from '@formidablejs/framework/lib/Support/Helpers'
import { FastifyReply } from '@formidablejs/framework'

export class ErrorIfAuthenticated < Middleware

	def onAuthenticated request\Request, reply\FastifyReply, params\any[]|null
		if request.expectsHtml! then die do Redirect.to('/')

		throw new ForbiddenException 'Action not allowed'
