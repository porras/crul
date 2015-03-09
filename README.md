# Crul

Crul is a [curl](http://curl.haxx.se/) replacement, that is, it's a command line HTTP client. It has less features and options, but it aims to be more user friendly. It's heavily inspired by [httpie](https://github.com/jakubroztocil/httpie).

It's written in the [Crystal](http://crystal-lang.org/) language.

## Features

* Syntax highlighting of the output (currently, only JSON)

## Planned features

* Headers
* Request body
* XML highlight
* User friendly headers and request body generation (similar to [httpie's](https://github.com/jakubroztocil/httpie#request-items))
* Basic and digest authentication

## Installation

## Usage

    Usage: crul [options] URL
        -X METHOD, --method METHOD       Use GET|POST|PUT|DELETE (default: GET)
        -j, --json                       Format response as JSON
        -h, --help                       Show this help

## Contributing

## License
