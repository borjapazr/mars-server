ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SERVICE := traefik
include $(ROOT_DIR)/../../core/common.mk

.ONESHELL:
.PHONY: install uninstall add-user

install: ## Start all containers in background
	@docker-compose up -d

uninstall: ## Stop all containers and remove all data
	@docker-compose down -v
	@sudo rm -rf traefik-data/accesslog
	@sudo rm -rf traefik-data/log
	@sudo rm -rf traefik-data/letsencrypt

add-user: ## Add a new user for Traefik Dashboard
	@read -p "Enter username: " username
	@read -p "Enter password: " password
	@echo $$(htpasswd -nb $${username} $${password}) >> traefik-data/users-credentials
	@docker-compose restart
