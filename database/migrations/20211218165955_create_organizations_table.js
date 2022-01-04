const { Knex } = require("knex");

/** @param {Knex} knex */
exports.up = (knex) => {
	return knex.schema.createTable('organizations', (table) => {
		table.increments('id').primary();
		table.integer('account_id').index();
		table.string('name');
		table.string('email').nullable();
		table.string('phone').nullable();
		table.text('address').nullable();
		table.string('city').nullable();
		table.string('region').nullable();
		table.string('country').nullable();
		table.string('postal_code').nullable();
		table.timestamp('deleted_at').nullable();
		table.timestamps(true, true);
	});
};

exports.down = (knex) => knex.schema.dropTable('organizations');
