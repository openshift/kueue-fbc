  Add a new bundle version to the catalog templates.

  Bundle image: $1
  OCP versions to update: $2 (default: all)

  Update the catalog-template.yaml files in the specified version directories with the new bundle image, then regenerate the catalogs.

  When "all" is used, enumerate every version directory matching `v[0-9]*` (e.g. `ls -d v[0-9]*`). This includes v5.0 and any future v5.x/v6.x directories — do NOT hardcode a v4.x-only list. Note that a bare `v*.*` glob incorrectly matches files like `validate-releases.sh`, so avoid it.

  For each version directory:
  - Append the new bundle image to the `Bundles:` list in `catalog-template.yaml`.
  - Regenerate its catalog with:
    `opm alpha render-template semver <dir>/catalog-template.yaml --migrate-level=bundle-object-to-csv-metadata > <dir>/catalog/kueue-operator/catalog.json`
