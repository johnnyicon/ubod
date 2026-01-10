---
name: ubod-commit
description: Stage, commit, and push Ubod changes after validation passes
---

# Ubod Commit

**Purpose:** Stage files, generate commit message, and push Ubod release to origin

**When to Use:** After `/ubod-validate` passes

---

## Overview

This prompt:
1. Stages validated files (CHANGELOG, migrations, new files)
2. Generates semantic commit message
3. Shows git commands for user review
4. Executes commit and push (with user approval)
5. Invokes `/ubod-upgrade` to deploy to consumer repo

**Final step before consumer deployment**

---

## Step 1: Gather Context

**Required context from previous prompts:**

```markdown
I need context from previous steps:

1. **Version:** What version are we releasing?
   (from `/ubod-version-bump`)

2. **Change type:** patch | minor | major
   (from `/ubod-version-bump`)

3. **Change summary:** Brief description of changes
   (from `/ubod-version-bump`)

4. **Migration created:** yes | no
   (from `/ubod-migration-create`)

5. **Validation passed:** yes | no
   (from `/ubod-validate`)

Please provide this context, or I can read from previous steps.
```

**If context incomplete, read from files:**
```bash
cd projects/ubod

# Detect version from CHANGELOG
grep -m 1 "^## \[[0-9]" CHANGELOG.md | sed 's/## \[\(.*\)\].*/\1/'

# Check if migration exists
ls ubod-meta/migrations/$(date +%Y-%m-%d)-*.md 2>/dev/null

# Check git status
git status --short
```

---

## Step 2: Review Modified Files

**Show current git status:**
```bash
cd projects/ubod
git status --short
```

**Categorize files:**

```markdown
## Files to Stage

**Core Files:**
- M  CHANGELOG.md (version bump)
- ?? ubod-meta/migrations/2026-01-10-adr-system.md (migration)

**New Files:**
- ?? templates/agents/adr.agent.md
- ?? ubod-meta/prompts/adr/adr-gatekeeper.prompt.md
- ?? ubod-meta/prompts/adr/adr-writer.prompt.md
- ?? ubod-meta/prompts/adr/adr-commit.prompt.md
- ?? ubod-meta/prompts/adr/adr-health.prompt.md
- ?? ubod-meta/prompts/adr/adr-criteria.json

**Moved Files:**
- R  templates/agents/adr-writer.agent.md -> templates/agents/deprecated/adr-writer.agent.md.deprecated

**Deprecated:**
- ?? templates/agents/deprecated/DEPRECATION_NOTICE.md

Total files: 9
```

**Ask user:**
```markdown
Review files above. Include all in commit? yes | no

If no, which files to exclude?
```

---

## Step 3: Generate Commit Message

**Use semantic commit format:**

```
Format: release: v{VERSION} - {SUMMARY}

{DETAILED_DESCRIPTION}

{MIGRATION_NOTE}
{FILES_SUMMARY}
```

**Example:**
```
release: v1.4.0 - New ADR system with 4-prompt architecture

Replaced monolithic adr-writer.agent.md (506 lines) with specialized
prompts following Halo-Halo's single-responsibility pattern:

- /adr-gatekeeper - Assess, route, dedupe decisions
- /adr-writer - Create MADR-format ADRs with structured interview
- /adr-commit - Validate, final dedupe, git commit
- /adr-health - Scan catalog for stale/broken/conflicting ADRs
- adr.agent.md - Orchestration wrapper for conversational workflow
- adr-criteria.json - Decision tree, lifecycle rules, routing logic

Deprecated old adr-writer.agent.md → templates/agents/deprecated/

Migration: ubod-meta/migrations/2026-01-10-adr-system-redesign.md (⚠️ BREAKING)

Files changed:
- Added: 6 prompts + criteria.json + agent + deprecation notice
- Modified: CHANGELOG.md, README.md
- Moved: 1 deprecated agent
- Created: 1 migration file
```

**Show user:**
```markdown
## Proposed Commit Message

```
[full commit message]
```

Approve commit message? yes | no | edit

If edit, provide revised message.
```

---

## Step 4: Stage Files

**Generate staging commands:**

