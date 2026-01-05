# Meta - Ubod Self-Maintenance

**Purpose:** Everything in this folder is for maintaining ubod ITSELF, not for deploying to consuming repos.

---

## ⚠️ Important Distinction

| This Folder (`meta/`) | Other Folders (`templates/`, `prompts/`) |
|----------------------|------------------------------------------|
| For updating ubod | For deploying to consuming repos |
| Used by ubod maintainers | Used by ubod consumers |
| Project-specific OK here | Must be universal |

---

## Contents

### `agents/`

Agent personas for ubod maintenance work:

- **`ubod-maintainer.agent.md`** - Primary agent for working on ubod itself

### `prompts/`

Prompts for ubod maintenance tasks:

- **`update-ubod-instruction.prompt.md`** - Modify existing instructions
- **`create-ubod-instruction.prompt.md`** - Create new instructions
- **`bootstrap-app-context.prompt.md`** - Set up app-specific files in consuming repos
- **`generate-complexity-matrix.prompt.md`** - Create app-specific complexity signals

### `instructions/`

Instructions specific to ubod maintenance (not for consuming repos):

- *(Add maintenance-specific instructions here)*

### `MODEL_RECOMMENDATIONS.md`

Which LLM models to use for different types of ubod work.

---

## How to Use

### When Maintaining Ubod

1. **Activate the agent:** Reference `meta/agents/ubod-maintainer.agent.md`
2. **Use meta-prompts:** For structured updates
3. **Follow model recommendations:** For quality assurance

### When Consuming Ubod

Don't use anything in `meta/`. Use:
- `prompts/` for setup prompts
- `templates/` for deployable content
- `docs/` for guidance

---

## Why This Separation Matters

Without separation, you might:
- ❌ Deploy meta-prompts to consuming repos (confusing)
- ❌ Edit templates with project-specific content (breaks universality)
- ❌ Lose track of what's for ubod vs. what's for consumers

With separation:
- ✅ Clear mental model: meta/ = ubod work, templates/ = consumer work
- ✅ Safe to evolve meta/ without affecting consumers
- ✅ Easy to know which prompts to use when
