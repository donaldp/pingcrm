import { Account } from '../../Models/Account'
import { Inertia } from '@formidablejs/inertia'
import { Request } from '@formidablejs/framework'
import { without } from '@formidablejs/framework/lib/Support/Helpers'
import { Controller } from './Controller'

export class DashboardController < Controller

	def index request
		Inertia.render('Dashboard/Index')
