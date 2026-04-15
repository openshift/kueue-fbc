Run the get-snapshots script to fetch the latest Konflux snapshots:

```bash
./get-snapshots.py $ARGUMENTS
```

Prerequisites:
- `kubectl` must be installed and available in PATH
- Your kubeconfig must be configured with access to the `stone-prd-rh01` cluster and you must be in the `kueue-operator-tenant` namespace/project
- If you don't have access to the cluster, ask a maintainer for instructions on how to get set up
- If the script fails with authentication or resource errors, verify you are logged into the correct cluster and namespace

Display the output to the user.
