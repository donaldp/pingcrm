import { Request } from '@formidablejs/framework'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'

export class UserFilter

	prop users
	prop request\Request

	def constructor users
		self.users = users

	static def make users
		new self(users)

	def using request\Request
		self.request = request

		self

	def filter
		self.search!
			.role!
			.trashed!
			.get!
			.sort do(a, b)
				"{a.attributes.first_name} {a.attributes.last_name}" > "{b.attributes.first_name} {b.attributes.last_name}" ? 1 : -1

	def search
		self.users = self.users.filter do({ attributes })
			if isEmpty(self.request.query('search')) then return true

			const query = new RegExp(self.request.query('search'), 'ig')
			const name = "{attributes.first_name} {attributes.last_name}"

			name.search(query) !== -1 || attributes.first_name.search(query) !== -1 || attributes.last_name.search(query) !== -1 || attributes.email.search(query) !== -1

		self

	def role
		self.users = self.users.filter do({ attributes })
			if isEmpty(request.query('role')) then return true

			const owner = request.query('role') == 'owner' ? 1 : null

			attributes.owner == owner

		self

	def trashed
		self.users = self.users.filter do({ attributes })
			if isEmpty(request.query('trashed')) || request.query('trashed') == 'with'
				return true

			attributes.deleted_at !== null

		self

	def get
		self.users
