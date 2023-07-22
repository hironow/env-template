include .env
export

COMMIT=$$(git describe --tags --always)
OSNAME=${shell uname -s}

LOCAL_BIN:=$(CURDIR)/bin
PATH:=$(LOCAL_BIN):$(PATH)


# default help
.DEFAULT_GOAL := help
.PHONY: help

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

# utils
cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || (echo "ERROR: '$(*)' must be installed and available on your PATH."; exit 1)

guard-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: environment variable $* not set' && exit 1; fi


# this repository specific
check-dockerignore:  # Check .dockerignore works ref. https://stackoverflow.com/questions/38946683/how-to-test-dockerignore-file
	docker build --no-cache -t build-context -f Dockerfile .
	@echo "-- check image files --"
	docker container run --rm build-context
	docker image rm build-context

echo:
	@echo ${FOO} ${BAR}

os: guard-PIYO
	@echo ${OSNAME} ${COMMIT}