```bash
cd projects/ubod

# Stage core files
git add CHANGELOG.md

# Stage migration (if exists)
[[ -f ubod-meta/migrations/$(date +%Y-%m-%d)-*.md ]] && \
  git add ubod-meta/migrations/$(date +%Y-%m-%d)-*.md

# Stage new files
git add templates/agents/adr.agent.md
git add templates/agents/deprecated/
git add ubod-meta/prompts/adr/
git add ubod-meta/docs/ADR_SYSTEM_QUICK_REFERENCE.md
git add README.md

# Review staged changes
git status
git diff --staged --stat
```

**Show user:**
```markdown
## Staging Commands

```bash
[staging commands above]
```

These commands will:
1. Stage CHANGELOG.md
2. Stage migration file (if exists)
3. Stage 9 new/modified files
4. Show staged changes for review

Execute staging commands? yes | no
```

**If yes, execute commands and show results**

---

## Step 5: Review Staged Changes

**After staging, show diff summary:**

```bash
cd projects/ubod
git diff --staged --stat
git diff --staged --numstat | wc -l
```

**Generate summary:**
```markdown
## Staged Changes Summary

**Files staged:** 11
**Lines added:** +1,847
**Lines deleted:** -12

**Breakdown:**
- CHANGELOG.md: +15 -3
- templates/agents/adr.agent.md: +203 new
- ubod-meta/prompts/adr/adr-gatekeeper.prompt.md: +201 new
- ubod-meta/prompts/adr/adr-writer.prompt.md: +252 new
- ubod-meta/prompts/adr/adr-commit.prompt.md: +282 new
- ubod-meta/prompts/adr/adr-health.prompt.md: +254 new
- ubod-meta/prompts/adr/adr-criteria.json: +172 new
- templates/agents/deprecated/adr-writer.agent.md.deprecated: +506 moved
- templates/agents/deprecated/DEPRECATION_NOTICE.md: +98 new
- ubod-meta/docs/ADR_SYSTEM_QUICK_REFERENCE.md: +264 new
- README.md: +102 -9

Ready to commit? yes | no

If no, unstage with: git reset HEAD <file>
```

---

## Step 6: Commit

**Generate commit command:**

```bash
cd projects/ubod
git commit -m "release: v1.4.0 - New ADR system with 4-prompt architecture

Replaced monolithic adr-writer.agent.md (506 lines) with specialized
prompts following Halo-Halo's single-responsibility pattern:

- /adr-gatekeeper - Assess, route, dedupe decisions
- /adr-writer - Create MADR-format ADRs with structured interview
- /adr-commit - Validate, final dedupe, git commit
- /adr-health - Scan catalog for stale/broken/conflicting ADRs
- adr.agent.md - Orchestration wrapper for conversational workflow
- adr-criteria.json - Decision tree, lifecycle rules, routing logic

Deprecated old adr-writer.agent.md → templates/agents/deprecated/

Migration: ubod-meta/migrations/2026-01-10-adr-system-redesign.md (⚠️ BREAKING)

Files changed:
- Added: 6 prompts + criteria.json + agent + deprecation notice
- Modified: CHANGELOG.md, README.md
- Moved: 1 deprecated agent
- Created: 1 migration file"
```

**Show user:**
```markdown
## Commit Command

```bash
[commit command above]
```

Execute commit? yes | no
```

**If yes, execute and capture output:**
```bash
cd projects/ubod
git commit -m "[message]"
echo "Commit SHA: $(git rev-parse HEAD)"
```

**Show result:**
```markdown
✅ Committed

Commit SHA: abc1234567890abcdef1234567890abcdef1234
Branch: main
Files: 11 changed, +1,847 insertions(+), -12 deletions(-)
```

---

## Step 7: Push to Origin

**Generate push command:**

```bash
cd projects/ubod
git push origin main
```

**Show user:**
```markdown
## Push Command

```bash
git push origin main
```

This will push to:
- Remote: origin
- Branch: main
- Commits: 1 new commit (v1.4.0)

Execute push? yes | no

If no, you can push manually later with the command above.
```

**If yes, execute and show result:**
```markdown
✅ Pushed to origin/main

Remote: https://github.com/your-org/ubod
Branch: main
Commit: abc1234 (release: v1.4.0 - New ADR system...)
```

---

## Step 8: Invoke Consumer Upgrade

**Automatically hand off to `/ubod-upgrade`:**

