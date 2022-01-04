import { encrypt } from '@formidablejs/framework/lib/Support/Helpers'
import { existsSync } from 'fs-extra'
import { FormRequest } from '@formidablejs/framework'
import { Hash } from '@formidablejs/framework'
import { isEmpty } from '@formidablejs/framework/lib/Support/Helpers'
import { join } from 'path'
import { rmSync } from 'fs-extra'
import { User } from '../../Models/User'

export class UpdateUserRequest < FormRequest

	def authorize
		true

	def rules
		{
			first_name: 'required|max:50'
			last_name: 'required|max:50'
			email: 'required|max:50|email'
			password: 'nullable'
			owner: 'required|boolean'
			photo: 'nullable|image'
		}

	def update
		const updated = await new User!.where('id', '!=', self.param('id'))
			.where('email', self.input('email'))
			.fetch!
			.catch do
				await self.updateUser!
				await self.updateProfilePicture!
				await self.updatePassword!

				true

		updated == true ? true : false

	def updateUser
		await new User({ id: self.param('id') }).set({
			first_name: self.input('first_name')
			last_name: self.input('last_name')
			email: self.input('email')
			owner: self.input('owner')
		}).save!

	def updateProfilePicture
		if !self.hasFile('photo') then return

		const currentPhoto\String|null = self.user!.photo_path

		if !isEmpty(currentPhoto) && existsSync(currentPhoto)
			rmSync(currentPhoto)

		const name\String = "{encrypt(self.param('id'))}{self.file('photo').first!.ext}"
		const location\String = join('storage', 'framework', 'users', name)

		self.file('photo').first!.move(location, true)

		await new User({ id: self.param('id') }).set({
			photo_path: location
		}).save!

	def updatePassword
		if !self.has('password') then return

		await new User({ id: self.param('id') }).set({
			password: await Hash.make(self.input('password'))
		}).save!
