all: crul

crul: crul.cr src/**/*.cr
	shards
	crystal build --release crul.cr
	@du -sh crul

clean:
	rm -rf .crystal crul .deps .shards libs

PREFIX ?= /usr/local

install: crul
	install -d $(PREFIX)/bin
	install crul $(PREFIX)/bin
