---
name: check-versions
description: Compares Kueue bundle versions across OCP catalog directories and summarizes differences. Use when checking catalog consistency or version skew between supported OCP releases.
user-invocable: true
---

# Check catalog versions

Inspect the current bundle versions across all OCP version directories and summarize the differences between their catalogs. At minimum, include `v4.18`, `v4.19`, and `v4.20` when those directories exist, and call out version skew clearly.
