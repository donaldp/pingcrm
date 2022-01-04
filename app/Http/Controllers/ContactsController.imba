import { @use } from '@formidablejs/framework'
import { Contact } from '../../Models/Contact'
import { Controller } from './Controller'
import { Database } from '@formidablejs/framework'
import { Inertia } from '@formidablejs/inertia'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'
import { Organization } from '../../Models/Organization'
import { Redirect } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { StoreContactRequest } from '../Request/StoreContactRequest'
import { UpdateContactRequest } from '../Request/UpdateContactRequest'
import { ValidationException } from '@formidablejs/framework'
import type { InertiaResponse } from '@formidablejs/inertia'

export class ContactsController < Controller

	def index request\Request
		const results = await Database.table('contacts')
			.where(do(query)
				query.where(do(q) isEmpty(request.query('search')) ? q : q.where('contacts.first_name', 'like', "%{request.query('search')}%"))
					.orWhere(do(q) isEmpty(request.query('search')) ? q : q.where('contacts.last_name', 'like', "%{request.query('search')}%"))
					.orWhere(do(q) isEmpty(request.query('search')) ? q : q.where('contacts.email', 'like', "%{request.query('search')}%"))
			)
			.where(do(q) isEmpty(request.query('trashed')) || request.query('trashed') == 'with' ? q : q.whereNotNull('contacts.deleted_at'))
			.join('organizations as organization', do(q) q.on('contacts.organization_id', '=', 'organization.id'))
			.select(
				'contacts.id'
				'contacts.first_name'
				'contacts.last_name'
				'contacts.phone'
				'contacts.city'
				'contacts.deleted_at'
				'organization.name as organization_name'
			)
			.orderBy([
				{ column: 'first_name', order: 'asc' }
				{ column: 'last_name', order: 'asc' }
			])
			.paginate({
				perPage: 10
				currentPage: Number(request.query('page', 1))
				isLengthAware: true
			})

		results.data = results.data
			.map do(contact)
				id: contact.id
				name: "{contact.first_name} {contact.last_name}"
				phone: contact.phone
				city: contact.city
				deleted_at: contact.deleted_at
				organization: {
					name: contact.organization_name
				}

		Inertia.render('Contacts/Index', {
			filters: request.all(['search', 'trashed'])
			contacts: paginate(results)
		})

	def create request\Request
		const organizations = await new Organization!.where('account_id', request.user!.account_id)
			.query({ select: ['id', 'name'] })
			.fetchAll!

		Inertia.render('Contacts/Create', {
			organizations: organizations.map do({ attributes })
				id: attributes.id
				name: attributes.name
		})

	@use(StoreContactRequest)
	def store request\StoreContactRequest
		const rules = await request.asyncRules!

		const validation = request.validate(rules)

		if validation.fails!
			throw ValidationException.withMessages(validation.errors.errors)

		await request.store!

		Redirect.route('contacts').with('success', 'Contact created.')

	@use(Contact)
	def edit contact\Contact, request\Request
		const { attributes } = await contact
		const organizations = await new Organization!.where('account_id', request.user!.account_id).fetchAll!

		Inertia.render('Contacts/Edit', {
			contact: {
				id: attributes.id
				first_name: attributes.first_name
				last_name: attributes.last_name
				organization_id: attributes.organization_id
				email: attributes.email
				phone: attributes.phone
				address: attributes.address
				city: attributes.city
				region: attributes.region
				country: attributes.country
				postal_code: attributes.postal_code
				deleted_at: attributes.deleted_at
			}
			organizations: organizations.map do({ attributes })
				id: attributes.id
				name: attributes.name
		})

	@use(UpdateContactRequest)
	def update request\UpdateContactRequest
		const rules = await request.asyncRules!

		const validation = request.validate(rules)

		if validation.fails!
			throw ValidationException.withMessages(validation.errors.errors)

		await request.update!

		Redirect.back!.with('success', 'Contact updated.')

	def destroy request\Request
		if request.query('force') == 'true'
			await new Contact({ 'id': request.param('id') }).destroy!

			return Redirect.route('contacts')
				.with('success', 'Contact deleted.')

		await new Contact({ 'id': request.param('id') })
			.set({ deleted_at: Database.fn.now! })
			.save!

		Redirect.back!.with('success', 'Contact deleted.')

	def restore request\Request
		await new Contact({ 'id': request.param('id') })
			.set({ deleted_at: null })
			.save!

		Redirect.back!.with('success', 'Contact restored.')
