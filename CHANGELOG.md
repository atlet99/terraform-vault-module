# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
## [Unreleased]

### Fixed

- [FIX] - release mechanism;
- [FIX] - changelog scripts;
## [1.0.0] - 2026-03-02

### Added

- [FEATURE] - add initial vault module implementation

Add a comprehensive Terraform module for managing HashiCorp Vault resources
including secrets engine mounts, auth backends, policies, audit devices,
Kubernetes auth configuration, KV-V2 secrets and backends, Vault Enterprise
namespaces, and generic endpoints.

The module uses map-based variables to enable optional creation of each
resource type. Includes complete documentation, changelog, tooling configuration
(terraform-docs, tflint), Makefile for automation, and a full usage example.
- [ADD] - changelog management targets to Makefile

Add new Makefile targets for automated changelog management including
changelog-added, changelog-changed, changelog-deprecated, changelog-removed,
changelog-fixed, and changelog-security. These targets delegate to
changelog-entry.sh script to append entries to the appropriate sections.

Also add changelog-generate target to auto-generate entries from git commits
since the last tag using changelog-generate.sh script.

Update existing changelog target description for clarity.

### Changed

- [CI] - add github actions ci and release workflows

- Add CI workflow with validate (terraform fmt, validate), lint (tflint),
  and docs (terraform-docs) jobs
- Add release workflow using terraform-module-releaser for automated
  module releases
- Update Makefile release and tag targets to prompt for version input
  and consistently update CHANGELOG.md before tagging;
- Release v1.0.0
[Unreleased]: https://github.com/atlet99/terraform-vault-module/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/atlet99/terraform-vault-module/releases/tag/v1.0.0