```markdown
✅ Ubod v1.4.0 Released and Pushed

**Commit:** abc1234567890abcdef
**Remote:** origin/main

---

Now deploying to consumer repo...

Invoking: `/ubod-upgrade`

Context passed:
- Version: 1.4.0
- Type: minor
- Migration: ubod-meta/migrations/2026-01-10-adr-system-redesign.md (⚠️ BREAKING)
- Commit SHA: abc1234

---
```

**Then invoke `/ubod-upgrade` with full context**

**Note:** Step 8 is NOT complete until `/ubod-upgrade` finishes. Don't mark commit as "done" until consumer deployment confirms success.

---

## Final Output Report

**After all steps complete:**

```markdown
## Ubod Release: v1.4.0 Complete ✅

**Version:** 1.4.0 (was: 1.3.2)
**Type:** minor
**Date:** 2026-01-10

**Commits:**
- Ubod: abc1234567890abcdef
- Consumer: (pending /ubod-upgrade)

**Changes:**
- Added: New ADR system (6 prompts + agent + criteria)
- Changed: Deprecated old adr-writer.agent.md
- Migration: ⚠️ BREAKING (ubod-meta/migrations/2026-01-10-adr-system-redesign.md)

**Files:**
- Staged: 11 files
- Added: +1,847 lines
- Deleted: -12 lines

**Status:**
- ✅ CHANGELOG updated
- ✅ Migration created
- ✅ Validation passed
- ✅ Committed to Ubod repo
- ✅ Pushed to origin/main
- ⏳ Consumer deployment in progress...

**Next:**
- Wait for `/ubod-upgrade` to complete
- Consumers should run `./projects/ubod/scripts/ubod-upgrade.sh`
- Review migration guide if breaking changes affect their setup
```

---

## Error Handling

**If staging fails:**
```markdown
❌ Staging Failed

Error: [git error message]

Common causes:
- Files don't exist (typo in path?)
- Permission issues
- Git repo not clean

Action: Fix issue and re-run staging commands
```

**If commit fails:**
```markdown
❌ Commit Failed

Error: [git error message]

Common causes:
- No files staged
- Commit message format issue
- Git hooks blocking commit

Action: [specific fix based on error]
```

**If push fails:**
```markdown
❌ Push Failed

Error: [git error message]

Common causes:
- Not authenticated
- Branch protection rules
- Remote ahead of local (pull first)

Action:
1. If auth issue: git credential helper
2. If branch protection: Check GitHub settings
3. If behind remote: git pull --rebase && git push
```

---

## Safety Checks

**Before commit, verify:**
- [ ] Validation passed (from `/ubod-validate`)
- [ ] CHANGELOG updated (from `/ubod-version-bump`)
- [ ] Migration created if breaking (from `/ubod-migration-create`)
- [ ] No uncommitted sensitive data (secrets, API keys)
- [ ] Commit message follows semantic format
- [ ] User reviewed and approved staged changes

**If any check fails → STOP and fix before committing**

---

## Tips

**Semantic Commit Format:**
```
release: v{VERSION} - {SUMMARY}

{DETAILED_DESCRIPTION}

Migration: {PATH} ({SEVERITY})

Files changed:
- Added: {COUNT} files
- Modified: {COUNT} files
- Removed: {COUNT} files
```

**Commit Message Best Practices:**
- First line: `release: v{VERSION} - {SUMMARY}` (max 72 chars)
- Body: Detailed description, bullet points for multiple changes
- Include migration path and severity if breaking
- List file counts for context

**When to Skip Push:**
- Testing locally first
- Waiting for PR review (if using PRs for Ubod)
- Need to make additional changes before push

**Push can be done manually later:**
```bash
cd projects/ubod
git push origin main
```

---

## Integration with Other Prompts

**This prompt requires context from:**
- `/ubod-version-bump` - Version number, change summary
- `/ubod-migration-create` - Migration file path (if exists)
- `/ubod-validate` - Validation passed status

**This prompt invokes:**
- `/ubod-upgrade` - Deploy to consumer repo after push

**This prompt is invoked by:**
- `@ubod-checkin` agent - Final step before consumer deployment
- User directly - When committing validated changes manually

---

**Remember:** This is the final step in Ubod repo. After push, `/ubod-upgrade` deploys to consumer. Don't skip validation!
