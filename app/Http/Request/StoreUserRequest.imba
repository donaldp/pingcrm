import { User } from '../../Models/User'
import { Hash } from '@formidablejs/framework'
import { FormRequest } from '@formidablejs/framework'
import { encrypt } from '@formidablejs/framework/lib/Support/Helpers'
import { join } from 'path'

export class StoreUserRequest < FormRequest

	def authorize
		true

	def rules
		{
			first_name: 'required|max:50'
			last_name: 'required|max:50'
			email: 'required|max:50|email'
			password: 'nullable|min:8'
			owner: 'boolean'
			photo: 'nullable|image'
		}

	def store
		const exists = await new User!.where('email', self.input('email')).count! > 0

		if exists then return false

		const user = await self.createUser!

		await self.setProfilePicture(user)

		true

	def createUser
		await new User!.set({
			first_name: self.input('first_name')
			last_name: self.input('last_name')
			email: self.input('email')
			password: await Hash.make(self.input('password', 'secret'))
			owner: self.input('owner')
		}).save!

	def setProfilePicture user
		if !self.hasFile('photo') then return

		const name = "{encrypt(user.id)}{self.file('photo').first!.ext}"
		const location = join('storage', 'framework', 'users', name)

		self.file('photo').first!.move(location)

		await new User({ id: user.id }).set({
			photo_path: location
		}).save!
