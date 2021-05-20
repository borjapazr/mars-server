ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SERVICE := openvpn
include $(ROOT_DIR)/../../core/common.mk
include .env

.ONESHELL:

.PHONY: install
install: ## Start all containers in background and prepare certificates
	@$(DOCKER_COMPOSE) run --rm $(SERVICE) ovpn_genconfig -u udp://$(DOMAIN)
	@$(DOCKER_COMPOSE) run --rm $(SERVICE) ovpn_initpki
	@sudo chown -R $(whoami): $(VOLUME_DIR)/openvpn-data
	@mkdir clients
	@$(DOCKER_COMPOSE) up -d

.PHONY: uninstall
uninstall: ## Stop all containers and remove all data
	@$(DOCKER_COMPOSE) down -v
	@sudo rm -rf $(VOLUME_DIR)
	@sudo rm -rf clients

.PHONY: add-user
add-user: ## Add a new user
	@read -p "Enter username: " username
	@$(DOCKER_COMPOSE) run --rm $(SERVICE) easyrsa build-client-full $${username}
	@$(DOCKER_COMPOSE) run --rm $(SERVICE) ovpn_getclient $${username} > clients/$${username}.ovpn

.PHONY: delete-user
delete-user: ## Remove a user
	@read -p "Enter username: " username
	@$(DOCKER_COMPOSE) run --rm $(SERVICE) ovpn_revokeclient $${username}
	@rm -rf clients/$${username}.ovpn
