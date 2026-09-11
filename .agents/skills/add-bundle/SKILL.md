---
name: add-bundle
description: Adds a new bundle image to selected Kueue catalog templates and regenerates their FBC catalogs. Use when publishing or introducing a new Kueue Operator bundle version.
user-invocable: true
---

# Add a bundle

The user must provide:

1. A bundle image reference.
2. OCP versions to update; this defaults to `all` when omitted.

If the bundle image is missing, ask for it before proceeding.

For `all`, enumerate every version directory matching `v[0-9]*`, for example:

```bash
ls -d v[0-9]*/
```

This includes `v5.0` and future `v5.x`, `v6.x`, and later directories. Do not hardcode a `v4.x`-only list. Do not use a bare `v*.*` glob because it also matches files such as `validate-releases.sh`.

For each selected version directory:

1. Append the new bundle image to the `Bundles:` list in `catalog-template.yaml`, preserving the existing YAML structure and ordering.
2. Regenerate that catalog with:

```bash
opm alpha render-template semver <dir>/catalog-template.yaml \
  --migrate-level=bundle-object-to-csv-metadata \
  > <dir>/catalog/kueue-operator/catalog.json
```

Review the resulting diff and summarize which OCP versions were updated.
