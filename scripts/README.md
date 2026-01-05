# Ubod Scripts

This folder contains scripts to validate, manage, and extend Ubod.

## Available Scripts

### `validate-setup.sh`

**Purpose:** Verify that Ubod has been correctly set up in your monorepo

**Usage:**
```bash
bash scripts/validate-setup.sh /path/to/monorepo
```

**What it checks:**
- ✅ All Ubod directories exist
- ✅ All required files are present
- ✅ Template files have correct structure
- ✅ Generated files (if any) are in correct locations

**Output:**
- Summary of passed/failed/warned checks
- Actionable next steps

**When to run:**
- After cloning/setting up Ubod
- After generating outputs from Prompt 1 or 2
- To verify setup completeness

---

## Future Scripts

Scripts that could be added:

- **setup-initial.sh** - Automated first-time setup
- **generate-from-prompts.sh** - Automated Prompt 1 & 2 execution
- **migrate-to-ubod.sh** - Migrate from manual setup to Ubod
- **check-consistency.sh** - Verify all apps follow patterns

Feel free to contribute scripts!

---

**See also:**
- [SETUP_GUIDE.md](../docs/SETUP_GUIDE.md) for manual validation steps

**Last Updated:** January 5, 2026
