#!/bin/sh

for OCP_VERSION in $(ls -d v[0-9]*); do
    opm alpha render-template semver $OCP_VERSION/catalog-template.yaml --migrate-level=bundle-object-to-csv-metadata > $OCP_VERSION/catalog/kueue-operator/catalog.json;
done
