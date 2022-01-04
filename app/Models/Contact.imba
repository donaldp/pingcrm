import { @context } from '@formidablejs/framework'
import { Model } from '@formidablejs/framework'

@context
export class Contact < Model

	# The name used to represent the model in the craftsman context.
	#
	# @type {String}

	static get context
		'Contact'

	# The table associated with the model.
	#
	# @type {String}

	get tableName
		'contacts'

	# The attributes that should be hidden.
	#
	# @type {String[]}

	get hidden
		[]
