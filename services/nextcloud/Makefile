ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SERVICE := nextcloud-app
include $(ROOT_DIR)/../../core/common.mk

.ONESHELL:

.PHONY: install
install: ## Start all containers in background and prepare data directory
	@$(DOCKER_COMPOSE) up -d
	@$(DOCKER) exec --user root nextcloud-app mkdir -p /srv/nextcloud/data
	@$(DOCKER) exec --user root nextcloud-app chown www-data:www-data /srv/nextcloud/data

.PHONY: uninstall
uninstall: ## Stop all containers and remove all data
	@$(DOCKER_COMPOSE) down -v
	@sudo rm -rf nextcloud-data
	@sudo rm -rf nextcloud-db

.PHONY: optimize
optimize: ## Optimize Nextcloud
	@$(DOCKER) exec --user www-data nextcloud-app php occ db:add-missing-indices
