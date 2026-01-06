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

## [1.3.4] - 2026-01-06

### Fixed

- **Migration guide correction** - `2026-01-06-vscode-agent-schema-fix.md` incorrectly stated to remove `label` from handoffs
  - VS Code schema REQUIRES `label` field in handoffs
  - Corrected: Keep `label`, only convert multiline `prompt: |` to single-line `prompt: "..."`
  - This caused upgrade LLMs to skip fixing handoffs, perpetuating schema violations

---

## [1.3.3] - 2026-01-06

### Summary

**⚠️ BREAKING CHANGES** - Fixed agent and prompt schema to comply with VS Code requirements. Existing agents/prompts created before this date require migration.

### Breaking Changes

- **Agent `tools:` field** - Changed to VS Code-valid tool names only
  - Valid: `["read", "search", "edit", "execute"]`
  - Invalid: `["read_file", "create_file", "grep_search", ...]`
  
- **Agent `handoffs:` format** - Single-line prompts only
  - Valid: `prompt: "Single line string"`
  - Invalid: `prompt: |` (multiline YAML)
  - Removed `label:` field (not used by VS Code)
  
- **Prompt `model:` field** - Removed from all prompts
  - Not a valid frontmatter field in VS Code prompt schema
  - Only `description:` is supported

### Migration Required

**See:** `migrations/2026-01-06-vscode-agent-schema-fix.md` for detailed migration guide

**Quick migration:**
```bash
# Use automated migration
@workspace /ubod-update-agent
# Choose option 3: Batch mode
```

### Fixed

- All agent templates in `templates/agents/*.agent.md`
- All meta prompts in `ubod-meta/prompts/*.prompt.md`
- `ubod-maintainer` agent tools and handoffs
- Commit message template in `ubod-update-instruction.prompt.md` (changed `(ubod)` → `(scope)`)

### Added

- **Migration system** - `migrations/` folder with dated migration guides
- `migrations/README.md` - Migration system documentation
- `migrations/2026-01-06-vscode-agent-schema-fix.md` - First migration guide
- Updated `ubod-upgrade.prompt.md` to reference migrations

---

## [1.3.2] - 2026-01-06

### Summary

Fixed agent tool definitions in templates to use actual VS Code tool names instead of generic placeholders. This ensures generated agents can execute tasks correctly. Added changelog template and enhanced ubod-maintainer agent with workflow guidance.

### Fixed

- **Agent tool definitions** - Templates now specify actual tool names
  ```yaml
  action: TEMPLATE_CHANGE
  files:
    - ubod-meta/prompts/ubod-create-agents.prompt.md
    - ubod-meta/prompts/ubod-update-agent.prompt.md
  note: Replaced generic ["read", "search", "execute"] with actual tool names
  ```
  - Discovery agents: `["read_file", "grep_search", "semantic_search", "file_search", "list_dir", "create_file"]`
  - Implementer agents: `["read_file", "create_file", "replace_string_in_file", "multi_replace_string_in_file", "run_in_terminal", "grep_search"]`
  - Verifier agents: `["read_file", "run_in_terminal", "grep_search", "get_terminal_output"]`
  - UI/UX Designer agents: `["read_file", "semantic_search", "grep_search", "create_file"]`

### Enhanced

- **ubod-maintainer agent** - Added workflow guidance for common maintenance tasks
  ```yaml
  action: REFERENCE_ONLY
  file: templates/agents/ubod-maintainer.agent.md (deployed to .github/agents/)
  added: Tasks for updating tool definitions and changelog entries
  ```
  - New task: "Update Agent Tool Definitions" with standard tool patterns
  - New task: "Update Changelog" with versioning guidance
  - References CHANGELOG_TEMPLATE.md for consistent entries

### Added

- **CHANGELOG_TEMPLATE.md** - Standard template for changelog entries
  ```yaml
  action: REFERENCE_ONLY
  file: templates/CHANGELOG_TEMPLATE.md
  note: Reference document for maintainers updating CHANGELOG.md
  ```
  - Defines categories (Added, Fixed, Enhanced, Changed, Deprecated, Removed)
  - Explains action types (REFERENCE_ONLY, TEMPLATE_CHANGE, etc.)
  - Provides version numbering guidelines (MAJOR.MINOR.PATCH)
  - Includes example entries with YAML blocks
  - Documents workflow for creating new entries

