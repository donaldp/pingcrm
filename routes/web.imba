import { ContactsController } from '../app/Http/Controllers/ContactsController'
import { DashboardController } from '../app/Http/Controllers/DashboardController'
import { ImageController } from '../app/Http/Controllers/ImageController'
import { OrganizationsController } from '../app/Http/Controllers/OrganizationsController'
import { PrivateResource } from '../app/Http/Middleware/PrivateResource'
import { ReportsController } from '../app/Http/Controllers/ReportsController'
import { Route } from '@formidablejs/framework'
import { ShareAuthProps } from '../app/Http/Middleware/ShareAuthProps'
import { UsersController } from '../app/Http/Controllers/UsersController'

# --------------------------------------------------------------------------
# Web Routes
# --------------------------------------------------------------------------
#
# Here is where you can register API routes for your application. These
# routes are loaded by the RouteServiceResolver within a group which
# is assigned the "session" middleware group.

Route.group { middleware: ['auth', ShareAuthProps] }, do
	Route.get('/', [DashboardController, 'index']).name('home')

	Route.group { prefix: 'users' }, do
		Route.get('/', [UsersController, 'index']).name('users')
		Route.get('create', [UsersController, 'create']).name('users.create')
		Route.post('/', [UsersController, 'store']).name('users.store')
		Route.get(':id/edit', [UsersController, 'edit']).name('users.edit')
		Route.post(':id', [UsersController, 'update']).name('users.update')
		Route.post(':id/delete', [UsersController, 'destroy']).name('users.delete')
		Route.post(':id/restore', [UsersController, 'restore']).name('users.restore')

	Route.group { prefix: 'organizations' }, do
		Route.get('/', [OrganizationsController, 'index']).name('organizations')
		Route.get('create', [OrganizationsController, 'create']).name('organizations.create')
		Route.post('/', [OrganizationsController, 'store']).name('organizations.store')
		Route.get(':id/edit', [OrganizationsController, 'edit']).name('organizations.edit')
		Route.post(':id', [OrganizationsController, 'update']).name('organizations.update')
		Route.post(':id/delete', [OrganizationsController, 'destroy']).name('organizations.delete')
		Route.post(':id/restore', [OrganizationsController, 'restore']).name('organizations.restore')

	Route.group { prefix: 'contacts' }, do
		Route.get('/', [ContactsController, 'index']).name('contacts')
		Route.get('create', [ContactsController, 'create']).name('contacts.create')
		Route.post('/', [ContactsController, 'store']).name('contacts.store')
		Route.get(':id/edit', [ContactsController, 'edit']).name('contacts.edit')
		Route.post(':id', [ContactsController, 'update']).name('contacts.update')
		Route.post(':id/delete', [ContactsController, 'destroy']).name('contacts.delete')
		Route.post(':id/restore', [ContactsController, 'restore']).name('contacts.restore')

	Route.group { prefix: 'reports' }, do
		Route.get('/', [ReportsController, 'index']).name('reports')

	Route.get('img/:image', [ImageController, 'show']).middleware([PrivateResource])
