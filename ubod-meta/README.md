# Ubod-Meta: Ubod Self-Maintenance

**Purpose:** Everything in this folder is for maintaining **ubod ITSELF** (meta-programming for ubod). It is ALSO deployed to consuming repos so they can maintain ubod too.

**⚠️ This is NOT the same as "meta" in general terms.** This folder is specifically for ubod self-maintenance, hence the explicit name `ubod-meta/`.

---

## ⚠️ Important Distinction

| This Folder (`ubod-meta/`) | Other Folders (`templates/`, `prompts/`) |
|---------------------------|------------------------------------------|
| For updating **ubod itself** | For initial ubod setup + app features |
| Deployed to consuming repos for ubod self-maintenance | One-time setup prompts + reusable templates |
| Used by anyone who needs to update ubod | Used during setup and app development |
| Contains `ubod-*` prefixed files only | Contains general templates |

---

## Deployment

**This content gets deployed to consuming repos!**

See `docs/UBOD_SETUP_GUIDE.md` Phase 1 (Step 1.6) for full instructions.

**Quick reference:**

```bash
# From monorepo root (where projects/ubod is a submodule)
mkdir -p .github/prompts/ubod .github/instructions/ubod

# IMPORTANT: Agents MUST be at root level (no ubod/ subfolder)
# VS Code only discovers agents at .github/agents/*.agent.md (root only)
cp projects/ubod/ubod-meta/agents/ubod-maintainer.agent.md .github/agents/ubod-maintainer.agent.md

# Prompts and instructions CAN use subfolders
cp projects/ubod/ubod-meta/prompts/ubod-*.prompt.md .github/prompts/ubod/
cp projects/ubod/ubod-meta/instructions/ubod-*.instructions.md .github/instructions/ubod/
```

**Target structure in consuming repo:**

```
.github/
├── agents/
│   └── ubod-maintainer.agent.md         # ✓ At root (VS Code discovers)
├── prompts/
│   └── ubod/                            # ✓ Subfolders OK for prompts
│       ├── ubod-bootstrap-app-context.prompt.md
│       ├── ubod-create-instruction.prompt.md
│       ├── ubod-update-instruction.prompt.md
│       └── ubod-generate-complexity-matrix.prompt.md
└── instructions/
    └── ubod/                            # ✓ Subfolders OK for instructions
        └── ubod-model-recommendations.instructions.md
```

**Why no agent subfolder?** VS Code only discovers `.md` files directly in `.github/agents/`, not in subdirectories. This limitation does NOT apply to prompts or instructions.

---

## Contents

### `agents/`

Agent personas for ubod maintenance work:

- **`ubod-maintainer.agent.md`** - Primary agent for working on ubod itself

### `prompts/`

Prompts for ubod maintenance tasks:

- **`ubod-update-instruction.prompt.md`** - Modify existing instructions
- **`ubod-create-instruction.prompt.md`** - Create new instructions
- **`ubod-bootstrap-app-context.prompt.md`** - Set up app-specific files in consuming repos
- **`ubod-generate-complexity-matrix.prompt.md`** - Create app-specific complexity signals

### `instructions/`

Instructions for ubod maintenance:

- **`ubod-model-recommendations.instructions.md`** - Which models for which ubod tasks

---

## How to Use

### When Maintaining Ubod (from consuming repo)

1. **Activate the agent:** Reference `.github/agents/ubod/ubod-maintainer.agent.md`
2. **Use meta-prompts:** For structured updates (in `.github/prompts/ubod/`)
3. **Follow model recommendations:** Loaded from `.github/instructions/ubod/`

### When Setting Up Ubod Initially

Use the main prompts (not meta):
- `prompts/01-setup-universal-kernel.prompt.md`
- `prompts/02-setup-app-specific.prompt.md`

---

## Why Deploy Meta Content?

Without deployment, only the ubod repo can maintain itself.

With deployment:
- ✅ Every consuming repo can create new instructions
- ✅ Every consuming repo can update existing instructions
- ✅ Model selection guidance is always available
- ✅ Ubod maintenance is decentralized

---

## Naming Convention

All meta files use the `ubod-` prefix:
- `ubod-maintainer.agent.md`
- `ubod-update-instruction.prompt.md`
- `ubod-model-recommendations.instructions.md`

This makes them clearly distinguishable from app-specific files (e.g., `tala-*.instructions.md`).
