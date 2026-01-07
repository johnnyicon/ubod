---
name: ubod-upgrade
description: "Orchestrate upgrading Ubod in your monorepo: run script, then handle agents"
---

# Ubod Upgrade

> **When to use:**
> - You want to upgrade to the latest Ubod version
> - Ubod released new agents, prompts, or instructions
> - You want everything updated with one command
>
> **What happens:**
> 1. Display changelog (what changed)
> 2. Run ubod-upgrade.sh script (copies latest files)
> 3. Detect: new app or existing agents?
> 4. Hand off to /ubod-create-agents or /ubod-update-agent

---

## Architecture

This is a **two-layer system**:

**Layer 1: Script (Infrastructure)**
- `ubod-upgrade.sh` - Copies latest Ubod files from submodule
- Only runs when you explicitly need it OR when prompt doesn't exist yet

**Layer 2: Prompts (Orchestration)**
- This prompt - Coordinates the upgrade flow
- `/ubod-create-agents` - Generate new app agents
- `/ubod-update-agent` - Update existing agents

**Most of the time:** Just use this prompt. It runs the script via tools.  
**Sometimes first:** Run `ubod-upgrade.sh` manually if this prompt is outdated.

---

## Workflow

### Step 1: Show Changelog

Display what's changed since last version.

```
Check: Is ubod a submodule?
  → run_in_terminal: cd projects/ubod && git log --oneline -10
  
If not submodule:
  → Tell user to check CHANGELOG.md in Ubod docs
```

Ask user: "Would you like to proceed with upgrade?"

### Step 2: Run Upgrade Script

If user says yes, run the script:

```bash
cd projects/ubod
./scripts/ubod-upgrade.sh
```

Show output to user (copy/paste or terminal).

**Script does:**
- Detects your monorepo setup
- Shows version diff (old → new)
- **Migrates misplaced agents** from app folders → .github/agents/ (VS Code limitation)
- **Validates settings.json** format (object vs array, invalid keys)
- Copies: agents → .github/agents/, prompts → .github/prompts/ubod/, instructions → .github/instructions/ubod/
- Validates copilot-instructions.md has right structure
- Updates .ubod-version file

**If script shows warnings:**
- Settings.json format errors → Prompt will offer to auto-fix
- Misplaced agents → Already migrated by script

**If script fails:**
- Show error message
- Suggest: "Run `cd projects/ubod && ./scripts/ubod-upgrade.sh --dry-run` for preview"
- OR: "You may need to set up Ubod submodule first"

### Step 2a: Fix settings.json (If Needed)

**If script showed settings.json warnings:**

```markdown
## Settings.json Validation

The script detected format errors in `.vscode/settings.json`:

❌ Incorrect format issues found

Would you like me to auto-fix settings.json? (yes/no)
```

**If user says yes:**

```typescript
// Read current settings.json
read_file(".vscode/settings.json")

// Fix these issues:
// 1. Convert array format → object format with boolean values
// 2. Remove chat.agentFilesLocations (not a valid setting)

// CORRECT FORMAT:
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "apps/app-name/.copilot/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    ".github/prompts/ubod": true
  }
  // Note: NO chat.agentFilesLocations (agents always at .github/agents/)
}

// Save fixed version
replace_string_in_file(...) 
```

**Validation rules:**
- ✅ **instructionsFilesLocations**: Object with path keys → boolean values
- ✅ **promptFilesLocations**: Object with path keys → boolean values
- 🚫 **agentFilesLocations**: REMOVE this key (not supported, agents always at .github/agents/)
- 🚫 **Array format**: NEVER use `["path1", "path2"]` - causes "Expected object" lint errors

After fix:
```markdown
✅ Fixed settings.json format

Changes:
- Converted instructionsFilesLocations from array to object
- Converted promptFilesLocations from array to object
- Removed chat.agentFilesLocations (not a valid VS Code setting)

Please reload VS Code window for changes to take effect.
```

### Step 2b: Check Migrations (Automatic)

**After script runs, automatically check for unapplied migrations:**

```bash
# 1. List available migrations
ls -1 projects/ubod/ubod-meta/migrations/*.md | grep -v README

# 2. Check which migrations are tracked
grep -A 100 "migrations:" .ubod-version

# 3. Compare and identify unapplied migrations
```

**If unapplied migrations found:**

