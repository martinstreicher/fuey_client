[![Build Status](https://travis-ci.org/b2b2dot0/fuey_client.png?branch=master)](https://travis-ci.org/b2b2dot0/fuey_client)
[![Code Climate](https://codeclimate.com/repos/5203a52189af7e65a002c4a5/badges/6fe497d679e5e80d0770/gpa.png)](https://codeclimate.com/repos/5203a52189af7e65a002c4a5/feed)

# Fuey::Client

Fuey currently supports pinging hosts only. This is great for ensuring your servers are live. You can easily tie this to a cron job that
runs at an interval or write your own Ruby script to run it continually.

## Installation

Install the gem:

    gem 'fuey_client'

Copy and modify the example [config file](https://github.com/b2b2dot0/fuey_client/blob/master/config_example/fuey/config.yml).
Place it where you would like to keep it and note the location. The file needs to be called `config.yml` and it needs to be in a directory called
`fuey`. So an acceptable location would be, `/etc/fuey/config.yml`.

## Usage

To run Fuey _(assuming your config file is located at /etc/fuey/config.yml)_:

    $ fuey /etc

Fuey output is logged to the logfile you identified in your `config.yml`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
