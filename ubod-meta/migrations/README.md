# Ubod Migrations

This folder contains migration guides for breaking changes in Ubod.

---

## What Are Migrations?

When Ubod releases changes that require updates to existing files (agents, prompts, instructions), we create a **migration guide** documenting:

- What changed and why
- Who needs to apply the migration
- Step-by-step instructions (automated + manual)
- Verification checklist
- Rollback instructions

---

## How to Use Migrations

### Migration Tracking

Ubod tracks applied migrations in `.ubod-version` (like Rails `schema_migrations`):

```yaml
# .ubod-version
version: 1.3.3
commit: abc123d
updated: 2026-01-06

# Applied Migrations
migrations:
  - 2026-01-06-vscode-agent-schema-fix
```

**How it works:**
- Migration filename (without `.md`) is added to list
- Upgrade prompt compares available vs applied migrations
- Shows only unapplied migrations
- You update the list after applying each migration

### When Upgrading Ubod

1. Run `/ubod-upgrade` prompt or `./scripts/ubod-upgrade.sh`
2. Check which migrations apply to you
3. Follow migration guide for each applicable change
4. Verify changes worked

### Finding Applicable Migrations

**By date:** Migrations are dated `YYYY-MM-DD-description.md`

If you haven't upgraded since `2025-12-01`, check all migrations after that date.

**By symptom:** Look for migration titles matching your issue:
- "VS Code agent schema" - Agent/prompt diagnostic errors
- "Instruction file format" - Instruction syntax changes
- "Template structure" - Agent template updates

---

## Available Migrations

<!-- Auto-generated list (update when adding new migrations) -->

### 2026

- [2026-01-06 - VS Code Agent Schema Fixes](./2026-01-06-vscode-agent-schema-fix.md)
  - **Severity:** ⚠️ BREAKING
  - **Applies to:** All repos with agents created before Jan 6, 2026
  - **Fixes:** Agent `tools:` field, handoff format, prompt `model:` field

---

## Migration Checklist Template

When creating a new migration:

```markdown
# Migration: [Title]

**Date:** YYYY-MM-DD
**Version:** X.Y → X.Z
**Severity:** 🔴 CRITICAL | ⚠️ BREAKING | 🟡 RECOMMENDED | 🟢 OPTIONAL

## What Changed
[Brief summary of what changed and why]

## Who Needs This Migration
[Clear criteria for who should apply this]

## Changes Required
[Detailed before/after examples]

## Migration Steps
### Automated (if available)
### Manual

## Verification Checklist
- [ ] ...

## Rollback
[How to undo if something goes wrong]

## Related Files
[Links to relevant ubod files]
```

---

## Questions?

Open an issue in the ubod repo or check `docs/FAQ.md`.