```markdown
## ⚠️ Unapplied Migrations Detected

The following migrations are available but not tracked in .ubod-version:

- migration-name-1.md
- migration-name-2.md

**Next Steps:**
1. Review each migration file
2. Apply fixes if needed (run verification commands)
3. Update .ubod-version migrations section

Would you like me to:
A) Show details for each migration
B) Apply migrations automatically (if possible)
C) Skip for now (you'll apply manually later)

Choose (A/B/C):
```

**If all migrations applied:**

```markdown
✅ All migrations up-to-date

Tracked in .ubod-version:
- [list of applied migrations]
```

**If .ubod-version missing migrations section:**

```markdown
⚠️ .ubod-version missing migrations tracking section

I'll add it now with empty array. You should verify which migrations were actually applied.

See "Tips" section below for migration verification commands.
```

Then add migrations section to .ubod-version:
```bash
echo "" >> .ubod-version
echo "# Applied migrations (add migration names as you apply them)" >> .ubod-version
echo "migrations: []" >> .ubod-version
```

### Step 3: Detect: New App or Existing?

After script runs, ask user:

```markdown
## Next Step

Does your project need:

1. **New app agents** - You added a new app (e.g., new Rails app, new Next.js app)
2. **Update existing agents** - You have agents already but want to update them
3. **Both** - Some new, some existing

Choose (1-2-3):
```

### Step 4: Hand Off to Appropriate Prompt

**If "1" or "3" (new app):**

```markdown
I'll help you generate agents for your new app.

Next, run: /ubod-create-agents

I'll hand off with:
- What script just deployed
- What to expect from agent generation
- Any version-specific changes from this upgrade
```

Hand off to `/ubod-create-agents` with context about:
- New COMMANDS and BOUNDARIES sections in template
- Version number just deployed
- What instruction files are available

**If "2" or "3" (update existing):**

```markdown
I'll help you update your existing agents.

Next, run: /ubod-update-agent

I'll hand off with:
- What structural changes are new (COMMANDS, BOUNDARIES sections)
- Which agents need updating
- Version number just deployed
```

Hand off to `/ubod-update-agent` with context about:
- New COMMANDS and BOUNDARIES sections
- Whether to apply structural changes or just metadata
- Version number just deployed

### Step 5: Show Summary

If user chooses "3" (both), show both handoffs:

```markdown
## Upgrade Complete! 

**Script:** ✓ Latest Ubod files deployed

**Next Steps:**

1. **For new apps:** Run `/ubod-create-agents`
   - Use new agent template with COMMANDS and BOUNDARIES
   
2. **For existing agents:** Run `/ubod-update-agent`
   - Update metadata AND apply structural changes
   
Choose in this order or run in parallel!
```

---

## Tips

**What if the script fails?**
- Check: Is ubod a submodule? `ls -la projects/ubod/`
- Check: Is `.github/` folder writable?
- Try: `./scripts/ubod-upgrade.sh --dry-run` to preview

**What if this prompt is out of date?**
- Run: `cd projects/ubod && ./scripts/ubod-upgrade.sh` manually
- Then this prompt will work with latest version

**What changed in this version?**
- Ask: "What's new in Ubod 1.3.0?" (or current version)
- I'll explain what changed based on CHANGELOG.md

**Do I need to migrate existing files?**

Check for unapplied migrations:

```bash
# 1. List available migrations
ls -1 projects/ubod/ubod-meta/migrations/*.md | grep -v README

# 2. Check which migrations are already applied
grep -A 100 "migrations:" .ubod-version

# 3. Compare: Apply any migration NOT in .ubod-version
```

**For each unapplied migration:**
1. Open the migration file
2. Check "Who Needs This Migration" section
3. If it applies to you, follow ALL steps (including fixes)
4. **MANDATORY: Run verification commands** from "Verification Checklist" section
5. **DO NOT mark complete** until all grep commands return 0 results
6. After VERIFIED, add to `.ubod-version`:
   ```yaml
   migrations:
     - 2026-01-06-vscode-agent-schema-fix  # Example
   ```

**Common migrations:**
- `2026-01-06-vscode-agent-schema-fix.md` - Fix agent tools, handoffs, prompt model field
  - **Verification required:** Run grep commands to verify no multiline prompts remain

**To apply migrations:**
- **Automated:** Use `/ubod-update-agent` prompt (batch mode) + VERIFY with grep
- **Manual:** Follow migration file instructions + VERIFY with grep
- **Track:** Only update `.ubod-version` AFTER verification passes

---

## Related Prompts

- `/ubod-create-agents` - Generate agents for a new app
- `/ubod-update-agent` - Update existing agents with new features
- `/ubod-create-instruction` - Create new instruction file
- `/ubod-update-instruction` - Update existing instruction file
