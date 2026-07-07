#!/bin/sh

for OCP_VERSION in $(ls -d v*.*); do
    opm alpha render-template semver $OCP_VERSION/catalog-template.yaml --migrate-level=bundle-object-to-csv-metadata > $OCP_VERSION/catalog/kueue-operator/catalog.json;
done
