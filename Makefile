VERSION=0.3.1
ZIPNAME=crul-$(VERSION)-$(shell uname -m -s|tr '[:upper:] ' '[:lower:]-').zip

all: spec build

dependencies: Projectfile .deps.lock
	crystal deps

.PHONY: spec
spec: dependencies
	crystal spec

build: crul

crul: dependencies crul.cr src/*.cr src/formatters/*.cr
	crystal build --release crul.cr
	@du -sh crul

release: $(ZIPNAME)

$(ZIPNAME): crul LICENSE.txt
	@zip $@ crul LICENSE.txt > /dev/null
	@du -sh $@

clean:
	rm -rf .crystal crul *.zip .deps libs

PREFIX ?= /usr/local

install: crul
	install -d $(PREFIX)/bin
	install crul $(PREFIX)/bin
