---
name: ubod-checkin
description: Formalized versioned check-in for Ubod changes — validates version bump, updates changelog, creates migration (if needed), and commits.
---

# Ubod Versioned Check-In Orchestrator

Purpose: Execute a strict, repeatable process when "checking in changes" to Ubod.

## Inputs
- Change summary: What changed (templates, prompts, instructions, schemas)
- Change type: patch | minor | major
- Breaking changes: yes/no (requires migration)

## Process

1) Detect current state
- Read ubod submodule HEAD
- Read latest version from `CHANGELOG.md`
- Read consumer `.ubod-version`

2) Determine next version
- If `major` → bump X+1.0.0
- If `minor` → bump X.Y+1.0
- If `patch` → bump X.Y.Z+1
- Verify the chosen version is not already used in `CHANGELOG.md`

3) Prepare changelog entry
- Insert new section at top: `## [X.Y.Z] - YYYY-MM-DD`
- Categorize changes (Added, Changed, Fixed, Removed, Security)
- Include LLM-actionable instructions for consumers

4) Migration (if breaking)
- Create file in `ubod-meta/migrations/YYYY-MM-DD-description.md`
- Include:
  - What changed and why
  - Who needs this migration
  - Verification commands (grep, paths)
  - Upgrade steps

5) Validate
- Ensure templates are sanitized (no project-specifics)
- Ensure prompts have `name:` frontmatter and are registered
- Ensure agent body sections follow canonical schema

6) Commit & push (Ubod repo)
- `git add CHANGELOG.md ubod-meta/migrations/`
- `git commit -m "chore(version): bump Ubod to X.Y.Z — <summary>"`
- `git push origin main`

7) Upgrade consumer
- Run `projects/ubod/scripts/ubod-upgrade.sh --auto`
- Commit `.ubod-version` and synced files to consumer repo

## Output Template

```
Version: X.Y.Z
Changes:
- Added: ...
- Changed: ...
- Fixed: ...
Migration: [created | not needed]
Consumer: Upgraded and `.ubod-version` updated
```

## Notes
- Always prefer `minor` for new features to templates/prompts; use `major` only for breaking template/schema changes.
- The upgrade script detects latest version from the Ubod `CHANGELOG.md`.
- Keep migrations small and precise; include verification commands.
