ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SERVICE := nextcloud-app
include $(ROOT_DIR)/../../core/common.mk
include .env

.ONESHELL:

.PHONY: install
install: ## Start all containers in background and prepare data directory
	@$(DOCKER_COMPOSE) up -d
	@$(DOCKER) exec --user root $(SERVICE) mkdir -p /srv/nextcloud/data
	@$(DOCKER) exec --user root $(SERVICE) chown www-data:www-data /srv/nextcloud/data

.PHONY: uninstall
uninstall: ## Stop all containers and remove all data
	@$(DOCKER_COMPOSE) down -v
	@sudo rm -rf $(VOLUME_DIR)

.PHONY: optimize
optimize: ## Optimize Nextcloud
	@$(DOCKER) exec --user www-data $(SERVICE) php occ db:add-missing-indices
