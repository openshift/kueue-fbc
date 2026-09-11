---
name: generate-new-fbc
description: Creates a new versioned OCP catalog directory and configures its Containerfile. Use when the user asks to add or scaffold support for a new OCP version.
user-invocable: true
---

# Generate a new FBC directory

The user must provide an OCP version as the skill argument, for example `4.24`.

From the repository root, run:

```bash
./add-ocp-version.sh <ocp-version>
```

This creates `v<ocp-version>` from the latest existing version, installs `Containerfile.catalog`, and updates it to use the requested OCP version.

Check the generated files and summarize the changes. If no OCP version was provided, ask the user for one before proceeding.
