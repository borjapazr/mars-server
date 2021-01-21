ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SERVICE := openvpn
include $(ROOT_DIR)/../../core/common.mk

.ONESHELL:
.PHONY: install uninstall add-user delete-user

install: ## Start all containers in background and prepare certificates
	@docker-compose run --rm openvpn ovpn_genconfig -u udp://marsmachine.space
	@docker-compose run --rm openvpn ovpn_initpki
	@sudo chown -R $(whoami): ./openvpn-data
	@mkdir clients
	@docker-compose up -d

uninstall: ## Stop all containers and remove all data
	@docker-compose down -v
	@sudo rm -rf openvpn-data
	@sudo rm -rf clients

add-user: ## Add a new user
	@read -p "Enter username: " username
	@docker-compose run --rm openvpn easyrsa build-client-full $${username}
	@docker-compose run --rm openvpn ovpn_getclient $${username} > clients/$${username}.ovpn

delete-user: ## Remove a user
	@read -p "Enter username: " username
	@docker-compose run --rm openvpn ovpn_revokeclient $${username}
	@rm -rf clients/$${username}.ovpn
