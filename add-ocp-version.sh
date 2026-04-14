#!/bin/bash

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <new-version>"
    echo "Example: $0 4.23"
    exit 1
fi

NEW_VERSION="$1"
NEW_DIR="v${NEW_VERSION}"

if [ -d "$NEW_DIR" ]; then
    echo "Error: $NEW_DIR already exists"
    exit 1
fi

# Find the latest existing version directory to copy from
LATEST_DIR=$(ls -d v4.* | sort -t. -k2 -n | tail -1)

echo "Creating $NEW_DIR from $LATEST_DIR..."

mkdir -p "$NEW_DIR/catalog/kueue-operator"
cp "$LATEST_DIR/catalog-template.yaml" "$NEW_DIR/catalog-template.yaml"
cp "$LATEST_DIR/catalog/kueue-operator/catalog.json" "$NEW_DIR/catalog/kueue-operator/catalog.json"
sed "s/${LATEST_DIR}/${NEW_DIR}/" "$LATEST_DIR/Containerfile.catalog" > "$NEW_DIR/Containerfile.catalog"

echo "Done. Created:"
echo "  $NEW_DIR/catalog-template.yaml"
echo "  $NEW_DIR/Containerfile.catalog"
echo "  $NEW_DIR/catalog/kueue-operator/catalog.json"
