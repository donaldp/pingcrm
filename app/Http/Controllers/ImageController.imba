import { StreamImage } from '../../Utils/StreamImage'
import { Request } from '@formidablejs/framework'
import { Controller } from './Controller'

export class ImageController < Controller

	# Stream image to browser.
	#
	# @param {Request} request
	# @returns {StreamImage}

	def show request\Request
		StreamImage.make(request.param('image')).from('users')
