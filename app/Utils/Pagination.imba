import { Request } from '@formidablejs/framework'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'

export class Pagination

	static def pages total, perPage
		total / perPage

	static def links object, request\Request
		const all = []

		if object.pages > 0
			all.push {
				active: false
				label: "&laquo; Previous"
				url: self.getPrevLink(request)
			}

		for i in [1 .. object.pages]
			let url = "{request.urlWithoutQuery!}?page={i}"

			Object.keys(request.query!).map do(query, position)
				if query !== 'page'
					url = url.concat "&{query}={Object.values(request.query!)[position]}"

			all.push {
				active: i == Number(request.query('page', 1))
				label: i
				url: url
			}

		if object.pages > 0
			all.push {
				active: false
				label: "Next &raquo;"
				url: self.getNextLink(request, object.pages)
			}

		all

	static def getPrevLink request\Request
		let url\String|null = Number(request.query('page', 1)) > 1 ? "{request.urlWithoutQuery!}?page={Number(request.query('page', 1)) - 1 }" : null

		if isEmpty(url) then return url

		Object.keys(request.query!).map do(query, position)
			if query !== 'page'
				url = url.concat "&{query}={Object.values(request.query!)[position]}"

		url

	static def getNextLink request\Request, total\Number
		let url\String|null = Number(request.query('page', 1)) < total ? "{request.urlWithoutQuery!}?page={Number(request.query('page', 1)) + 1 }" : null

		if isEmpty(url) then return url

		Object.keys(request.query!).map do(query, position)
			if query !== 'page'
				url = url.concat "&{query}={Object.values(request.query!)[position]}"

		url
