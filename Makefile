VERSION=0.1.0

all: spec build

.PHONY: spec
spec:
	crystal spec

build: crul

crul: crul.cr src/*.cr src/formatters/*.cr
	crystal build --release crul.cr
	@du -sh crul

## release

-include .github
.PHONY: release
release: .github spec build zips
	@# requires https://github.com/aktau/github-release installed
	git tag v$(VERSION)
	git push --tags
	github-release release -s $(GITHUB_TOKEN) -u $(GITHUB_USER) -r $(GITHUB_REPO) -t v$(VERSION) -n "Crul v$(VERSION)" --draft
	github-release upload  -s $(GITHUB_TOKEN) -u $(GITHUB_USER) -r $(GITHUB_REPO) -t v$(VERSION) -n darwin-amd64-crul.zip -f release/darwin-amd64-crul.zip
	open https://github.com/$(GITHUB_USER)/$(GITHUB_REPO)/releases

zips: release/darwin-amd64-crul.zip

release/darwin-amd64-crul.zip: crul
	mkdir -p release
	zip $@ crul

clean:
	rm -rf .crystal release crul
