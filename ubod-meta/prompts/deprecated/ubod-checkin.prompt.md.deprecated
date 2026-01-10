---
name: ubod-checkin
description: Formalized versioned check-in for Ubod changes — validates version bump, updates changelog, creates migration (if needed), and commits.
---

# Ubod Versioned Check-In Orchestrator

Purpose: Execute a strict, repeatable process when "checking in changes" to Ubod.

**WHEN TO USE:** When Ubod Maintainer is ready to release accumulated changes as a new version.

---

## Phase 1: Gather Context

**Ask user if not provided:**
1. Change summary: What changed (templates, prompts, instructions, schemas)?
2. Change type: patch | minor | major?
3. Breaking changes: yes/no (requires migration)?

**Then detect current state:**

```bash
cd projects/ubod
git log --oneline -5  # Show recent commits
grep -A 5 "^## \[" CHANGELOG.md | head -20  # Show latest versions
```

### Checklist: Phase 1
- [ ] Change summary collected
- [ ] Change type determined (patch/minor/major)
- [ ] Breaking changes identified (yes/no)
- [ ] Current version detected from CHANGELOG
- [ ] Recent commits reviewed

**STOP: Show findings to user before proceeding to Phase 2**

---

## Phase 2: Version Calculation

**Determine next version:**
- If `major` → bump X+1.0.0
- If `minor` → bump X.Y+1.0
- If `patch` → bump X.Y.Z+1

**Verify version doesn't already exist:**
```bash
cd projects/ubod
grep "^## \[$NEW_VERSION\]" CHANGELOG.md  # Should return empty
```

### Checklist: Phase 2
- [ ] Next version calculated (show: current → new)
- [ ] Verified version doesn't exist in CHANGELOG
- [ ] Version bump logic matches change type

**STOP: Show version bump plan to user before proceeding to Phase 3**

---

## Phase 3: CHANGELOG Update

**Move [Unreleased] → [X.Y.Z]:**
1. Read current `[Unreleased]` section from CHANGELOG
2. Create new `## [X.Y.Z] - YYYY-MM-DD` section
3. Move all entries from `[Unreleased]` to new version section
4. Ensure categorization: Added, Changed, Fixed, Removed, Security
5. Verify LLM-actionable instructions are included
6. Leave new empty `[Unreleased]` section

### Checklist: Phase 3
- [ ] Read current `[Unreleased]` content
- [ ] Created `[X.Y.Z]` section with today's date
- [ ] Moved all entries from Unreleased → versioned section
- [ ] Verified categories (Added/Changed/Fixed/Removed/Security)
- [ ] Verified LLM-actionable instructions present
- [ ] New empty `[Unreleased]` section remains

**STOP: Show CHANGELOG diff before proceeding to Phase 4**

---

## Phase 4: Migration (if breaking)

**If breaking changes = yes:**

1. Check if migration already exists:
   ```bash
   ls projects/ubod/ubod-meta/migrations/$(date +%Y-%m-%d)-*.md
   ```

2. If missing, create from template (see `ubod-meta/migrations/README.md` lines 75+):
   - Title: Clear description of change
   - Date: YYYY-MM-DD
   - Version: OLD → NEW
   - Severity: 🔴 CRITICAL | ⚠️ BREAKING | 🟡 RECOMMENDED | 🟢 OPTIONAL
   - What Changed
   - Who Needs This Migration
   - Changes Required (before/after examples)
   - Migration Steps (automated + manual)
   - Verification Checklist
   - Rollback instructions

### Checklist: Phase 4
- [ ] Breaking changes assessed (yes/no)
- [ ] If yes: Migration file exists or created
- [ ] Migration follows template structure
- [ ] Verification commands included
- [ ] Rollback plan documented

**If no breaking changes:** Skip Phase 4

**STOP: Show migration file path (if created) before proceeding to Phase 5**

---

## Phase 5: Validation

**Run validation checks:**

