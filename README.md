# Vend::Sync [![TravisCI][travis-img-url]][travis-ci-url]
[travis-img-url]: https://secure.travis-ci.org/crossroads/vend-sync.png?branch=master
[travis-ci-url]: http://travis-ci.org/crossroads/vend-sync

The vend-sync gem is a one-way sync from your Vend instance to a local database. Having the data locally makes it easier for you to produce your own reporting charts / dashboards that Vend otherwise may not provide.

It grabs information about outlets, products, customers, payment_types, registers, register_sales, taxes and users via the Vend API. It handles incremental updates and we usually run it daily to update the db with any new product/sales data.

## Installation

Add this line to your application's Gemfile:

    gem 'vend-sync'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vend-sync

## Usage

Either

    $ vend-sync account username password [database=vend_sync]

Or

    $ rake sync

## Setup

You should copy config/database.yml.example to config/database.yml and configure it correctly.

[rake task only] Copy config/vend.yml.example to config/vend.yml and configure it correctly.

## Deployment via Capistrano

Copy the following files and tweak them to your needs.

    config/deploy.rb.example -> config/deploy.rb
    config/deploy/production.rb.example -> config/deploy/production.rb
    
Git commit/push the changes and then run the deployment

    $ cap production deploy

This will deploy the code to the server and setup a cron task for actions to take place.

Note: you should also setup the following files on your deployment sever

    DEPLOYMENT_DIR/shared/config/database.yml
    DEPLOYMENT_DIR/shared/config/vend.yml
    DEPLOYMENT_DIR/shared/config/schedule.rb

and they will be copied to the current release during a deployment.

## Tests

Tests can be run using

    $ rake

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vend-sync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
