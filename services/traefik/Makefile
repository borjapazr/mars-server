ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SERVICE := traefik
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

.PHONY: add-user
add-user: ## Add a new user for Traefik Dashboard
	@read -p "Enter username: " username
	@read -p "Enter password: " password
	@echo $$(htpasswd -nb $${username} $${password}) >> credentials/users-credentials
	@$(DOCKER_COMPOSE) restart
