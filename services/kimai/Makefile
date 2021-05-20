ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SERVICE := kimai
include $(ROOT_DIR)/../../core/common.mk
include .env

.ONESHELL:

.PHONY: install
install: ## Start all containers in background
	@$(DOCKER_COMPOSE) up -d

.PHONY: uninstall
uninstall: ## Stop all containers and remove all data
	@$(DOCKER_COMPOSE) down -v
	@sudo rm -rf $(VOLUME_DIR)

.PHONY: fix-permissions
fix-permissions: ## Fix volume permissions
	@$(DOCKER) exec --user root $(SERVICE) chown -R www-data:www-data /opt/kimai/public
