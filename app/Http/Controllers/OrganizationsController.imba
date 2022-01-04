import { @use } from '@formidablejs/framework'
import { Controller } from './Controller'
import { Database } from '@formidablejs/framework'
import { Inertia } from '@formidablejs/inertia'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'
import { Organization } from '../../Models/Organization'
import { Redirect } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { StoreOrganizationRequest } from '../Request/StoreOrganizationRequest'
import { UpdateOrganizationRequest } from '../Request/UpdateOrganizationRequest'

export class OrganizationsController < Controller

	def index request\Request
		const results = await Database.table('organizations')
			.where(do(q) isEmpty(request.query('search')) ? q : q.where('name', 'like', "%{request.query('search')}%"))
			.where(do(q) isEmpty(request.query('trashed')) || request.query('trashed') == 'with' ? q : q.whereNotNull('deleted_at'))
			.select(
				'id'
				'name'
				'phone'
				'city'
				'deleted_at'
			)
			.orderBy('name')
			.paginate({
				perPage: 10
				currentPage: Number(request.query('page', 1))
				isLengthAware: true
			})

		Inertia.render('Organizations/Index', {
			filters: request.all(['search', 'trashed'])
			organizations: paginate(results)
		})

	def create
		Inertia.render('Organizations/Create')

	@use(StoreOrganizationRequest)
	def store request\StoreOrganizationRequest
		await request.store!

		Redirect.route('organizations').with('success', 'Organization created.')

	def edit request\Request
		const organization = await new Organization({ id: request.param('id') }).fetch { withRelated: ['contacts'] }

		const { attributes } = organization

		Inertia.render('Organizations/Edit', {
			organization: {
				id: attributes.id
				name: attributes.name
				email: attributes.email
				phone: attributes.phone
				address: attributes.address
				city: attributes.city
				region: attributes.region
				country: attributes.country
				postal_code: attributes.postal_code
				deleted_at: attributes.deleted_at
				contacts: organization.related('contacts')
					.orderBy('name')
					.map do({ attributes })
						id: attributes.id
						name: "{attributes.first_name} {attributes.last_name}"
						city: attributes.city
						phone: attributes.phone
			}
		})

	@use(UpdateOrganizationRequest)
	def update request\UpdateOrganizationRequest
		await request.update!

		Redirect.back!.with('success', 'Organization updated.')

	def destroy request\Request
		if request.query('force') == 'true'
			await new Organization({ 'id': request.param('id') }).destroy!

			return Redirect.route('organizations')
				.with('success', 'Organization deleted.')

		await new Organization({ 'id': request.param('id') })
			.set({ deleted_at: Database.fn.now! })
			.save!

		Redirect.back!.with('success', 'Organization deleted.')

	def restore request\Request
		await new Organization({ 'id': request.param('id') })
			.set({ deleted_at: null })
			.save!

		Redirect.back!.with('success', 'Organization restored.')
