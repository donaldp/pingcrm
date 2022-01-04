import { @use } from '@formidablejs/framework'
import { Controller } from './Controller'
import { Inertia } from '@formidablejs/inertia'
import type { InertiaResponse } from '@formidablejs/inertia'

export class AuthenticationController < Controller

	def login
		Inertia.render('Auth/Login')
