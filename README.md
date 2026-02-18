# ⚠️ Ubod has moved

**Ubod** (the AI coding kernel) is now part of [Bathala OS](https://github.com/johnnyicon/bathala-os).

## New location

```
bathala-os/subsystems/coding-kernel/
```

## How to use

Ubod is now distributed via the Bathala CLI:

```bash
# Initialize a new project with Ubod kernel files
bathala ubod init <project-name>

# Sync kernel updates to a registered project
bathala ubod sync <project-name>

# Check sync status across all projects
bathala ubod status

# Access Ubod tools via MCP
bathala mcp ubod
```

## Why the move?

Ubod was originally a standalone repo. As Bathala OS matured, the kernel became a subsystem with CLI commands, MCP tools, and automated sync/distribution. Keeping it as a separate repo added friction without benefit.

This repo is archived. All future development happens in [bathala-os](https://github.com/johnnyicon/bathala-os).
