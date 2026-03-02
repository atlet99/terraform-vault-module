# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-03-02

### Added

- Secrets engine mounts (`vault_mount`) with full argument support
- Auth backends (`vault_auth_backend`) with tune block
- Vault policies (`vault_policy`)
- Audit devices (`vault_audit`) for file, syslog, and socket types
- Kubernetes auth backend configuration and roles
- KV-V2 backend-level settings (`vault_kv_secret_backend_v2`)
- KV-V2 secrets (`vault_kv_secret_v2`) with custom metadata support
- Vault Enterprise namespaces (`vault_namespace`)
- Generic endpoints (`vault_generic_endpoint`)
- Comprehensive outputs for accessors, paths, and IDs
- Makefile with fmt, validate, docs, changelog, and release targets
- Complete usage example in `examples/complete/`

[Unreleased]: https://github.com/atlet99/terraform-vault-module/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/atlet99/terraform-vault-module/releases/tag/v0.1.0
