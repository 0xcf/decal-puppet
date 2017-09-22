.PHONY: all
all: vendor

vendor: Puppetfile
	r10k puppetfile install
