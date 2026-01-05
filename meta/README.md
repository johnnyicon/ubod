# Meta - Ubod Self-Maintenance

**Purpose:** Everything in this folder is for maintaining ubod ITSELF. It is ALSO deployed to consuming repos so they can maintain ubod too.

---

## ⚠️ Important Distinction

| This Folder (`meta/`) | Other Folders (`templates/`, `prompts/`) |
|----------------------|------------------------------------------|
| For updating ubod | For initial ubod setup |
| Deployed to consuming repos for self-maintenance | One-time setup prompts |
| Used by anyone who needs to update ubod | Used during initial setup |

---

## Deployment

**This content gets deployed to consuming repos!**

See `docs/SETUP_GUIDE.md` Phase 3 for full instructions.

**Quick reference:**

```bash
# From monorepo root (where projects/ubod is a submodule)
mkdir -p .github/agents/ubod .github/prompts/ubod .github/instructions/ubod

cp projects/ubod/meta/agents/ubod-maintainer.agent.md .github/agents/ubod/
cp projects/ubod/meta/prompts/ubod-*.prompt.md .github/prompts/ubod/
cp projects/ubod/meta/instructions/ubod-*.instructions.md .github/instructions/ubod/
```

**Target structure in consuming repo:**

```
.github/
├── agents/
│   └── ubod/
│       └── ubod-maintainer.agent.md
├── prompts/
│   └── ubod/
│       ├── ubod-bootstrap-app-context.prompt.md
│       ├── ubod-create-instruction.prompt.md
│       ├── ubod-update-instruction.prompt.md
│       └── ubod-generate-complexity-matrix.prompt.md
└── instructions/
    └── ubod/
        └── ubod-model-recommendations.instructions.md
```

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
