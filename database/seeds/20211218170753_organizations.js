const { Knex } = require('knex');
const faker = require('faker');

/** @param {Knex} knex */
exports.seed = function (knex) {
	// Deletes ALL existing entries
	return knex('organizations').del()
		.then(function () {
			// Inserts seed entries
			const organizations = [];

			for (i = 0; i < 100; i++) {
				const organization = {
					account_id: 1,
					name: faker.company.companyName(),
					email: faker.internet.email(),
					phone: faker.phone.phoneNumber(),
					address: faker.address.streetAddress(),
					city: faker.address.city(),
					region: faker.address.state(),
					country: ['CA', 'US'][Math.floor((Math.random() * 1) + 0)],
					postal_code: faker.address.zipCode(),
				};

				organizations.push(organization);
			}

			return knex('organizations').insert(organizations);
		});
};
