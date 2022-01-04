import { Contact } from './Contact'
import { @context } from '@formidablejs/framework'
import { Model } from '@formidablejs/framework'

@context
export class Organization < Model

	# The name used to represent the model in the craftsman context.
	#
	# @type {String}

	static get context
		'Organization'

	# The table associated with the model.
	#
	# @type {String}

	get tableName
		'organizations'

	# The attributes that should be hidden.
	#
	# @type {String[]}

	get hidden
		[]

	def contacts
		self.hasMany(Contact)
