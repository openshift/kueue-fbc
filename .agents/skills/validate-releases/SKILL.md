---
name: validate-releases
description: Validates that the latest Kueue Operator bundle has shipped in Red Hat's live operator index for every supported OCP version. Use for release publication and index consistency checks.
user-invocable: true
---

# Validate releases

Run the validation script from the repository root:

```bash
./validate-releases.sh
```

The script:

- Determines the latest Kueue Operator bundle version from this repository's newest version directory and its `catalog.json`.
- Runs `opm render registry.redhat.io/redhat/redhat-operator-index:v$OCP_VERSION` for every supported OCP version derived from the `v*.*` directories.
- Extracts the Kueue Operator bundle versions from each live index and compares the newest one with the expected version.
- Exits nonzero and lists OCP versions where the package is missing or behind.

## Prerequisites

- `opm` 1.47.0 or newer and `jq` must be installed and available in `PATH`.
- The user must be logged in to `registry.redhat.io`, for example with `podman login registry.redhat.io`, so `opm render` can pull index images.

Summarize the results and clearly call out every OCP version that is not on the latest Kueue Operator release.
