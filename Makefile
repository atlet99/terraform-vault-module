.PHONY: fmt validate docs lint changelog release tag clean help check-deps check-all \
       changelog-added changelog-changed changelog-deprecated \
       changelog-removed changelog-fixed changelog-security changelog-generate

SHELL := /bin/bash

# Current version from the latest git tag (strip leading 'v')
CURRENT_VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//' || echo "0.0.0")
DATE := $(shell date +%Y-%m-%d)

# Repository URL
REPO_URL := https://github.com/atlet99/terraform-vault-module

# Required binaries
REQUIRED_BINS := terraform tflint terraform-docs git

###############################################################################
# Helpers
###############################################################################

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

check-deps: ## Check that all required tools are installed
	@for bin in $(REQUIRED_BINS); do \
		if ! command -v $$bin &>/dev/null; then \
			echo "ERROR: '$$bin' is not installed."; \
			case $$bin in \
				terraform)      echo "  Install: https://developer.hashicorp.com/terraform/install" ;; \
				tflint)         echo "  Install: brew install tflint" ;; \
				terraform-docs) echo "  Install: brew install terraform-docs" ;; \
				git)            echo "  Install: brew install git" ;; \
			esac; \
			exit 1; \
		fi; \
	done
	@echo "All dependencies are available."

###############################################################################
# Terraform
###############################################################################

fmt: check-deps ## Run terraform fmt recursively
	terraform fmt -recursive

validate: check-deps ## Run terraform init + validate
	terraform init -backend=false -input=false
	terraform validate

###############################################################################
# Linting & Docs
###############################################################################

lint: check-deps ## Run tflint
	tflint --init
	tflint

docs: check-deps ## Generate documentation with terraform-docs
	terraform-docs .

check-all: fmt validate lint docs ## Run all checks: fmt, validate, lint, docs

###############################################################################
# Changelog & Release
###############################################################################

changelog: ## Ensure [Unreleased] section exists in CHANGELOG.md
	@if ! grep -q '## \[Unreleased\]' CHANGELOG.md; then \
		sed -i '' '/^# Changelog/a\'$$'\n''## [Unreleased]'$$'\n' CHANGELOG.md; \
		echo "Added [Unreleased] section to CHANGELOG.md"; \
	else \
		echo "[Unreleased] section already exists"; \
	fi

# Internal helper: delegates to scripts/changelog-entry.sh
_changelog-entry:
	@if [ -z "$(MSG)" ]; then \
		echo "ERROR: MSG is required. Usage: make changelog-added MSG=\"your message\""; \
		exit 1; \
	fi
	@./scripts/changelog-entry.sh "$(SECTION)" "$(MSG)"

changelog-added: ## Add entry: make changelog-added MSG="..."
	@$(MAKE) _changelog-entry SECTION="Added" MSG="$(MSG)"

changelog-changed: ## Add entry: make changelog-changed MSG="..."
	@$(MAKE) _changelog-entry SECTION="Changed" MSG="$(MSG)"

changelog-deprecated: ## Add entry: make changelog-deprecated MSG="..."
	@$(MAKE) _changelog-entry SECTION="Deprecated" MSG="$(MSG)"

changelog-removed: ## Add entry: make changelog-removed MSG="..."
	@$(MAKE) _changelog-entry SECTION="Removed" MSG="$(MSG)"

changelog-fixed: ## Add entry: make changelog-fixed MSG="..."
	@$(MAKE) _changelog-entry SECTION="Fixed" MSG="$(MSG)"

changelog-security: ## Add entry: make changelog-security MSG="..."
	@$(MAKE) _changelog-entry SECTION="Security" MSG="$(MSG)"

changelog-generate: ## Auto-generate entries from git commits since last tag
	@./scripts/changelog-generate.sh

release: check-deps ## Create a release: make release VERSION=x.y.z
	@if [ -z "$(VERSION)" ]; then \
		echo "ERROR: VERSION is required. Usage: make release VERSION=x.y.z"; \
		exit 1; \
	fi
	@echo "Releasing v$(VERSION) (current: v$(CURRENT_VERSION))..."
	@# Replace [Unreleased] heading with new version, add fresh Unreleased
	@sed -i '' 's/## \[Unreleased\]/## [Unreleased]\n\n## [$(VERSION)] - $(DATE)/' CHANGELOG.md
	@# Update the Unreleased comparison link
	@sed -i '' 's|\[Unreleased\]: $(REPO_URL)/compare/v.*\.\.\.HEAD|[Unreleased]: $(REPO_URL)/compare/v$(VERSION)...HEAD|' CHANGELOG.md
	@# Insert version comparison link
	@if grep -q '\[$(CURRENT_VERSION)\]:' CHANGELOG.md; then \
		sed -i '' '/\[$(CURRENT_VERSION)\]:/i\'$$'\n''[$(VERSION)]: $(REPO_URL)/compare/v$(CURRENT_VERSION)...v$(VERSION)' CHANGELOG.md; \
	else \
		echo "[$(VERSION)]: $(REPO_URL)/releases/tag/v$(VERSION)" >> CHANGELOG.md; \
	fi
	@git add CHANGELOG.md
	@git commit -m "chore: release v$(VERSION)"
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@echo "Done. Run 'git push && git push --tags' to publish."

tag: check-deps ## Create a git tag: make tag VERSION=x.y.z
	@if [ -z "$(VERSION)" ]; then \
		echo "ERROR: VERSION is required. Usage: make tag VERSION=x.y.z"; \
		exit 1; \
	fi
	git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@echo "Tag v$(VERSION) created. Run 'git push --tags' to publish."

###############################################################################
# Cleanup
###############################################################################

clean: ## Remove terraform init artifacts
	rm -rf .terraform .terraform.lock.hcl
