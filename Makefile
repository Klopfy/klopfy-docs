DOCKER_RUN = sudo docker compose run --service-ports --rm node

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@echo "Usage: make [target]"
	@echo "Available target:"
	@$(DOCKER_RUN) _help

.PHONY: _help
_help:
	@grep -hE '^[1-9a-zA-Z_-]+:.*?## .*$$|(^#--)' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m %-43s\033[0m %s\n", $$1, $$2}' \
	| sed -e 's/\[32m #-- /[33m/'

.PHONY: install
install: ## Install the npm packages to update your package-lock.json file
	@$(DOCKER_RUN) _install

.PHONY: _install
_install: 
	npm install --quiet --no-progress --cache=.cache/npm

.PHONY: clean-install
clean-install: ## Clean install the npm packages based on package-lock.json file
	@$(DOCKER_RUN) _clean-install

.PHONY: _clean-install
_clean-install: 
	npm clean-install --quiet --no-progress --cache=.cache/npm

.PHONY: build
build: ## Build and generate static website
	@$(DOCKER_RUN) _build

.PHONY: _build
_build: clean-site _clean-install
	npx antora --fetch --to-dir build/site antora-playbook.yml && touch build/site/.nojekyll

.PHONY: clean-site
clean-site: ## Remove generated site folder
	rm -rf build/site/*

.PHONY: open
open: ## Open site index with default browser
	open build/site/index.html

.PHONY: clean-cache
clean-cache: ## Remove .cache and node_modules folder
	sudo rm -rf .cache node_modules