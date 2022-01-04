import { Pagination } from '../../Utils/Pagination'
import { Controller as BaseController } from '@formidablejs/framework'
import { isArray } from '@formidablejs/framework/lib/Support/Helpers'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'

export class Controller < BaseController

	def paginate response
		if isArray(response.data) && !isEmpty(response.pagination)
			response.pagination.pages = Pagination.pages(response.pagination.total, response.pagination.perPage)
			response.pagination.links = Pagination.links(response.pagination, self.#request)

		response
