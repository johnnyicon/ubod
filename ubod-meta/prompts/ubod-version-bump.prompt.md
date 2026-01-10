---
name: ubod-version-bump
description: Calculate next version and update CHANGELOG for Ubod release
---

# Ubod Version Bump

**Purpose:** Calculate semantic version bump and update CHANGELOG.md for Ubod release

**When to Use:** First step in Ubod release workflow (before migration/validation/commit)

---

## Overview

This prompt:
1. Detects current version from CHANGELOG
2. Calculates next version based on change type
3. Moves `[Unreleased]` entries to new version section
4. Validates CHANGELOG format

**Does NOT commit** - Use `/ubod-commit` after validation passes

---

## Step 1: Gather Context

**Ask user if not provided:**

```markdown
I need to bump Ubod version. Please tell me:

1. **Change summary:** What changed in this release?
   (e.g., "New ADR system with 4 prompts", "Fixed agent schema validation")

2. **Change type:** patch | minor | major?
   - patch (X.Y.Z+1): Bug fixes, typos, documentation
   - minor (X.Y+1.0): New features, non-breaking enhancements
   - major (X+1.0.0): Breaking changes, schema changes

3. **Breaking changes:** yes | no
   (If yes, migration will be needed)
```

**If user provides incomplete info, ask for missing pieces.**

---

## Step 2: Detect Current State

**Read CHANGELOG to find current version:**

```bash
cd projects/ubod
grep -A 5 "^## \[" CHANGELOG.md | head -20
```

**Parse output to determine:**
- Current version (e.g., `## [1.3.2] - 2026-01-06`)
- Whether `[Unreleased]` section has content

**Show user:**
```markdown
Current State:
- Current version: 1.3.2
- Unreleased changes: [Yes/No]
- Change type: [patch/minor/major]
- Next version: 1.4.0
```

**Stop for approval before proceeding.**

---

## Step 3: Calculate Next Version

**Apply semantic versioning rules:**

| Current | Change Type | Next Version |
|---------|-------------|--------------|
| 1.3.2   | patch       | 1.3.3        |
| 1.3.2   | minor       | 1.4.0        |
| 1.3.2   | major       | 2.0.0        |

**Verify version doesn't already exist:**
```bash
cd projects/ubod
grep "^## \[$NEW_VERSION\]" CHANGELOG.md
```

**If version exists → ERROR:** "Version $NEW_VERSION already released. Check CHANGELOG."

**If unique → Show user:**
```markdown
Version Bump Plan:
- From: 1.3.2
- To: 1.4.0
- Type: minor
- Date: 2026-01-10
```

**Stop for approval before proceeding.**

---

## Step 4: Read Unreleased Section

**Extract current `[Unreleased]` content:**

```bash
cd projects/ubod
sed -n '/^## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | head -n -1
```

**Parse into categories:**
- Added
- Changed
- Fixed
- Removed
- Deprecated
- Security

**Validate:**
- [ ] At least one category has content
- [ ] Each entry is actionable (describes WHAT to do, not just WHAT changed)
- [ ] Breaking changes marked with ⚠️ if applicable

**If validation fails:**
```markdown
❌ Unreleased section validation failed:

Issues:
- [Issue 1: e.g., "No entries in Unreleased section"]
- [Issue 2: e.g., "Entry lacks actionable instructions"]

Please update CHANGELOG.md [Unreleased] section first.
```

**If validation passes → Show user:**
```markdown
Unreleased Content (to be moved to v1.4.0):

### Added
- New ADR system with 4-prompt architecture
- adr.agent.md orchestration wrapper

### Changed
- Deprecated monolithic adr-writer.agent.md

Ready to update CHANGELOG?
```

**Stop for approval before proceeding.**

---

## Step 5: Update CHANGELOG

**Perform these edits using `replace_string_in_file`:**

### 5A: Create New Version Section

**Find this:**
```markdown
## [Unreleased]

### Added
- New ADR system with 4-prompt architecture

### Changed
- Deprecated monolithic adr-writer.agent.md
```

**Replace with:**
```markdown
## [Unreleased]

## [1.4.0] - 2026-01-10

### Added
- New ADR system with 4-prompt architecture
  - `/adr-gatekeeper` - Assess, route, dedupe
  - `/adr-writer` - Create MADR-format ADRs
  - `/adr-commit` - Validate and commit
  - `/adr-health` - Catalog maintenance
  - `adr.agent.md` - Orchestration wrapper
  - `adr-criteria.json` - Decision tree, lifecycle rules

### Changed
- Deprecated monolithic `adr-writer.agent.md` (506 lines)
- Moved to `templates/agents/deprecated/` with DEPRECATION_NOTICE.md
- Updated README.md with ADR system documentation
```