```bash
cd projects/ubod

# Check templates are sanitized (no project-specifics)
grep -r "bathala-kaluluwa\|Tala\|/Users/kanekoa" templates/
# Should return empty

# Check prompts have name field
grep -L "^name:" ubod-meta/prompts/*.prompt.md
# Should return empty

# Check agents follow schema
grep -L "## COMMANDS" ubod-meta/agents/*.agent.md templates/agents/*.agent.md
# Should return empty
```

### Checklist: Phase 5
- [ ] Templates sanitized (no project-specific content)
- [ ] All prompts have `name:` field in frontmatter
- [ ] All agents have COMMANDS section
- [ ] No grep validation errors

**STOP: Show validation results before proceeding to Phase 6**

---

## Phase 6: Commit & Push (Ubod repo)

**Commit sequence:**

```bash
cd projects/ubod
git add CHANGELOG.md
[[ -f ubod-meta/migrations/$(date +%Y-%m-%d)-*.md ]] && git add ubod-meta/migrations/
git status  # Review staged files
git commit -m "release: v$NEW_VERSION - $SUMMARY

$DETAILED_DESCRIPTION"
git push origin main
```

### Checklist: Phase 6
- [ ] Staged: CHANGELOG.md
- [ ] Staged: migration file (if created)
- [ ] Git status reviewed
- [ ] Commit message follows format: `release: v$VERSION - $SUMMARY`
- [ ] Pushed to origin/main

**STOP: Show commit SHA before proceeding to Phase 7**

---

## Phase 7: Upgrade Consumer

**Now automatically invoke /ubod-upgrade to deploy to consumer repo:**

```markdown
✅ Ubod v$NEW_VERSION released and pushed

Now deploying to consumer repo...

Invoking: /ubod-upgrade

---
```

**Then invoke the ubod-upgrade prompt:**
- Hand off complete context (version, changelog, migration info)
- ubod-upgrade will handle:
  - Submodule update
  - Running ubod-upgrade.sh
  - Migration checking (automatic)
  - .ubod-version validation
  - Consumer repo commit

### Checklist: Phase 7
- [ ] /ubod-upgrade invoked with full context
- [ ] ubod-upgrade completed successfully
- [ ] Consumer repo committed (or user chose to commit later)

**Note:** Phase 7 is NOT complete until /ubod-upgrade finishes. Don't mark ubod-checkin as "complete" until /ubod-upgrade confirms deployment.

---

## Final Output Report

**After completing all 7 phases, provide:**

```markdown
## Ubod Version Release: vX.Y.Z ✅

**Version:** X.Y.Z (was: X.Y.Z-1)
**Type:** [patch | minor | major]
**Date:** YYYY-MM-DD

**Changes:**
- Added: ...
- Changed: ...
- Fixed: ...

**Migration:** [created: path/to/migration.md | not needed]

**Commits:**
- Ubod: [commit SHA]
- Consumer: [commit SHA]

**Verification:**
- [ ] CHANGELOG updated
- [ ] Migration created (if breaking)
- [ ] Validations passed
- [ ] Pushed to origin/main
- [ ] Consumer upgraded

**Next Steps:**
- Consumers should run `./projects/ubod/scripts/ubod-upgrade.sh`
- [If migration exists] Follow migration guide: [path]
```

---

## Notes

**Version Bump Guidelines:**
- **Patch (X.Y.Z+1):** Bug fixes, typo corrections, documentation improvements
- **Minor (X.Y+1.0):** New features (agents, prompts, instructions), non-breaking enhancements
- **Major (X+1.0.0):** Breaking changes (schema changes, structure changes, renamed files)

**Migration Requirements:**
- Always create migration for breaking changes
- Include verification commands in migration
- Reference migration template: `ubod-meta/migrations/README.md` (lines 75+)

**Validation Gates:**
- Each phase ends with **STOP** - show results before proceeding
- User must approve before moving to next phase
- Never skip validation checks
