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
