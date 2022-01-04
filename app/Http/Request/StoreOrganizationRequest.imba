import { Organization } from '../../Models/Organization'
import { FormRequest } from '@formidablejs/framework'

export class StoreOrganizationRequest < FormRequest

	def authorize
		self.user!

	def rules
		{
			name: 'required|max:100'
			email: 'nullable|max:50|email'
			phone: 'nullable|max:50'
			address: 'nullable|max:150'
			city: 'nullable|max:50'
			region: 'nullable|max:50'
			country: 'nullable|max:2|in:CA,US'
			postal_code: 'nullable|max:25'
		}

	def store
		await new Organization!.set(
			self.filled([
				'name'
				'email'
				'phone'
				'address'
				'city'
				'region'
				'country'
				'postal_code'
			])
		).save!
