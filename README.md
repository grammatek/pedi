# PEDI - A Pronunciation Dictionary Editor

Pedi is a web application to read, edit and export pronunciation dictionaries. 

## Features of PEDI

### Import SAMPA list

A SAMPA list can be imported into the web application. You can find a sample list inside the sample-data/ sub directory.

### Import CSV text files as pronunciation dictionaries

A dictionary is made up of CSV formatted text and has the following format:

|  **WORD** | **SAMPA PRONUNCIATION**  | **POS** | **PRON_VARIANT** | **IS_COMPOUND** | **COMPOUND_ATTR** | **HAS_PREFIX** | **LANG** | **IS_VALIDATED** | **COMMENT** |
|---|---|---|---|---|---|---|---|---|---|
| hvass | x a s | lo | south_clear | false | none| false | IS | false |
| einhverri | ei N k_h v E r I | fn | northeast_clear | false | none | false | IS | false | Vantar entry (south) |
| þurftu | T Y r_0 t Y | so | all | false | none | false | IS | false |
| ... | ... | ... | ... | ... | ... | ... | ... | ... | ... |

When importing, the name of the dictionary is set by the user. The import functionality saves the dictionary into an internal database table.


### Show overview of dictionaries

Imported dictionaries are shown in a list view with number of entries and options to delete or export them as CSV lists.

### Show and edit contents of a dictionary

An imported dictionary is organized as list of entries:
- Word
- SAMPA pronunciation
- Editing status
- Comment
- Language
- POS tag
- Component part
- Dialect
- boolean if word is a compound
- boolean if word starts with a prefix

Entries are shown paginated if they don't fit on a page.

#### Incorrect phonetic transcriptions

If a transcription of an entry is incorrect, there appears a colored yellow marking of the incorrect transcription. A violation of the following rules are therefore marked as incorrect:

- All SAMPA pronunciation symbols have to be separated by a space
- All symbols have to be part of the well defined SAMPA symbol set

#### Filters

Entries can be filtered via the following criteria:

- Word as Regular Expression
- SAMPA transcription as Regular Expression
- Comment as Regular Expression
- Warnings

#### Editing

It is possible to edit the following attributes of a dictionary entry:

- Word
- SAMPA pronunciation
- Editing status
- Comment
- Language
- POS tag
- Component part
- Dialect
- boolean if word is a compound
- boolean if word starts with a prefix

### Export SAMPA  dictionaries as CSV text files

Every dictionary can be exported to a local file on disk with the same CSV format as described in the import section. If multiple dictionaries are selected, all of these will be exported into one CSV file.

### User Authentication

There is a basic user authentication to access the web application. All users share the same rights. Default user and password is admin@example.com/admin_password.

### I8N

The application is available in Icelandic and English. Icelandic is the default language. You can choose either language from a drop-down list at the top right. 

## Getting started

