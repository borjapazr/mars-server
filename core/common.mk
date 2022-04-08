## Docker commands
DOCKER := docker
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(ROOT_DIR)/docker-compose.yml

## Set 'bash' as default shell
SHELL := $(shell which bash)

## Set 'help' target as the default goal
.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@egrep -h '^[a-zA-Z0-9_\/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -d | awk 'BEGIN {FS = ":.*?## "; printf "Usage: make \033[0;34mTARGET\033[0m \033[0;35m[ARGUMENTS]\033[0m\n\n"; printf "Targets:\n"}; {printf "  \033[33m%-25s\033[0m \033[0;32m%s\033[0m\n", $$1, $$2}'

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
	@if [ "$$($(DOCKER) container inspect -f '{{.State.Status}}' $(SERVICE) 2>&1)" = "running" ]; then echo "UP"; else echo "DOWN"; fi

.PHONY: build
build: CMD = build $(c) ## Build all or c=<name> containers

.PHONY: up
up: CMD = up -d $(c) ## Up all or c=<name> containers

.PHONY: down
down: CMD = down ## Down all containers

.PHONY: destroy
destroy: CMD = down -v ## Destroy all containers

.PHONY: start
start: CMD = start $(c) ## Start all or c=<name> containers

.PHONY: stop
stop: CMD = stop $(c) ## Stop all or c=<name> containers

.PHONY: restart
restart: CMD = restart $(c) ## Restart all or c=<name> containers

.PHONY: status
status: CMD = ps ## Show status of containers

.PHONY: logs
logs: CMD = logs --tail=100 -f $(c) ## Show logs for all or c=<name> containers

build up down start stop restart destroy logs status:
	@$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) $(CMD)
