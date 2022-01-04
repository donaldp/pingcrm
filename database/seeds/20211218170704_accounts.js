const { Knex } = require("knex");

/** @param {Knex} knex */
exports.seed = function (knex) {
	// Deletes ALL existing entries
	return knex('accounts').del()
		.then(function () {
			// Inserts seed entries
			return knex('accounts').insert([
				{
					name: 'Acme Corporation'
				}
			]);
		});
};
