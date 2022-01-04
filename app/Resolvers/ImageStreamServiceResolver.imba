import { FastifyReply } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { ServiceResolver } from '@formidablejs/framework'
import { StreamImage } from '../Utils/StreamImage'

export class ImageStreamServiceResolver < ServiceResolver

	def boot
		self.app.onResponse do(response, request\Request, reply\FastifyReply)
			if !(response instanceof StreamImage)
				return

			response.handle(request, reply)

