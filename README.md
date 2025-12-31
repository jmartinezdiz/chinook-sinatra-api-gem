# NetJSON

This repository contains an example of JSON API using SQLite and Sinatra with Chinook database.

This repository is designed for educational purposes.

## Installation

Install the gem and add to the application's Gemfile by executing:

To install gem and add this line to your application's Gemfile:

    gem 'chinook_sinatra_api', git: 'https://github.com/jmartinezdiz/chinook-sinatra-api-gem.git', tag: 'X.X.X'

And then execute:

    $ bundle install

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem 'chinook_sinatra_api', git: 'https://github.com/jmartinezdiz/chinook-sinatra-api-gem.git', tag: 'X.X.X'

## Run server

### Standalone

Server can be launched directly using on console:

    $ chinook_sinatra_api_server

Script allows next options:

* -p, --port: Port that should be used when starting the built-in web server
* -b, --bind: String specifying the hostname or IP address of the interface to listen on
* -h, --help: Show available options

### In code

Server can be launched in code with:

```ruby
ChinookSinatraApi::Server.run!
```

## Usage

Server has three endpoints to read data from Chinook database using JSON format.

The endpoints behavoir are detailed below.

### get /:table_name

It allows to retrieve all data on a table.

* Route parameters:
    * table_name: Name of database table.

Example:

    $ curl http://localhost:4567/media_types

### get /:table_name/:id

It allows to retrieve a row using the table primary key. It only supports tables with single primary key.

* Route parameters
    * id: Row identifier value.

Example:

    $ curl http://localhost:4567/media_types/1

### post /:table_name/search_all

It allows to retrieve all data on a table that meets a series of conditions.

* Route parameters:
    * table_name: Name of database table.
* Body
    * conditions: Hash with conditions to search. Hash keys are the name of column and their value are the value to filter rows. Each condition is joined with AND operation.

Example:

    $ curl -s -H "Content-Type: application/json" \
        -H "Accept: application/json" \
        -d "{\"conditions\":{\"CustomerId\":1,\"Country\":\"Brazil\"}}" \
        http://localhost:4567/customers/search_all

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jmartinezdiz/chinook-sinatra-api-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jmartinezdiz/chinook-sinatra-api-gem/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the List project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jmartinezdiz/chinook-sinatra-api-gem/blob/master/CODE_OF_CONDUCT.md).
