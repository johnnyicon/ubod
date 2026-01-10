---
name: ubod-validate
description: Run all validation checks before committing Ubod changes
---

# Ubod Validation

**Purpose:** Run comprehensive validation checks on Ubod changes before commit

**When to Use:** After version bump and migration creation, before commit

---

## Overview

This prompt runs validation checks to ensure:
1. Templates are sanitized (no project-specific content)
2. Prompts have required metadata
3. Agents follow schema
4. Migrations are complete
5. No regressions introduced

**Blocking validation** - Must pass before `/ubod-commit`

---

## Validation Suite

### Check 1: Template Sanitization

**Purpose:** Ensure templates can be used by any consumer

**Commands:**
```bash
cd projects/ubod

# Check for project-specific names
grep -r "bathala-kaluluwa\|Tala\|tala" templates/ --exclude-dir=deprecated

# Check for hardcoded paths
grep -rE "/Users/[a-zA-Z]+|/home/[a-zA-Z]+|C:\\\\Users" templates/

# Check for internal URLs
grep -rE "https?://[^/]*\.(internal|local|corp)" templates/

# Check for API keys/secrets
grep -rE "api[_-]?key|token|secret" templates/ | grep -v "{{.*}}"
```

**Expected:** All commands return empty (exit code 1)

**If failures:**
```markdown
❌ Template Sanitization Failed

Found project-specific content:
- templates/agents/some-agent.md:15: "project-name"
- templates/instructions/example.md:42: "/Users/username/workspace"

Action required:
1. Replace with {{PLACEHOLDER}} syntax
2. Or move to ubod-meta/ if it's Ubod-specific (not a template)
```

---

### Check 2: Prompt Metadata

**Purpose:** Ensure all prompts accessible via `/command`

**Commands:**
```bash
cd projects/ubod

# Check all prompts have 'name' field
grep -L "^name:" ubod-meta/prompts/*.prompt.md

# Check name format (kebab-case)
grep "^name:" ubod-meta/prompts/*.prompt.md | grep -vE "^name: [a-z0-9-]+$"

# Check description exists
grep -L "^description:" ubod-meta/prompts/*.prompt.md
```

**Expected:** All commands return empty

**If failures:**
```markdown
❌ Prompt Metadata Failed

Missing 'name' field:
- ubod-meta/prompts/some-prompt.prompt.md

Invalid name format (must be kebab-case):
- ubod-meta/prompts/bad_name.prompt.md: "name: bad_name"

Action required:
1. Add 'name: kebab-case-name' to frontmatter
2. Update .vscode/settings.json if new prompt
```

---

### Check 3: Agent Schema Compliance

**Purpose:** Ensure agents follow standard schema

**Commands:**
```bash
cd projects/ubod

# Check COMMANDS section exists
grep -L "## COMMANDS" ubod-meta/agents/*.agent.md templates/agents/*.agent.md \
  --exclude="*deprecated*"

# Check BOUNDARIES section exists
grep -L "## BOUNDARIES" ubod-meta/agents/*.agent.md templates/agents/*.agent.md \
  --exclude="*deprecated*"

# Check tool aliases are standard (not VS Code specific)
grep -rE "read_file|replace_string|create_file" templates/agents/ \
  --exclude="*deprecated*"
```

**Expected:**
- First two commands return empty (all agents have required sections)
- Third command returns empty (no VS Code-specific tool names in templates)

**If failures:**
```markdown
❌ Agent Schema Validation Failed

Missing COMMANDS section:
- templates/agents/some-agent.md

Using VS Code-specific tool names:
- templates/agents/example-agent.md:45: "read_file" (use "read" instead)

Action required:
1. Add missing sections (see ubod-meta/schemas/agent-schema.md)
2. Replace tool names with standard aliases: ["read", "search", "edit", "execute"]
```

---

### Check 4: Migration Completeness

**Purpose:** Ensure migration has all required sections (if migration created)

**Check if migration exists:**
```bash
cd projects/ubod
ls ubod-meta/migrations/$(date +%Y-%m-%d)-*.md 2>/dev/null
```

