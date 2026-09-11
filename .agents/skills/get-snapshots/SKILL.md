---
name: get-snapshots
description: Fetches and displays the latest Kueue Operator Konflux snapshots. Use when the user asks to retrieve, inspect, or list Konflux snapshot information.
user-invocable: true
---

# Get Konflux snapshots

Run the snapshot script from the repository root, passing through any arguments supplied by the user:

```bash
./get-snapshots.py <arguments>
```

Omit `<arguments>` when none were supplied.

## Prerequisites

- `kubectl` must be installed and available in `PATH`.
- The kubeconfig must provide access to the `stone-prd-rh01` cluster.
- The current namespace/project must be `kueue-operator-tenant`.
- If cluster access is unavailable, ask a maintainer for setup instructions.
- If the script fails with authentication or resource errors, verify the active cluster and namespace.

Display the script output to the user.
