const { Hash } = require("@formidablejs/framework");
const { Knex } = require('knex');
const faker = require('faker');

/** @param {Knex} knex */
exports.seed = function (knex) {
	// Deletes ALL existing entries
	return knex('users').del()
		.then(async function () {
			// Inserts seed entries
			const users = [
				{
					account_id: 1,
					first_name: 'John',
					last_name: 'Doe',
					email: 'johndoe@example.com',
					password: await Hash.make('secret'),
					owner: true
				}
			];

			for (i = 0; i < 5; i++) {
				const user = {
					account_id: 1,
					first_name: faker.name.firstName(),
					last_name: faker.name.firstName(),
					email: faker.internet.email(),
					password: await Hash.make('secret'),
				};

				users.push(user);
			}

			return knex('users').insert(users);
		});
};
