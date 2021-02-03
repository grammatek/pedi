# Pedi - A Pronunciation Dictionary Editor

Pedi is a web application to read, edit and export pronunciation dictionaries. 

## Features of the Prototype

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

First make sure to have Ruby installed. Afterwards, run `bundle` in the root directory. Then follow these steps:

```bash
rails db:create
rails db:migrate
rails db:seed
rails server
````
The seed data should be enough to give you an idea how this application works.

For subsequents updates of this application, you just need to use these commands:

```bash
rails db:migrate
rails server
```

If you see any problems related to yarn, try to call the following command in a terminal:

```
yarn install --check-files
```
After finishing the above steps, you should be able to access the web application on [localhost:3000](http://localhost:3000)

## TTS

Currently, Pedi uses Amazon Polly to 'play' the phonemes. This requires Polly API access to Amazon Cloud services.
The way how Pedi implements authentication for Amazon Polly, is implemented via the
[Rails credential system](https://edgeguides.rubyonrails.org/security.html#custom-credentials).
The following credential keys should be added to the application credentials via `rails credentials:edit`:

```ruby
# amazon Polly credentials
amazon_polly_key: <your amazon polly key>
amazon_polly_secret: <your amazon polly secret>
```

## Trouble shooting & inquiries

This application is still in development. If you encounter any errors, feel free to open an issue inside the
[issue tracker](https://github.com/grammatek/pedi/issues). You can also [contact us](mailto:info@grammatek.com) via email.

## Contributing

You can contribute to this project by forking it, creating a private branch and opening a new [pull request](https://github.com/grammatek/pedi/pulls).  
