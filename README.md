[![Build Status](https://travis-ci.org/b2b2dot0/fuey_client.png?branch=master)](https://travis-ci.org/b2b2dot0/fuey_client)
[![Code Climate](https://codeclimate.com/github/b2b2dot0/fuey_client.png)](https://codeclimate.com/github/b2b2dot0/fuey_client)

# Fuey::Client
![Hong Kong Phooey](http://popdose.com/wp-content/uploads/hong-kong-phooey-gal-4311.jpg)

Fuey is an inspection agent for helping to identify communication problems from your servers to it's resources. 
It currently supports the following checks:

| Operation | Supported | Notes                         |
| --------- |:---------:| ------------------------------|
| Ping      | X         |                               | 
| SNMPWalk  | X         |                               |
| SMTP      |           | |
| RFC Ping (SAP) | X    | Requires PiersHarding SAPNWRFC gem |


These checks can be chained together to create an availability trace of your machines required resources. The trace stops 
once a failure occurs with any of the inspections.

Inspections are logged in a central log file and updates are also sent to a Redis queue that can be monitored. There is currently
a Rails 4 web app in the works that displays a nice dashboard for all of the inspections and there current status, but it is not ready to
be open sourced at this moment. It will be soon though! 

All traces are easily configured in a YAML file. 

## Requirements

Fuey_Client currently supports Ruby _1.8.7_, _1.9_, and _2.0_. It also requires a Redis server to be setup and configured.
Fuey_Client has been tested against [Redis](http://redis.io) 2.6.10.

## Installation

Install the gem:

    $ gem install 'fuey_client'
    
## Configuration

Copy and modify the example [fuey config file](https://github.com/b2b2dot0/fuey_client/blob/master/config_example/fuey/config/fuey.yml) and
[redis config file](https://github.com/b2b2dot0/fuey_client/blob/master/config_example/fuey/config/redis.yml).
Place it where you would like to keep it and note the location. The file needs to be called `fuey.yml` and it needs to be in a 
directory called `fuey/config`. So an acceptable location would be, `/etc/fuey/config/fuey.yml`. The same is true for the redis.yml

## Usage

To run Fuey _(assuming your config file is located at /etc/fuey/config/fuey.yml)_:

    $ fuey /etc

Fuey output is logged to the logfile you identified in your `config.yml`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