**If migration exists, validate:**
```bash
cd projects/ubod
MIGRATION_FILE=$(ls ubod-meta/migrations/$(date +%Y-%m-%d)-*.md)

# Check required sections
grep -q "## What Changed" "$MIGRATION_FILE" || echo "Missing: What Changed"
grep -q "## Why This Change" "$MIGRATION_FILE" || echo "Missing: Why This Change"
grep -q "## Who Needs This Migration" "$MIGRATION_FILE" || echo "Missing: Who Needs"
grep -q "## Changes Required" "$MIGRATION_FILE" || echo "Missing: Changes Required"
grep -q "## Migration Steps" "$MIGRATION_FILE" || echo "Missing: Migration Steps"
grep -q "## Verification" "$MIGRATION_FILE" || echo "Missing: Verification"
grep -q "## Rollback" "$MIGRATION_FILE" || echo "Missing: Rollback"

# Check frontmatter
grep -q "^version:" "$MIGRATION_FILE" || echo "Missing: version field"
grep -q "^severity:" "$MIGRATION_FILE" || echo "Missing: severity field"
```

**Expected:** All checks silent (no "Missing:" output)

**If failures:**
```markdown
❌ Migration Validation Failed

Migration file: ubod-meta/migrations/2026-01-10-example.md

Missing sections:
- Verification
- Rollback

Missing frontmatter:
- severity field

Action required:
1. Add missing sections (see ubod-meta/migrations/README.md template)
2. Complete frontmatter (version, date, severity)
```

---

### Check 5: CHANGELOG Format

**Purpose:** Ensure CHANGELOG follows Keep a Changelog format

**Commands:**
```bash
cd projects/ubod

# Check latest version has date
tail -100 CHANGELOG.md | grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\] - [0-9]{4}-[0-9]{2}-[0-9]{2}"

# Check Unreleased section exists
grep -q "^## \[Unreleased\]" CHANGELOG.md || echo "Missing Unreleased section"

# Check categories exist
grep -E "^### (Added|Changed|Fixed|Removed|Deprecated|Security)" CHANGELOG.md | head -5
```

**Expected:**
- Version entry found with valid date format
- Unreleased section exists
- Standard categories used

**If failures:**
```markdown
❌ CHANGELOG Validation Failed

Issues:
- Latest version missing date: ## [1.4.0]
- Non-standard category found: ### Updates (use ### Changed)

Action required:
1. Fix version format: ## [X.Y.Z] - YYYY-MM-DD
2. Use standard categories: Added, Changed, Fixed, Removed, Deprecated, Security
```

---

### Check 6: File Structure

**Purpose:** Ensure no files in wrong locations

**Commands:**
```bash
cd projects/ubod

# Check no templates in ubod-meta/
find ubod-meta -name "*.template.md" -o -name "*{{*}}*"

# Check no meta content in templates/
grep -r "ubod-maintainer\|MODEL_RECOMMENDATIONS" templates/

# Check deprecated files properly archived
find templates -name "*.deprecated" | grep -v "deprecated/"
```

**Expected:** All commands return empty

**If failures:**
```markdown
❌ File Structure Validation Failed

Templates in ubod-meta/:
- ubod-meta/prompts/some-template.md (move to templates/)

Meta content in templates/:
- templates/agents/example.md mentions "ubod-maintainer"

Deprecated files not in deprecated/ folder:
- templates/agents/old-agent.md.deprecated

Action required:
1. Move templates to templates/
2. Move meta content to ubod-meta/
3. Move deprecated files to templates/agents/deprecated/
```

---

## Validation Report

**After running all checks, generate report:**

```markdown
## Ubod Validation Report

**Date:** 2026-01-10
**Files Checked:** [count]

### Results

| Check | Status | Details |
|-------|--------|---------|
| Template Sanitization | ✅ PASS | 0 project-specific references found |
| Prompt Metadata | ✅ PASS | All prompts have name + description |
| Agent Schema | ✅ PASS | All agents have COMMANDS + BOUNDARIES |
| Migration Completeness | ✅ PASS | All required sections present |
| CHANGELOG Format | ✅ PASS | Valid format, proper categories |
| File Structure | ✅ PASS | All files in correct locations |

**Overall: ✅ PASS** (6/6 checks passed)

**Files Ready for Commit:**
- projects/ubod/CHANGELOG.md
- projects/ubod/ubod-meta/migrations/2026-01-10-*.md
- projects/ubod/templates/agents/adr.agent.md
- projects/ubod/ubod-meta/prompts/adr/*.prompt.md

**Next Step:** Run `/ubod-commit` to stage and commit changes
```

