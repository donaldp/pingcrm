const { Knex } = require("knex");

/** @param {Knex} knex */
exports.up = (knex) => {
	return knex.schema.createTable('users', (table) => {
		table.increments('id').primary();
		table.integer('account_id').index();
		table.string('first_name');
		table.string('last_name');
		table.string('email').unique();
		table.string('password');
		table.boolean('owner').defaultTo(false);
		table.string('photo_path').nullable();
		table.string('remember_token').nullable();
		table.timestamp('email_verified_at').nullable();
		table.timestamp('deleted_at').nullable();
		table.timestamps(true, true);
	});
}

exports.down = (knex) => knex.schema.dropTable('users');
