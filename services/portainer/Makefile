ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SERVICE := portainer
include $(ROOT_DIR)/../../core/common.mk

.ONESHELL:
.PHONY: install uninstall

install: ## Start all containers in background
	@docker-compose up -d

uninstall: ## Stop all containers and remove all data
	@docker-compose down -v
	@sudo rm -rf portainer-data
