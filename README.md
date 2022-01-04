# Ping CRM

A demo application to illustrate how Inertia.js works with Formidable.

![](https://raw.githubusercontent.com/donaldp/pingcrm/main/screenshot.png)

## Installation

Clone the repo locally:

```sh
git clone https://github.com/donaldp/pingcrm.git pingcrm
cd pingcrm
```

Install CLI:

```sh
npm i -g @formidablejs/craftsman
```

Install NPM dependencies:

```sh
npm i --legacy-peer-deps
```

Build assets:

```sh
npm run mix:dev
```

Setup configuration:

```sh
cp .env.example .env
```

Generate application key:

```sh
craftsman key
```

Create an SQLite database. You can also use another database (MySQL, Postgres), simply update your configuration accordingly.

```sh
touch database/database.sqlite
```

Run database migrations:

```sh
craftsman migrate latest
```

Run database seeder:

```sh
craftsman seed
```

Run the dev server (the output will give the address):

```sh
craftsman serve --dev
```

You're ready to go! Visit Ping CRM in your browser, and login with:

- **Username:** johndoe@example.com
- **Password:** secret

## Running tests

- &#9746; Todo