### 5B: Verify Format

**Read updated CHANGELOG and verify:**
- [ ] New version section exists: `## [1.4.0] - YYYY-MM-DD`
- [ ] Date is correct (today's date)
- [ ] All categories properly formatted (### Added, ### Changed, etc.)
- [ ] Each entry has actionable instructions
- [ ] New `[Unreleased]` section is empty (or has placeholder comment)
- [ ] No duplicate version numbers

**If verification fails → Show errors and ask user to fix manually**

**If verification passes → Show diff:**
```markdown
✅ CHANGELOG Updated

Changes:
- Created [1.4.0] section with 2026-01-10 date
- Moved 6 entries from [Unreleased]
- Categories: Added (6), Changed (2)
- New [Unreleased] section ready for next changes

Diff preview:
[Show first 20 lines of diff]

Ready to proceed to validation?
```

---

## Step 6: Summary Output

**Provide structured summary for next step:**

```markdown
## Version Bump Complete ✅

**Version:** 1.4.0 (was: 1.3.2)
**Type:** minor
**Date:** 2026-01-10
**Breaking:** no

**CHANGELOG Status:**
- ✅ [Unreleased] moved to [1.4.0]
- ✅ Date set to 2026-01-10
- ✅ Format validated
- ✅ Categories: Added (6), Changed (2)

**Files Modified:**
- projects/ubod/CHANGELOG.md

**Next Steps:**
1. If breaking changes: Run `/ubod-migration-create`
2. If no breaking changes: Run `/ubod-validate`
3. After validation: Run `/ubod-commit`

**Context for Next Prompt:**
- Version: 1.4.0
- Change type: minor
- Breaking: no
- Summary: New ADR system with 4-prompt architecture
```

---

## Error Handling

**If current version can't be detected:**
```markdown
❌ Cannot detect current version from CHANGELOG.md

Please ensure CHANGELOG.md has at least one released version like:
## [1.3.2] - 2026-01-06
```

**If [Unreleased] is empty:**
```markdown
⚠️ Warning: [Unreleased] section is empty

No changes to release. Did you forget to document changes in CHANGELOG?

Options:
1. Cancel version bump (add changes to [Unreleased] first)
2. Proceed anyway (creates empty release - not recommended)
```

**If version already exists:**
```markdown
❌ Version 1.4.0 already exists in CHANGELOG

Current released versions:
- [1.4.0] - 2026-01-08
- [1.3.2] - 2026-01-06

Please check if you meant to bump to 1.4.1 (patch) or 1.5.0 (minor).
```

---

## Validation Rules

**CHANGELOG Format Requirements:**

✅ **Valid:**
```markdown
## [1.4.0] - 2026-01-10

### Added
- Feature description with actionable instructions
  - Detail 1
  - Detail 2
```

❌ **Invalid:**
```markdown
## [1.4.0]  # Missing date
## 1.4.0 - 2026-01-10  # Missing brackets
## [1.4.0] - Jan 10  # Wrong date format
```

**Actionable Instructions:**

✅ **Good:**
```markdown
### Added
- New `/adr-gatekeeper` prompt for decision assessment
  - Invoke with: `/adr-gatekeeper`
  - Checks threshold criteria, routes to correct location
```

❌ **Bad:**
```markdown
### Added
- Added gatekeeper  # Not actionable - what IS it? How to use it?
```

---

## Tips

**Semantic Versioning Guidelines:**

- **Patch (X.Y.Z+1):** Bug fixes, typo corrections, documentation improvements
  - Example: Fix validation bug, correct typo in README

- **Minor (X.Y+1.0):** New features, non-breaking enhancements
  - Example: New agent, new prompt, new instruction template

- **Major (X+1.0.0):** Breaking changes, schema changes, renamed core files
  - Example: Change agent schema, rename directories, change file structure

**When in doubt, choose minor over patch** - New functionality typically deserves minor bump even if small.

---

## Integration with Other Prompts

**This prompt outputs context needed by:**

- `/ubod-migration-create` - Needs version, breaking flag
- `/ubod-validate` - Needs modified files list
- `/ubod-commit` - Needs version, summary, change type

**This prompt is invoked by:**

- `@ubod-checkin` agent - Orchestrates full workflow
- User directly - When explicit control desired

---

**Remember:** This prompt ONLY updates CHANGELOG. No git commits. Use `/ubod-commit` after validation passes.
