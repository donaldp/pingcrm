const { Knex } = require("knex");

/** @param {Knex} knex */
exports.up = (knex) => {
	return knex.schema.createTable('accounts', (table) => {
		table.increments('id').primary();
		table.string('name');
		table.timestamps(true, true);
	});
};

exports.down = (knex) => knex.schema.dropTable('accounts');
