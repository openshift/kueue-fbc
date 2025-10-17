# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains File-Based Catalog (FBC) definitions for the Kueue Operator across multiple OpenShift Container Platform (OCP) versions. It's used to generate and maintain operator catalogs for distribution through Red Hat's operator ecosystem.

## Commands

### Generate FBC Catalogs
```bash
./generate-fbc.sh
```
Regenerates catalog.json files for all supported OCP versions. This script:
- Uses OPM (Operator Package Manager) to render catalog templates
- For v4.16: Uses standard rendering without migration flags
- For v4.17+: Uses `--migrate-level=bundle-object-to-csv-metadata` flag

### Lint Catalogs
```bash
./lint.sh
```
Currently disabled but contains validation logic for ensuring all bundle images come from the same registry.

### Prerequisites
- Requires `opm` version 1.47.0 or higher
- Must have access to Red Hat registries for bundle images

## Architecture

### Directory Structure
```
.
├── v4.16/          # OCP 4.16 catalog definitions
├── v4.17/          # OCP 4.17 catalog definitions
├── v4.18/          # OCP 4.18 catalog definitions
├── v4.19/          # OCP 4.19 catalog definitions
├── v4.20/          # OCP 4.20 catalog definitions
└── .tekton/        # CI/CD pipeline definitions
```

### Version Directory Layout
Each `v{X.Y}/` directory contains:
- `catalog-template.yaml`: Semver template defining bundle images and channels
- `Containerfile.catalog`: Container build file for the FBC image
- `catalog/kueue-operator/catalog.json`: Generated FBC fragment (created by generate-fbc.sh)

### Catalog Template Structure
The `catalog-template.yaml` files use OLM's semver schema:
- **Schema**: `olm.semver` with minor channel generation enabled
- **Stable Channel**: Contains chronologically ordered bundle images
- **Bundle Images**: References to `registry.redhat.io/kueue*` bundle images with SHA256 digests

### Generated Catalogs
The `catalog.json` files contain:
- **Package definition**: Defines the kueue-operator package with default channel
- **Channel definitions**: Version-specific channels (stable-v0.1, stable-v0.2, stable-v1.0, stable-v1.1)
- **Bundle metadata**: Complete operator bundle definitions with CSVs, CRDs, and dependencies

## Release Process

When releasing a new Kueue Operator version:

1. **Update Templates**: Add new bundle image entries to `catalog-template.yaml` files for each supported OCP version
2. **Regenerate Catalogs**: Run `./generate-fbc.sh` to update all `catalog.json` files
3. **CI/CD**: Tekton pipelines in `.tekton/` handle building and publishing FBC images for each OCP version

## CI/CD Integration

- **Konflux Integration**: Uses Konflux CI system with Tekton pipelines
- **Renovate**: Automated dependency updates configured in `renovate.json`
- **Multi-version Support**: Separate pipelines for each OCP version (4.18, 4.19)

## Registry and Image Management

- **Source Registry**: `registry.redhat.io/kueue*`
- **Bundle Images**: Use SHA256 digests for immutable references
- **Migration Considerations**: OCP 4.17+ requires bundle-object-to-csv-metadata migration