First make sure to have Ruby installed. The currently used version of Ruby as of the Gemfile is `2.6.8`. It is recommended to use either [rvm](https://rvm.io/) or
[rbenv](https://github.com/rbenv/rbenv) for your Ruby installations.

After making sure, the correct Ruby version is installed, run `bundle` in the root directory.

### Install node + yarn
You need to install [node.js](https://nodejs.org/en/) and [yarn](https://yarnpkg.com/) for managing the dependencies for the Javascript part of the Rails application.
On a Mac, you probably should use [homebrew](https://brew.sh/index_de) to install these prerequisites. Unfortunately, we had a lot of problems with recent node.js version dependencies,
therefore use the following commands to install these prerequisites on your Mac at a specific version known for us to work:

```bash
brew install node@14
export PATH="/usr/local/opt/node@14/bin:$PATH"
npm install --global yarn
```

### Prepare running the Ruby on Rails application
```bash
rails assets:precompile
rails db:prepare
````

The seed data in `db/seed.rb` should give you an idea how you can customize users/passwords to your needs.

For subsequents updates of this application, you just need to use these commands:

```bash
# Just in case, you changed the database schema. otherwise omit this step
rails db:migrate 

# To start the rails application in development mode
rails server
```
If you see any problems related to yarn, try to call the following command in a terminal:

```bash
yarn install --check-files
```
After finishing the above steps, you should be able to access the web application on [localhost:3000](http://localhost:3000)

## TTS
You can choose either the Tiro TTS service or Amazon Polly as TTS speech output to read pronunciation of words.
The former is recommended, as it includes the same Icelandic voices as Amazon Polly anyway and you don't need to configure
access credentials you would need for accessing the Amazon Polly service.

The TTS backend is configurable in the file config/application.rb under key `config.tts_backend`. After changing this
value, you should restart the Rails application and also your browser, because the voice list is saved inside your
browsers session storage and has to be renewed. If you don't change any value here, the Tiro service is used by default.

If you choose Polly, additionally you need to configure Polly API authorization. The Polly API access to Amazon Cloud
services is implemented by Pedi via the
[Rails credential system](https://edgeguides.rubyonrails.org/security.html#custom-credentials).
The following credential keys should be added to the application credentials via `rails credentials:edit`:

```ruby
# amazon Polly credentials
amazon_polly_key: <your amazon polly key>
amazon_polly_secret: <your amazon polly secret>
```

You need to register at Amazon, to request your personal credentials.

## Production setup

For running PEDI in a production environment, a docker-compose file has been provided. Here are the steps to build your
containers and run them locally:

### Building via docker-compose

The building step copies your local PEDI directory inside the container and initializes the application. As this is a
production setup instead of a development or testing environment, we use a PostgreSQL database and also an NGINX server
for proxying outside requests. To access PostgreSQL, you need to define database credentials.
In the build step for docker-compose, you need to provide an `.env` file in your PEDI main directory with the
following entries:
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<your-secret-password>
SECRET_KEY_BASE=<your-secret-keybase>
RAILS_SERVE_STATIC_FILES=true
```

To generate your Rails secret key base, type the following in the command shell and fill in the variable `SECRET_KEY_BASE`
of your `.env` file with its output.

```bash
rake secret
```

Afterwards, run the following command:

```bash
docker-compose build
```

### Running containers locally

After building the containers, you need  to create a virtual network plane for your containers. To test your environment
locally, it's also a good practice to use a `docker-compose.override.yml` file, where you define your local settings at the
time of running the containers. But for a real production setup on a server, you would not use this file.

```yaml
version: '3'

services:
  app_pedi:
    build:
      context: .
    volumes:
      # maps your current directory to a subdirectory /project/src inside the app_pedi container
      - ./:/project/src

  web:
    # this makes it possible to run docker-compose locally and then
    # to reach the app at localhost:8080
    ports:
      - "8080:8080"
```

Start the application:

```bash
docker network create production_docker
docker-compse up -d
```

If you have used the above `docker-compose.override.yml` file, you should be able to access the application at
`http://localhost:8080`.

## Trouble shooting & inquiries

This application is still in development. If you encounter any errors, feel free to open an issue inside the
[issue tracker](https://github.com/grammatek/pedi/issues). You can also [contact us](mailto:info@grammatek.com) via email.

## Contributing

You can contribute to this project by forking it, creating a private branch and opening a new [pull request](https://github.com/grammatek/pedi/pulls).  

## License

[![Grammatek](app/assets/images/grammatek-logo-small.png)](https://www.grammatek.com)

Copyright © 2020, 2021 Grammatek ehf.

This software is developed under the auspices of the Icelandic Government 5-Year Language Technology Program, described
[here](https://www.stjornarradid.is/lisalib/getfile.aspx?itemid=56f6368e-54f0-11e7-941a-005056bc530c) and
[here](https://clarin.is/media/uploads/mlt-en.pdf) (English).

This software is licensed under the [Apache License](LICENSE)
