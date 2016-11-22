# Crul [![Build Status](https://travis-ci.org/porras/crul.svg?branch=master)](https://travis-ci.org/porras/crul)

Crul is a [curl](http://curl.haxx.se/) replacement, that is, it's a command line
HTTP client. It has fewer features and options, but it aims to be more user
friendly. It's heavily inspired by
[httpie](https://github.com/jakubroztocil/httpie).

It's written in the [Crystal](http://crystal-lang.org/) language. It's in an
early stage but it allows already basic usage.

## Features

* Fast
* No dependencies, easy to install
* Basic HTTP features (method, request body, headers)
* Syntax highlighting of the output (JSON and XML)
* Basic authentication
* Cookie store
* Bash completion of commands and options

## Planned features

* User friendly headers and request body generation (similar to
[httpie's](https://github.com/jakubroztocil/httpie#request-items))
* Digest authentication
* More fancy stuff

## Installation

### Mac

    brew tap porras/crul
    brew install crul

Or, if you want to install the latest, unreleased version:

    brew tap porras/tap
    brew install crul --HEAD

### Linux

#### Ubuntu/Debian

There is an APT repository with signed packages of the latest crul version. To setup this repo and install crul, run the following commands (as root or with sudo):

    apt-key adv --keyserver keys.gnupg.net --recv-keys ED2715FE
    echo "deb http://iamserg.io/deb packages main" > /etc/apt/sources.list.d/iamserg.io.list
    apt-get update
    apt-get install crul

#### Other distributions

See how to [install from source](#from-source) below.

### From source

If there are no binary packages for your OS version, you can install `crul` [downloading the zip or tarball](https://github.com/porras/crul/releases/latest) and building it from source. See
[Development](#development) for instructions.

## Completion

After installation, add this line to your `.bashrc` (only Bash supported at this moment):

    eval "$(crul --completion)"

You don't need this if you installed via Homebrew (it's automatic).

## Usage

    Usage: crul [method] URL [options]

    HTTP methods (default: GET):
        get, GET                         Use GET
        post, POST                       Use POST
        put, PUT                         Use PUT
        delete, DELETE                   Use DELETE

    HTTP options:
        -d DATA, --data DATA             Request body
        -d @file, --data @file           Request body (read from file)
        -H HEADER, --header HEADER       Set header
        -a USER:PASS, --auth USER:PASS   Basic auth
        -c FILE, --cookies FILE          Use FILE as cookie store (reads and writes)

    Response formats (default: autodetect):
        -j, --json                       Format response as JSON
        -x, --xml                        Format response as XML
        -p, --plain                      Format response as plain text

    Other options:
        -h, --help                       Show this help
        -V, --version                    Display version

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

You'll need [Crystal 0.19](http://crystal-lang.org/docs/installation/index.html) installed (it might work with older
or newer versions, but that's the one that's tested).

After checking out the repo (or decompressing the tarball with the source code), run `shards` to get
the development dependencies, and `make` to run the tests and compile the source. Optionally, you
can run `make install` to install it (as a default, in /usr/local/bin, override it running
`PREFIX=/opt/whatever make install`).

## Contributing

1. Fork it ( https://github.com/porras/crul/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

You can also contribute by trying it and reporting any
[issue](https://github.com/porras/crul/issues) you find.

## Copyright

Copyright (c) 2015-2016 Sergio Gil. See
[LICENSE](https://github.com/porras/crul/blob/master/LICENSE.txt) for details.