### Root Cause

**Issue:** Agent templates used generic tool names (`["read", "search", "execute"]`) that don't match actual VS Code tool capabilities. These placeholders were meant to be replaced but weren't specific enough, leading to generated agents with incorrect tool definitions.

**Impact:** Generated agents had tool names that VS Code doesn't recognize, preventing them from:
- Creating files (no `create_file`)
- Editing code (no `replace_string_in_file`, `multi_replace_string_in_file`)
- Running commands (no `run_in_terminal`)
- Getting command output (no `get_terminal_output`)
- Searching effectively (generic `search` instead of `semantic_search`, `grep_search`, `file_search`)

**Solution:**
1. Updated all agent templates with correct, specific tool names that match VS Code capabilities
2. Documented standard tool assignment patterns by agent role
3. Added CHANGELOG_TEMPLATE.md for future consistency in versioning and documentation
4. Enhanced ubod-maintainer agent with clear workflow for tool definition updates
5. Established this as the canonical pattern for future agent generation

---

## [1.3.1] - 2026-01-06

### Summary

Critical fix for VS Code agent discovery limitation + automated migration of misplaced agents + settings.json validation.

### Fixed

- **Agent migration** - Detect and move agents from app folders to .github/agents/
  ```yaml
  action: AUTOMATED_MIGRATION
  script: scripts/ubod-upgrade.sh (migrate_misplaced_agents function)
  note: VS Code only discovers agents at .github/agents/ root level
  ```
  - Scans all `apps/*/.copilot/agents/` for agent files
  - Migrates them to `.github/agents/` automatically
  - Removes empty directories after migration
  - Shows warning explaining VS Code limitation

- **settings.json validation** - Detect and report format errors
  ```yaml
  action: VALIDATION_CHECK
  script: scripts/ubod-upgrade.sh (validate_settings_json function)
  note: Detects array vs object format, invalid keys
  ```
  - Checks for incorrect array format (causes "Expected object" lint error)
  - Checks for invalid `chat.agentFilesLocations` key (not supported by VS Code)
  - Provides correct format example
  - Prompts user to run `/ubod-upgrade` for auto-fix

- **settings.json auto-fix** - Correct format errors automatically
  ```yaml
  action: AUTO_FIX
  prompt: ubod-meta/prompts/ubod-upgrade.prompt.md (Step 2a)
  note: Converts array format to object format, removes invalid keys
  ```
  - Converts `chat.instructionsFilesLocations` from array to object with boolean values
  - Converts `chat.promptFilesLocations` from array to object with boolean values
  - Removes `chat.agentFilesLocations` (not a valid VS Code setting)
  - Validates final format

### Enhanced

