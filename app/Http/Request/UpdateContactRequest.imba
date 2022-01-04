import { Contact } from '../../Models/Contact'
import { Organization } from '../../Models/Organization'
import { FormRequest } from '@formidablejs/framework'

export class UpdateContactRequest < FormRequest

	def authorize
		self.user!

	def asyncRules
		const ids = await self.organizationIds!

		{
			first_name: 'required|max:50'
			last_name: 'required|max:50'
			organization_id: "nullable|in:{ids}"
			email: 'nullable'
			phone: 'nullable'
			address: 'nullable'
			city: 'nullable'
			region: 'nullable'
			country: 'nullable|max:2|in:CA,US'
			postal_code: 'nullable'
		}

	def organizationIds
		const organizations = await new Organization!.where('account_id', self.user!.account_id)
			.query({ select: ['id'] })
			.fetchAll!

		organizations.map(do(org) org.id).join(',')

	def update
		await new Contact({ id: self.param('id') }).set(
			self.filled([
				'first_name'
				'last_name'
				'organization_id'
				'email'
				'phone'
				'address'
				'city'
				'region'
				'country'
				'postal_code'
			])
		).save!
