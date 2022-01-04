import { Inertia } from '@formidablejs/inertia'
import { Request } from '@formidablejs/framework'
import { Controller } from './Controller'

export class ReportsController < Controller

	def index
		Inertia.render('Reports/Index')
