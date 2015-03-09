all: spec build

.PHONY: spec
spec:
	@crystal spec

build: crul

clean:
	@rm -rf .crystal crul

crul: crul.cr src/*.cr src/formatters/*.cr
	@crystal build crul.cr
	@du -sh crul
