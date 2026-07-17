#!/bin/bash
#
# Verify the latest kueue-operator bundle we ship is actually present on
# registry.redhat.io/redhat/redhat-operator-index for every OCP version we support.
#
# Prerequisites: opm, jq, and registry.redhat.io pull access (podman/docker login).

set -euo pipefail

PACKAGE_NAME="kueue-operator"
OCP_VERSIONS=($(find . -maxdepth 1 -type d -name 'v[0-9]*.[0-9]*' -printf '%f\n' | sed 's/^v//' | sort -V))

bundle_versions() {
    jq -r --arg pkg "$PACKAGE_NAME" \
        'select(.schema=="olm.bundle" and .package==$pkg) | .properties[]? | select(.type=="olm.package") | .value.version'
}

latest_local_version() {
    local latest_dir
    latest_dir="v$(printf '%s\n' "${OCP_VERSIONS[@]}" | tail -1)"
    bundle_versions < "$latest_dir/catalog/kueue-operator/catalog.json" | sort -V | tail -1
}

LATEST_VERSION=$(latest_local_version)
echo "Latest kueue-operator version in this repo: $LATEST_VERSION"
echo

FAILED=()

for OCP_VERSION in "${OCP_VERSIONS[@]}"; do
    INDEX="registry.redhat.io/redhat/redhat-operator-index:v${OCP_VERSION}"
    echo "Checking $PACKAGE_NAME on ${INDEX}..."

    if ! VERSIONS=$(opm render "$INDEX" | bundle_versions | sort -V); then
        echo "  ERROR: failed to render index for OCP ${OCP_VERSION}"
        FAILED+=("${OCP_VERSION}: index render failed")
        echo
        continue
    fi

    if [ -z "$VERSIONS" ]; then
        echo "  ERROR: no $PACKAGE_NAME bundles found on index for OCP ${OCP_VERSION}"
        FAILED+=("${OCP_VERSION}: missing")
        echo
        continue
    fi

    echo "  versions found: $(echo "$VERSIONS" | tr '\n' ' ')"

    if ! grep -Fxq "$LATEST_VERSION" <<< "$VERSIONS"; then
        FOUND_LATEST=$(echo "$VERSIONS" | tail -1)
        echo "  MISMATCH: expected version $LATEST_VERSION is absent; latest is $FOUND_LATEST"
        FAILED+=("${OCP_VERSION}: missing ${LATEST_VERSION}, latest is ${FOUND_LATEST}")
    else
        echo "  OK"
    fi
    echo
done

if [ ${#FAILED[@]} -gt 0 ]; then
    echo "FAILED:"
    printf '  %s\n' "${FAILED[@]}"
    exit 1
fi

echo "All catalogs have kueue-operator $LATEST_VERSION"
