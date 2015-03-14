# Crul

Crul is a [curl](http://curl.haxx.se/) replacement, that is, it's a command line
HTTP client. It has less features and options, but it aims to be more user
friendly. It's heavily inspired by
[httpie](https://github.com/jakubroztocil/httpie).

It's written in the [Crystal](http://crystal-lang.org/) language. It's in an
early stage but it allows already basic usage.

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
* More fancy stuff

## Installation

Download [the latest release](https://github.com/porras/crul/releases) and unzip
it somewhere in your `$PATH`.

Currently, this release is only for Mac, if you want a Linux or Windows one, you
can build from sources, see [Development](#development).

## Usage

    Usage: crul [method] URL [options]
        get, GET                         Use GET (default)
        post, POST                       Use POST
        put, PUT                         Use PUT
        delete, DELETE                   Use DELETE
        -d DATA, --data DATA             Request body
        -H HEADER, --header HEADER       Set header
        -j, --json                       Format response as JSON
        -h, --help                       Show this help

## Examples

### GET request

    $ crul http://httpbin.org/get?a=b
    HTTP/1.1 200 OK
    Server: nginx
    Date: Wed, 11 Mar 2015 07:57:33 GMT
    Content-type: application/json
    Content-length: 179
    Connection: keep-alive
    Access-control-allow-origin: *
    Access-control-allow-credentials: true

    {
      "args": {
        "a": "b"
      },
      "headers": {
        "Content-Length": "0",
        "Host": "httpbin.org"
      },
      "origin": "188.103.25.204",
      "url": "http://httpbin.org/get?a=b"
    }

### PUT request

    $ crul put http://httpbin.org/put -d '{"a":"b"}' -H Content-Type:application/json
    HTTP/1.1 200 OK
    Server: nginx
    Date: Wed, 11 Mar 2015 07:58:54 GMT
    Content-type: application/json
    Content-length: 290
    Connection: keep-alive
    Access-control-allow-origin: *
    Access-control-allow-credentials: true

    {
      "args": {},
      "data": "{\"a\":\"b\"}",
      "files": {},
      "form": {},
      "headers": {
        "Content-Length": "9",
        "Content-Type": "application/json",
        "Host": "httpbin.org"
      },
      "json": {
        "a": "b"
      },
      "origin": "188.103.25.204",
      "url": "http://httpbin.org/put"
    }

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
