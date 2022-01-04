import { config } from '@formidablejs/framework/lib/Support/Helpers'
import { Request } from '@formidablejs/framework'
import { NotFoundException } from '@formidablejs/framework'

export class PrivateResource

	def handle request\Request
		if !config('app.url').includes(request.referer!.split('/')[2])
			throw NotFoundException.using(request)
