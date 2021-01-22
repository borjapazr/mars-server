## Colors
BLACK := $(shell tput -Txterm setaf 0)
RED := $(shell tput -Txterm setaf 1)
GREEN := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
BLUE := $(shell tput -Txterm setaf 4)
MAGENTA := $(shell tput -Txterm setaf 5)
CYAN := $(shell tput -Txterm setaf 6)
WHITE := $(shell tput -Txterm setaf 7)
RESET := $(shell tput -Txterm sgr0)

## Help function
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'Targets'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "Usage: make ${BLUE}TARGET${RESET} ${MAGENTA}[ARGUMENTS]${RESET}\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (sort {$$a->[0] cmp $$b->[0]} @{$$help{$$_}}) { \
    $$sep = " " x (15 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }

## Docker commands
DOCKER := docker
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(ROOT_DIR)/docker-compose.yml

## Set 'sh' as default shell
SHELL = /bin/sh
## Set 'help' target as the default goal
.DEFAULT_GOAL := help

## Common targets
.PHONY: help
help: ## Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: enable
enable: ## Enable service
	@rm -rf .disabled

.PHONY: disable
disable: down ## Disable service
	@touch .disabled

.PHONY: env
env: ## Create .env file from .env.template
	@if [ ! -f .env ]; then cp .env.template .env; fi

.PHONY: health
health: ## Get service health
	@if [ -z `$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps -q ${SERVICE}` ] || [ -z `$(DOCKER) ps -q --no-trunc | grep $$($(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps -q ${SERVICE})` ]; then echo "DOWN"; else echo "UP"; fi

.PHONY: build
build: CMD = build $(c) ## Build all or c=<name> containers

.PHONY: up
up: CMD = up -d $(c) ## Up all or c=<name> containers

.PHONY: down
down: CMD = down $(c) ## Down all or c=<name> containers

.PHONY: destroy
destroy: CMD = down -v $(c) ## Destroy all or c=<name> containers

.PHONY: start
start: CMD = start $(c) ## Start all or c=<name> containers

.PHONY: stop
stop: CMD = stop $(c)## Stop all or c=<name> containers

.PHONY: restart
restart: stop start ## Restart all or c=<name> containers

.PHONY: status
status: CMD = ps ## Show status of containers

.PHONY: logs
logs: CMD = logs --tail=100 -f $(c) ## Show logs for all or c=<name> containers

build up down start stop destroy logs status:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) $(CMD)
