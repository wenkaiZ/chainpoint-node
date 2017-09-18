# First target in the Makefile is the default.
all: help

# Get the location of this makefile.
ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# Specify the binary dependencies
REQUIRED_BINS := docker docker-compose
$(foreach bin,$(REQUIRED_BINS),\
    $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

# Help Text Display
# Usage: Put a comment with double # prior to targets.
# See : https://gist.github.com/rcmachado/af3db315e31383502660
## Display this help text
help: 
	$(info Available targets)
	@awk '/^[a-zA-Z\-\_0-9]+:/ {                    \
		nb = sub( /^## /, "", helpMsg );            \
		if(nb == 0) {                               \
		helpMsg = $$0;                              \
		nb = sub( /^[^:]*:.* ## /, "", helpMsg );   \
		}                                           \
		if (nb)                                     \
		print  $$1 "\t" helpMsg;                    \
	}                                               \
	{ helpMsg = $$0 }'                              \
	$(MAKEFILE_LIST) | column -ts $$'\t' |          \
	grep --color '^[^ ]*'

## Copy the .env config from .env.sample if not present
build-config:
	@[ ! -f ./.env ] && \
	cp .env.sample .env && \
	echo 'Copied config .env.sample to .env' || true

## Start Node
up:
	docker-compose up -d --no-build

## Shutdown Node
down:
	docker-compose down

## Tail Node logs for the Chainpoint Docker Container
logs:
	docker-compose logs -f -t | grep chainpoint-node

logs-redis:
	docker-compose logs -f -t | grep redis

logs-postgres:
	docker-compose logs -f -t | grep postgres

logs-all:
	docker-compose logs -f -t

## View running processes
ps:
	docker-compose ps

.PHONY: all build-config up down logs logs-redis logs-postgres logs-all ps
