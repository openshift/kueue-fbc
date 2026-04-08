#!/usr/bin/env python3
"""Get the latest Konflux snapshots for kueue-fbc components.

Usage: ./get-snapshots.py [4.18,4.19,4.20,4.21]
  If no argument is provided, auto-detects versions from .tekton/kueue-fbc-*-push.yaml files.
"""

import glob
import json
import os
import shutil
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
KUBECTL = shutil.which("kubectl")
KUBECTL_TIMEOUT_SECONDS = 30


def discover_components():
    """Discover components from .tekton pipeline files."""
    components = []
    pattern = os.path.join(SCRIPT_DIR, ".tekton", "kueue-fbc-*-push.yaml")
    for path in sorted(glob.glob(pattern)):
        name = os.path.basename(path).removesuffix("-push.yaml")
        version = name.removeprefix("kueue-fbc-").replace("-", ".")
        components.append((version, name))
    return components


def get_latest_snapshot(component):
    """Query kubectl for the latest snapshot of a component."""
    if not KUBECTL:
        print("kubectl not found in PATH. Install kubectl to use this script.", file=sys.stderr)
        return None
    try:
        result = subprocess.run(
            [
                KUBECTL, "get", "snapshots",
                "-l", f"appstudio.openshift.io/component={component}",
                "--sort-by=.metadata.creationTimestamp",
                "-o", "json",
            ],
            capture_output=True, text=True, check=True,
            timeout=KUBECTL_TIMEOUT_SECONDS,
        )
    except subprocess.TimeoutExpired:
        print(f"Timeout querying snapshots for {component}", file=sys.stderr)
        return None
    except subprocess.CalledProcessError as e:
        print(f"Error querying snapshots for {component}: {e.stderr}", file=sys.stderr)
        print(
            "Ensure your kubeconfig is set to a cluster with Konflux Snapshot CRDs installed.",
            file=sys.stderr,
        )
        return None

    try:
        data = json.loads(result.stdout)
    except json.JSONDecodeError:
        print(f"Invalid JSON from kubectl for {component}", file=sys.stderr)
        return None
    items = data.get("items", [])
    if not items:
        return None

    latest = items[-1]
    metadata = latest.get("metadata", {})
    name = metadata.get("name")
    created_ts = metadata.get("creationTimestamp")
    if not name or not created_ts:
        return None
    created = created_ts.split("T")[0]
    images = [c["containerImage"] for c in latest.get("spec", {}).get("components", [])]
    image = images[0] if images else "-"
    return name, created, image


def main():
    all_components = discover_components()

    if len(sys.argv) > 1:
        requested = {v.strip() for v in sys.argv[1].split(",")}
        components = [(v, n) for v, n in all_components if v in requested]
    else:
        components = all_components

    if not components:
        print("No matching components found.", file=sys.stderr)
        sys.exit(1)

    # Print table
    print(f"| {'OCP':<8} | {'Snapshot':<45} | {'Created':<12} | Container Image")
    print(f"|{'-'*10}|{'-'*47}|{'-'*14}|---")

    anomalies = []
    for version, component in components:
        snapshot = get_latest_snapshot(component)
        if snapshot is None:
            print(f"| {version:<8} | {'(none found)':<45} | {'-':<12} | -")
            continue

        name, created, image = snapshot
        print(f"| {version:<8} | {name:<45} | {created:<12} | {image}")

        if component not in image:
            anomalies.append(
                f"{version}: image path does not contain expected component name '{component}'"
            )

    if anomalies:
        print("\nAnomalies:")
        for a in anomalies:
            print(f"  - {a}")


if __name__ == "__main__":
    main()
