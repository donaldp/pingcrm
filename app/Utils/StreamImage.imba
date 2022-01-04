import { NotFoundException } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { FastifyReply } from '@formidablejs/framework'
import { existsSync } from 'fs-extra'
import { join } from 'path'
import { createReadStream } from 'fs'

export class StreamImage

	prop location\String
	prop disk\String

	def constructor location\String
		self.location = location

	static def make location\String
		new self(location)

	def from disk\String
		self.disk = disk

		self

	def handle request\Request, reply\FastifyReply
		const file = join(process.cwd!, 'storage', 'framework', self.disk ?? '', self.location)

		if !existsSync(file)
			throw new NotFoundException "Route GET:/img/{request.param('image')}"

		const stream = createReadStream(file)

		reply.send(stream).sent = true
