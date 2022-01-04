const { Knex } = require('knex');
const faker = require('faker');

/** @param {Knex} knex */
exports.seed = function (knex) {
	// Deletes ALL existing entries
	return knex('contacts').del()
		.then(function () {
			// Inserts seed entries

			const contacts = [];

			for (i = 0; i < 100; i++) {
				const contact = {
					account_id: 1,
					organization_id: Math.floor((Math.random() * 100) + 1),
					first_name: faker.name.firstName(),
					last_name: faker.name.lastName(),
					email: faker.internet.email(),
					phone: faker.phone.phoneNumber(),
					address: faker.address.streetName(),
					city: faker.address.city(),
					region: faker.address.state(),
					country: ['CA', 'US'][Math.floor((Math.random() * 1) + 0)],
					postal_code: faker.address.zipCode(),
				};

				contacts.push(contact);
			}

			return knex('contacts').insert(contacts);
		});
};