- **ubod-upgrade.sh** - Added pre-sync migration and validation
  ```yaml
  action: REFERENCE_ONLY
  file: scripts/ubod-upgrade.sh
  functions:
    - migrate_misplaced_agents() - Moves agents from app folders to root
    - validate_settings_json() - Checks format and reports errors
  ```
  - Runs before file sync to catch issues early
  - Provides clear error messages with examples
  - Non-blocking (warnings only, doesn't fail upgrade)

- **ubod-upgrade prompt** - Added settings.json auto-fix step
  ```yaml
  action: REFERENCE_ONLY
  file: ubod-meta/prompts/ubod-upgrade.prompt.md
  added: Step 2a - Fix settings.json (If Needed)
  ```
  - Offers to auto-fix after script validation
  - Shows correct format with explanations
  - Validates after fix

- **ubod-create-agents prompt** - Added prominent agent placement warning
  ```yaml
  action: REFERENCE_ONLY
  file: ubod-meta/prompts/ubod-create-agents.prompt.md
  added: Critical warning box about .github/agents/ requirement
  ```

- **UBOD_SETUP_GUIDE.md** - Fixed incorrect agent placement docs
  ```yaml
  action: DOCUMENTATION_FIX
  file: docs/UBOD_SETUP_GUIDE.md
  section: "Step 2.5: Save App-Specific Files"
  ```
  - Removed instructions to create `apps/{app}/.copilot/agents/`
  - Added critical warning about VS Code limitation
  - Shows correct structure with agents at root

### Root Cause

**VS Code Limitation:** Agents are only discovered at `.github/agents/` root level. Unlike instructions and prompts (which support subfolders via `chat.instructionsFilesLocations` and `chat.promptFilesLocations`), there is NO `chat.agentFilesLocations` setting. All agents must be at root.

**Impact:** Any agents placed in `apps/{app}/.copilot/agents/` won't be discovered by VS Code Copilot.

**Solution:**
1. Migration script moves existing misplaced agents to root
2. Documentation updated to reflect correct placement
3. Create-agents prompt warns prominently about limitation
4. Settings.json validation catches incorrect configuration

---

## [1.3.0] - 2026-01-05

### Summary

Simplified agent management workflow with clearer prompt names, orchestrator prompt, and enhanced agent template. Two-layer system: infrastructure script + coordination prompts.

### Added

- **ubod-upgrade prompt** - Orchestrator prompt for upgrading Ubod
  ```yaml
  action: REFERENCE_ONLY
  file: .github/prompts/ubod/ubod-upgrade.prompt.md
  note: New entry point - runs script, detects app context, hands off to create/update
  commands:
    - /ubod-upgrade (run this first, it orchestrates everything)
  ```
  - Displays changelog
  - Runs ubod-upgrade.sh script via tools
  - Detects: new app or existing agents?
  - Hands off to /ubod-create-agents or /ubod-update-agent

- **COMMANDS section** in agent template
  ```yaml
  action: TEMPLATE_CHANGE
  file: templates/agents/app-specific-agent.template.md
  section: COMMANDS
  note: Lists executable commands this agent uses
  ```
  - Executable commands with flags
  - Organized by purpose
  - Example: `/ubod-create-agents`, `/ubod-update-agent`, test runners, linters

- **BOUNDARIES section** in agent template
  ```yaml
  action: TEMPLATE_CHANGE
  file: templates/agents/app-specific-agent.template.md
  section: BOUNDARIES
  note: Three-tier boundary system from GitHub research
  ```
  - ✅ Always do: Actions agent always performs
  - ⚠️ Ask first: Actions requiring user confirmation
  - 🚫 Never do: Actions agent must avoid

- **RESOURCES.md** - Design bibliography documenting influences
  ```yaml
  action: REFERENCE_ONLY
  file: docs/RESOURCES.md
  note: External articles and inspiration (no system impact)
  ```
  - GitHub blog: 2,500+ repos analysis
  - What we adopted vs. what we didn't (with rationale)
  - Template for future resource additions

### Renamed

- **ubod-bootstrap-app-context.prompt.md** → **ubod-create-agents.prompt.md**
  ```yaml
  action: RENAME_FILE
  old: projects/ubod/ubod-meta/prompts/ubod-bootstrap-app-context.prompt.md
  new: projects/ubod/ubod-meta/prompts/ubod-create-agents.prompt.md
  note: Clearer intent - generates agents for new apps
  commands:
    - /ubod-create-agents (was: /ubod-bootstrap-app-context)
  why: "bootstrap" unclear about what's being bootstrapped, "create-agents" explicit
  ```

### Enhanced

- **ubod-update-agent.prompt.md** - Now applies structural changes too
  ```yaml
  action: REFERENCE_ONLY
  file: ubod-meta/prompts/ubod-update-agent.prompt.md
  scope: BOTH metadata AND structural template changes
  ```
  - Still adds missing metadata (tools, infer, handoffs)
  - NEW: Adds COMMANDS section if missing
  - NEW: Adds BOUNDARIES section if missing
  - Can operate in single, interactive, or batch modes

### Architecture

**Two-Layer System (clearer mental model):**

| Layer | Type | What | When |
|-------|------|------|------|
| **Infrastructure** | Script | `ubod-upgrade.sh` - copies files | Rarely (or first-time) |
| **Coordination** | Prompts | `/ubod-upgrade` → `/ubod-create-agents` \| `/ubod-update-agent` | Every day |

**Workflow Simplified:**
- **Most of the time:** Just run `/ubod-upgrade` (orchestrator)
- **Sometimes first:** Run `ubod-upgrade.sh` script manually (if prompt outdated or first-time)
- **Never again:** No need to remember which script or prompt to run - it's all orchestrated

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
