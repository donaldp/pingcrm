import { InertiaMiddleware } from '@formidablejs/inertia'
import { Account } from '../../Models/Account'
import { asObject } from '@formidablejs/framework/lib/Support/Helpers'
import { Request } from '@formidablejs/framework'
import { without } from '@formidablejs/framework/lib/Support/Helpers'

export class ShareAuthProps < InertiaMiddleware

	get user
		self.request.auth!.user!

	def share
		const { attributes } = await Account
			.where({ id: self.user.account_id })
			.fetch!

		return {
			auth: {
				user: {
					...without(asObject(self.user), [
						'password'
						'remember_token'
						'email_verified_at'
						'created_at'
						'updated_at'
						'deleted_at'
					])
					...{
						account: without(asObject(attributes), [
							'created_at'
							'updated_at'
						])
					}
				}
			}
		}
