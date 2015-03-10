# Crul

Crul is a [curl](http://curl.haxx.se/) replacement, that is, it's a command line
HTTP client. It has less features and options, but it aims to be more user
friendly. It's heavily inspired by
[httpie](https://github.com/jakubroztocil/httpie).

It's written in the [Crystal](http://crystal-lang.org/) language.

## Features

* Fast
* No dependencies, easy to install
* Basic HTTP features (method, request body, headers)
* Syntax highlighting of the output (currently, only JSON)

## Planned features

* XML highlight
* User friendly headers and request body generation (similar to
[httpie's](https://github.com/jakubroztocil/httpie#request-items))
* Basic and digest authentication

## Installation

Download [the latest
binary](https://github.com/porras/crul/releases/download/v0.0.1a/crul) and put
it somewhere in your `$PATH`.

Currently, this release is only for Mac, if you want a Linux or Windows one, you
can build from sources, see [Development](#development).

## Usage

    Usage: crul [options] URL
        -X METHOD, --method METHOD       Use GET|POST|PUT|DELETE (default: GET)
        -d DATA, --data DATA             Request body
        -H HEADER, --header HEADER       Set header
        -j, --json                       Format response as JSON
        -h, --help                       Show this help

## Development

After checking out the repo, run `make` to run the tests and compile the source.

## Contributing

1. Fork it ( https://github.com/porras/crul/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

You can also contribute by trying it and reporting any
[issue](https://github.com/porras/crul/issues) you find.

## Copyright

Copyright (c) 2015 Sergio Gil. See
[LICENSE](https://github.com/porras/crul/blob/master/LICENSE.txt) for details.
