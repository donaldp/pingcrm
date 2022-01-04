import { Request } from '@formidablejs/framework'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'

export class OrganizationFilter
	prop organizations
	prop request\Request

	def constructor organizations
		self.organizations = organizations

	static def make organizations
		new self(organizations)

	def using request\Request
		self.request = request

		self

	def filter
		self.search!
			.trashed!
			.get!

	def search
		self.organizations = self.organizations.filter do(organization)
			if isEmpty(self.request.query('search')) then return true

			const query = new RegExp(self.request.query('search'), 'ig')

			organization.name.search(query) !== -1

		self

	def trashed
		self.organizations = self.organizations.filter do(organization)
			if isEmpty(request.query('trashed')) || request.query('trashed') == 'with'
				return true

			organization.deleted_at !== null

		self

	def get
		self.organizations
