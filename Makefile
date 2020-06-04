all: crul

crul: crul.cr src/**/*.cr
	shards
	crystal build --release --no-debug --static --link-flags "-lxml2 -llzma" crul.cr
	@strip crul
	@du -sh crul

clean:
	rm -rf .crystal crul .deps .shards libs

PREFIX ?= /usr/local

install: crul
	install -d $(PREFIX)/bin
	install crul $(PREFIX)/bin
