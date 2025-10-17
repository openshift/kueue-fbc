#!/bin/sh

for OCP_VERSION in v4.16; do
    opm alpha render-template semver $OCP_VERSION/catalog-template.yaml > $OCP_VERSION/catalog/kueue-operator/catalog.json;
done

for OCP_VERSION in $(ls -d v4.* | awk -F. '$2 >= 17'); do
    opm alpha render-template semver $OCP_VERSION/catalog-template.yaml --migrate-level=bundle-object-to-csv-metadata > $OCP_VERSION/catalog/kueue-operator/catalog.json;
done