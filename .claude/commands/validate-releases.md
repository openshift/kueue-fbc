Validate that the latest kueue-operator release has actually shipped to Red Hat's operator index for every OCP version we support:

```bash
./validate-releases.sh
```

This script:
- Determines the latest kueue-operator bundle version from this repo's own catalogs (the newest version directory's `catalog.json`)
- Runs `opm render registry.redhat.io/redhat/redhat-operator-index:v$OCP_VERSION` for each supported OCP version (derived from the `v*.*` directories in this repo)
- Extracts the kueue-operator bundle versions present on each live index and compares the newest one against the expected latest version
- Exits non-zero and lists any OCP version that is missing the package entirely or is behind the expected version

Prerequisites:
- `opm` (1.47.0+) and `jq` must be installed and on PATH
- You must be logged in to `registry.redhat.io` (e.g. `podman login registry.redhat.io`) so `opm render` can pull the index images

Run the script and summarize the results for the user, calling out any OCP version that isn't on the latest kueue-operator release.
