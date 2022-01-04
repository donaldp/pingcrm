import { @context } from '@formidablejs/framework'
import { Model } from '@formidablejs/framework'

@context
export class Account < Model

	# The name used to represent the model in the craftsman context.
	#
	# @type {String}

	static get context
		'Account'

	# The table associated with the model.
	#
	# @type {String}

	get tableName
		'accounts'

	# The attributes that should be hidden.
	#
	# @type {String[]}

	get hidden
		[]
