import { @use } from '@formidablejs/framework'
import { basename } from 'path'
import { Controller } from './Controller'
import { Database } from '@formidablejs/framework'
import { Inertia } from '@formidablejs/inertia'
import { join } from 'path'
import { Redirect } from '@formidablejs/framework'
import { Request } from '@formidablejs/framework'
import { StoreUserRequest } from '../Request/StoreUserRequest'
import { UpdateUserRequest } from '../Request/UpdateUserRequest'
import { User } from '../../Models/User'
import { UserFilter } from '../../Utils/UserFilter'
import { ValidationException } from '@formidablejs/framework'

export class UsersController < Controller

	def index request\Request
		const users = await User.fetchAll!

		Inertia.render('Users/Index', {
			filters: request.all(['search', 'role', 'trashed'])
			users: UserFilter.make(users)
				.using(request)
				.filter!
				.map do({ attributes })
					{
						id: attributes.id
						name: "{attributes.first_name} {attributes.last_name}"
						email: attributes.email
						owner: attributes.owner
						photo: attributes.photo_path ? "/{join('img', basename(attributes.photo_path))}" : null
						deleted_at: attributes.deleted_at
					}
		})

	def create
		Inertia.render('Users/Create')

	@use(StoreUserRequest)
	def store request\StoreUserRequest
		const created = await request.store!

		if !created
			throw ValidationException.withMessages({
				email: [ 'The email has already been taken.' ]
			})

		Redirect.route('users').with('success', 'User created.')

	@use(User)
	def edit user\User
		const { attributes } = await user

		Inertia.render('Users/Edit', {
			user: {
				id: attributes.id
				first_name: attributes.first_name
				last_name: attributes.last_name
				email: attributes.email
				owner: attributes.owner ? true : false
				photo: attributes.photo_path ? "/{join('img', basename(attributes.photo_path))}" : null
				deleted_at: attributes.deleted_at
			}
		})

	@use(UpdateUserRequest)
	def update request\UpdateUserRequest
		const updated = await request.update!

		if !updated
			throw ValidationException.withMessages({
				email: [ 'The email has already been taken.' ]
			})

		Redirect.back!.with('success', 'User updated.')

	def destroy request\Request
		if request.query('force') == 'true'
			await new User({ 'id': request.param('id') }).destroy!

			return Redirect.route('users').with('success', 'User deleted.')

		await new User({ 'id': request.param('id') })
			.set({ deleted_at: Database.fn.now! })
			.save!

		Redirect.back!.with('success', 'User deleted.')

	def restore request\Request
		await new User({ 'id': request.param('id') })
			.set({ deleted_at: null })
			.save!

		Redirect.back!.with('success', 'User restored.')
