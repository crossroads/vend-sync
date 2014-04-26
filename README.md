# Vend::Sync

TODO: Write a gem description

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

## Tests

Tests can be run using

    $ rake

## Contributing

1. Fork it ( http://github.com/<my-github-username>/vend-sync/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
