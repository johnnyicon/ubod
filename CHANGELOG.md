# Ubod Changelog

All notable changes to Ubod will be documented in this file.

**Format:** Each version includes human-readable description AND LLM-actionable instructions.

**Versioning:** [Semantic Versioning](https://semver.org/)
- **Major:** Breaking changes (prompts renamed, structure changed)
- **Minor:** New features (new prompts, agents, instructions)
- **Patch:** Fixes (typos, improved wording, bug fixes)

---

## [Unreleased]

_Changes staged for next release_

---

## [1.2.0] - 2026-01-05

### Summary

Merged `ubod-sync.sh` and `ubod-update.sh` into single `ubod-upgrade.sh` for clarity. One script to rule them all.

### Changed

- **ubod-upgrade.sh** - Merged sync and update functionality
  ```yaml
  action: REFERENCE_ONLY
  source: scripts/ubod-upgrade.sh
  note: Run from ubod submodule, replaces both sync and update scripts
  ```
  - All file syncing logic (agents, prompts, instructions)
  - Changelog display and version tracking
  - Semi-automated and full-auto modes
  - Single entry point, less confusion

### Removed

- **ubod-sync.sh** - Merged into ubod-upgrade.sh
  ```yaml
  action: DELETE_FILE
  target: projects/ubod/scripts/ubod-sync.sh
  note: No longer needed, use ubod-upgrade.sh instead
  ```

- **ubod-update.sh** - Merged into ubod-upgrade.sh
  ```yaml
  action: DELETE_FILE
  target: projects/ubod/scripts/ubod-update.sh
  note: No longer needed, use ubod-upgrade.sh instead
  ```

### Fixed

- Fixed awk syntax error in changelog parsing (now uses bash regex)

### Instructions for Upgrading

From 1.1.0 to 1.2.0:

1. **Pull latest submodule:**
   ```bash
   cd projects/ubod && git pull origin main
   ```

2. **Use new script name:**
   ```bash
   cd projects/ubod && ./scripts/ubod-upgrade.sh
   ```

3. **Old scripts removed:**
   - `ubod-sync.sh` → Merged into `ubod-upgrade.sh`
   - `ubod-update.sh` → Renamed to `ubod-upgrade.sh`

---

## [1.1.0] - 2026-01-05

### Summary

Adds versioning system, semi-automated updates, architecture documentation, and enhanced agent generation with conditional UI/UX Designer for complex frontend frameworks.

### Added

- **CHANGELOG.md** - LLM-readable changelog with action types
  ```yaml
  action: DOCS_ONLY
  note: Version history for upgrade tracking
  ```

- **ARCHITECTURE.md** - Documents agent-instruction relationship
  ```yaml
  action: DOCS_ONLY
  note: Reference documentation, not deployed to consumer
  ```

- **ubod-update.sh** - Semi-automated update script
  ```yaml
  action: REFERENCE_ONLY
  source: scripts/ubod-update.sh
  note: Run from ubod submodule, not copied to .github/
  ```

- **ubod-version.template** - Template for version tracking file
  ```yaml
  action: REFERENCE_ONLY
  source: templates/ubod-version.template
  note: Consumer creates .ubod-version from this template
  ```

### Changed

- **ubod-bootstrap-app-context.prompt.md** - Now generates agents with full metadata
  ```yaml
  action: SYNC_FILE
  source: ubod-meta/prompts/ubod-bootstrap-app-context.prompt.md
  target: .github/prompts/ubod/ubod-bootstrap-app-context.prompt.md
  breaking: false
  ```
  - Generates 3 standard agents (Discovery, Implementer, Verifier)
  - Conditionally generates UI/UX Designer for complex frontend frameworks
  - Includes frontend complexity detection guide

- **ubod-update-agent.prompt.md** - Added batch and interactive modes
  ```yaml
  action: SYNC_FILE
  source: ubod-meta/prompts/ubod-update-agent.prompt.md
  target: .github/prompts/ubod/ubod-update-agent.prompt.md
  breaking: false
  ```

- **UBOD_SETUP_GUIDE.md** - Added versioning/update documentation
  ```yaml
  action: DOCS_ONLY
  note: Reference documentation updates
  ```

### Instructions for Upgrading

From 1.0.0 to 1.1.0:

1. **Pull latest submodule:**
   ```bash
   cd projects/ubod && git pull origin main
   ```

2. **Run update script:**
   ```bash
   cd projects/ubod && ./scripts/ubod-update.sh
   ```
   
   Or manually:
   ```bash
   cd projects/ubod && ./scripts/ubod-sync.sh --force
   ```

3. **Create/update .ubod-version:**
   ```bash
   cat > .ubod-version << EOF
   version: 1.1.0
   commit: $(cd projects/ubod && git rev-parse HEAD)
   updated: $(date +%Y-%m-%d)
   EOF
   ```

4. **Optional - Regenerate agents with UI/UX Designer:**
   If your app has complex frontend (Rails+Hotwire, Next.js RSC, etc.):
   - Run `/ubod-bootstrap-app-context`
   - Answer "yes" when asked about UI/UX Designer

5. **Update existing agents:**
   Run `/ubod-update-agent` with batch mode to add missing metadata

---

## [1.0.0] - 2026-01-05

### Summary

Initial versioned release of Ubod. Establishes the universal kernel pattern with meta content deployment, automated syncing, and agent/instruction framework.

### Added

- **ubod-update-agent.prompt.md** - Iterative agent improvements with batch/interactive modes
  ```yaml
  action: SYNC_FILE
  source: ubod-meta/prompts/ubod-update-agent.prompt.md
  target: .github/prompts/ubod/ubod-update-agent.prompt.md
  ```

- **ubod-sync.sh** - Automated syncing of ubod-meta content to .github/
  ```yaml
  action: SYNC_FILE
  source: scripts/ubod-sync.sh
  target: projects/ubod/scripts/ubod-sync.sh
  note: Script stays in submodule, not copied to .github/
  ```

- **app-specific-agent.template.md** - Canonical template for agent structure
  ```yaml
  action: REFERENCE_ONLY
  source: templates/agents/app-specific-agent.template.md
  note: Used by setup prompts, not deployed to consumer repo
  ```

- **copilot-instructions.template.md** - Navigation index template
  ```yaml
  action: REFERENCE_ONLY
  source: templates/copilot-instructions.template.md
  note: Used during Phase 3 setup, not auto-deployed
  ```

### Changed

- **ubod-migrate-copilot-instructions.prompt.md** - Now detects file structure before acting
  ```yaml
  action: SYNC_FILE
  source: ubod-meta/prompts/ubod-migrate-copilot-instructions.prompt.md
  target: .github/prompts/ubod/ubod-migrate-copilot-instructions.prompt.md
  breaking: false
  ```

- **UBOD_SETUP_GUIDE.md** - Merged Phase 1 + old Phase 3 into unified deployment
  ```yaml
  action: DOCS_ONLY
  note: No file sync needed, just updated documentation
  ```

### Instructions for Upgrading

If upgrading from pre-1.0.0 (unversioned):

1. **Run sync script:**
   ```bash
   cd projects/ubod && ./scripts/ubod-sync.sh
   ```

2. **Create .ubod-version file:**
   ```bash
   echo "version: 1.0.0" > .ubod-version
   echo "commit: $(cd projects/ubod && git rev-parse HEAD)" >> .ubod-version
   echo "updated: $(date +%Y-%m-%d)" >> .ubod-version
   ```

3. **Update copilot-instructions.md (if needed):**
   Run `/ubod-migrate-copilot-instructions` in Copilot chat

4. **Update agents (if sparse):**
   Run `/ubod-update-agent` with batch mode to add missing metadata

---

## Version Entry Template

_Use this format for future versions:_

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Summary

[One paragraph describing the release theme]

### Added

- **filename** - Description
  ```yaml
  action: SYNC_FILE | RUN_PROMPT | REFERENCE_ONLY | DOCS_ONLY
  source: path/in/ubod/submodule
  target: path/in/consumer/repo
  prompt: /prompt-name (if action is RUN_PROMPT)
  breaking: true | false
  note: Additional context
  ```

### Changed

- **filename** - Description
  ```yaml
  action: ...
  ```

### Removed

- **filename** - Description
  ```yaml
  action: DELETE_FILE
  target: path/to/remove
  ```

### Instructions for Upgrading

[Step-by-step upgrade instructions for this version]
```

---

## Action Types Reference

| Action | Meaning | Script Behavior |
|--------|---------|-----------------|
| `SYNC_FILE` | Copy/update file from ubod to consumer | Auto-synced by ubod-sync.sh |
| `RUN_PROMPT` | User must run a prompt in Copilot | Script lists prompt, user runs manually |
| `REFERENCE_ONLY` | Template/reference, not deployed | No action needed |
| `DOCS_ONLY` | Documentation update | No action needed |
| `DELETE_FILE` | Remove file from consumer | Script warns, user confirms deletion |
| `MANUAL` | Requires manual intervention | Script shows instructions |

---

## Reading This Changelog (For LLMs)

When processing this changelog to upgrade a consumer repo:

1. **Parse version entries** between current `.ubod-version` and latest
2. **Collect all actions** from each version's entries
3. **Group by action type:**
   - `SYNC_FILE` → Run ubod-sync.sh (handles these)
   - `RUN_PROMPT` → List for user to run manually
   - `DELETE_FILE` → Warn user, confirm before deleting
   - `MANUAL` → Show instructions to user
4. **Generate upgrade summary** with:
   - Files to sync (count)
   - Prompts to run (list)
   - Manual steps (list)
   - Breaking changes (warnings)