**If any check fails:**
```markdown
## Ubod Validation Report

**Date:** 2026-01-10
**Files Checked:** [count]

### Results

| Check | Status | Details |
|-------|--------|---------|
| Template Sanitization | ❌ FAIL | 3 project-specific references found |
| Prompt Metadata | ✅ PASS | All prompts have name + description |
| Agent Schema | ⚠️ WARN | 1 agent missing BOUNDARIES section |
| Migration Completeness | ✅ PASS | All required sections present |
| CHANGELOG Format | ✅ PASS | Valid format, proper categories |
| File Structure | ✅ PASS | All files in correct locations |

**Overall: ❌ FAIL** (4/6 passed, 1 failed, 1 warning)

**Blocking Issues:**
1. Template Sanitization (FAIL):
   - templates/agents/example.md:15: "project-name"
   - templates/prompts/test.md:42: "/Users/username"

2. Agent Schema (WARN):
   - templates/agents/new-agent.md missing BOUNDARIES section

**Action Required:**
1. Fix blocking issues (sanitization)
2. Optional: Fix warnings (schema)
3. Re-run `/ubod-validate` to confirm

**Cannot proceed to commit until all FAIL checks pass.**
```

---

## Auto-Fix Mode (Optional)

**For common issues, offer auto-fix:**

```markdown
I can automatically fix some issues:

**Auto-fixable:**
- ✅ Add missing BOUNDARIES section to agents (template boilerplate)
- ✅ Add missing Unreleased section to CHANGELOG
- ✅ Add name field to prompts (infer from filename)

**Manual fix required:**
- ❌ Sanitize project-specific content (needs human judgment)
- ❌ Write migration content (needs human input)

Apply auto-fixes? yes | no
```

**If yes, apply fixes and re-run validation**

---

## Error Handling

**If validation commands fail (exit code != 0 and != 1):**
```markdown
❌ Validation command failed unexpectedly

Command: [command that failed]
Exit code: [code]
Output: [error output]

This might indicate:
- Missing files (CHANGELOG.md, expected directories)
- Corrupted repo structure
- Permission issues

Please check and re-run validation.
```

**If unsure about severity:**
```markdown
⚠️ Found potential issues but unsure if blocking:

Issue: [description]
Location: [file:line]

Is this acceptable? yes | no
```

---

## Tips

**Common Validation Failures:**

1. **Template Sanitization**
   - Replace hardcoded values with `{{PLACEHOLDER}}`
   - Move Ubod-specific content to `ubod-meta/`
   - Use generic examples, not real project names

2. **Prompt Metadata**
   - Always add `name:` and `description:` in frontmatter
   - Use kebab-case for names: `ubod-version-bump`, not `ubodVersionBump`
   - Update `.vscode/settings.json` for new prompts

3. **Agent Schema**
   - COMMANDS and BOUNDARIES are mandatory
   - Use standard tool aliases in templates (not VS Code specific)
   - Follow schema: `ubod-meta/schemas/agent-schema.md`

4. **Migration Completeness**
   - All 7 sections required (What, Why, Who, Changes, Steps, Verification, Rollback)
   - Include actual commands, not just descriptions
   - Test verification commands before documenting

---

## Integration with Other Prompts

**This prompt requires context from:**

- `/ubod-version-bump` - Which files were modified
- `/ubod-migration-create` - Migration file path (if created)

**This prompt outputs context for:**

- `/ubod-commit` - List of validated files ready to commit
- Validation status (PASS/FAIL/WARN)

**This prompt is invoked by:**

- `@ubod-checkin` agent - Before commit step
- User directly - When validating changes manually

---

**Remember:** Validation is blocking. Fix all FAIL checks before committing. Warnings are advisory but should be addressed.
