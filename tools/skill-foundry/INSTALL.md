# Skill-Foundry Installation Guide

## Prerequisites

- A workspace where you want to use Agent Skills
- Git (for Option 1)
- Python 3.7+ (for validation and scaffolding scripts)

---

## Installation Options

### Option 1: Via Ubod (Recommended)

**Best for:** Projects that use Ubod for AI coding infrastructure

```bash
# 1. Add Ubod as submodule (if not already present)
cd your-workspace
git submodule add https://github.com/johnnyicon/ubod.git projects/ubod

# 2. Install with skill-foundry
./projects/ubod/scripts/install.sh --with-skill-foundry

# 3. Verify installation
ls -la .github/skills/skill-foundry/
```

**What this installs:**
```
.github/skills/skill-foundry/     # Meta-skill (copied from Ubod)
├── SKILL.md
├── scripts/
│   ├── validate.py
│   └── scaffold.py
├── references/
│   ├── BEST_PRACTICES.md
│   ├── AGENT_PATTERNS.md
│   ├── SKILL_ANATOMY.md
│   ├── PORTABILITY.md
│   └── QUICK_START.md
└── templates/
    └── SKILL.template.md
```

---

### Option 2: Manual Copy (Standalone)

**Best for:** Projects that don't use Ubod or want just skill-foundry

```bash
# 1. Clone or download Ubod
git clone https://github.com/johnnyicon/ubod.git /tmp/ubod

# 2. Copy skill-foundry to your workspace
mkdir -p .github/skills
cp -r /tmp/ubod/tools/skill-foundry/skill-foundry .github/skills/

# 3. Verify installation
ls -la .github/skills/skill-foundry/
```

---

### Option 3: For Claude Code Only

**Best for:** Using Claude Code without VS Code

```bash
# Copy to Claude Code skills directory
mkdir -p .claude/skills
cp -r path/to/ubod/tools/skill-foundry/skill-foundry .claude/skills/

# Verify installation
ls -la .claude/skills/skill-foundry/
```

---

## Verification

### Test Meta-Skill Invocation

**In VS Code:**
```
@workspace /skill skill-foundry
```

You should see the skill-foundry skill loaded.

**In Claude Code:**
```
@skill-foundry
```

Or copy the content of `SKILL.md` directly into chat.

### Test Validation Script

```bash
cd .github/skills/skill-foundry
python scripts/validate.py examples/hello-world/SKILL.md
```

Expected output:
```
✅ Validation passed for examples/hello-world/SKILL.md
```

### Test Scaffolding Script

```bash
cd .github/skills/skill-foundry
python scripts/scaffold.py test-skill "Test skill for validation"
```

Expected output:
```
✅ Created skill: .github/skills/test-skill/SKILL.md
```

---

## Post-Installation Setup

### 1. Update .gitignore (Optional)

If you don't want to track generated skills:

```gitignore
# Generated skills (keep only templates)
.github/skills/*
!.github/skills/skill-foundry/
!.github/skills/README.md
```

### 2. Add Skills Index (Recommended)

Create `.github/skills/README.md`:

```markdown
# Custom Skills

## Available Skills

- `skill-foundry` - Create and validate portable Agent Skills
- `my-skill` - Description of your custom skill

## Usage

### VS Code
```
@workspace /skill skill-foundry
```

### Claude Code
```
@skill-foundry
```

## Creating New Skills

See skill-foundry/references/QUICK_START.md
```

### 3. Configure VS Code (Optional)

Add to `.vscode/settings.json`:

```json
{
  "github.copilot.customSkills": {
    "enabled": true,
    "skillsDirectories": [
      ".github/skills"
    ]
  }
}
```

---

## Platform-Specific Notes

### VS Code Custom Skills

**Requirements:**
- VS Code version 1.85+
- GitHub Copilot extension enabled
- Skills feature enabled (settings above)

**Invocation:**
```
@workspace /skill <skill-name>
```

**Skill location:**
- `.github/skills/<skill-name>/SKILL.md`

### Claude Code

**Requirements:**
- Claude Code desktop app or API access

**Invocation (if supported):**
```
@<skill-name>
```

**Or manual:**
1. Read `.claude/skills/<skill-name>/SKILL.md`
2. Copy content into chat
3. Ask Claude to follow those instructions

**Skill location:**
- `.claude/skills/<skill-name>/SKILL.md`

---

## Updating Skill-Foundry

### If Installed Via Ubod

```bash
# 1. Update Ubod submodule
cd projects/ubod
git pull origin main

# 2. Re-run installer
cd ../..
./projects/ubod/scripts/install.sh --with-skill-foundry

# 3. Verify version
cat .github/skills/skill-foundry/SKILL.md | grep "version:"
```

### If Manually Copied

```bash
# 1. Download latest from Ubod repo
git clone https://github.com/johnnyicon/ubod.git /tmp/ubod-latest

# 2. Backup current version
cp -r .github/skills/skill-foundry .github/skills/skill-foundry.backup

# 3. Copy new version
rm -rf .github/skills/skill-foundry
cp -r /tmp/ubod-latest/tools/skill-foundry/skill-foundry .github/skills/

# 4. Restore any custom changes (if you modified files)
# Compare .github/skills/skill-foundry.backup with new version
```

---

## Troubleshooting

### Skill Not Found

**VS Code:**
- Verify `.vscode/settings.json` includes skills directory
- Reload VS Code window
- Check skill name matches directory name

**Claude Code:**
- Verify skill is in `.claude/skills/`
- Try manual invocation (copy SKILL.md content)

### Validation Script Fails

```bash
# Check Python version
python --version  # Should be 3.7+

# Check script location
ls -la .github/skills/skill-foundry/scripts/validate.py

# Try explicit path
python .github/skills/skill-foundry/scripts/validate.py <skill-path>
```

### Permission Issues

```bash
# Make scripts executable
chmod +x .github/skills/skill-foundry/scripts/*.py

# Or run with explicit python
python .github/skills/skill-foundry/scripts/validate.py
```

---

## Uninstallation

### Complete Removal

```bash
# Remove skill-foundry
rm -rf .github/skills/skill-foundry

# Remove all custom skills (optional)
rm -rf .github/skills/*

# Remove VS Code config (optional)
# Edit .vscode/settings.json and remove github.copilot.customSkills
```

### Keep Custom Skills

```bash
# Remove only skill-foundry meta-skill
rm -rf .github/skills/skill-foundry

# Your custom skills remain in .github/skills/
```

---

## Next Steps

After installation:

1. **Quick Start** - Create your first skill in 5 minutes
   - Read [skill-foundry/references/QUICK_START.md]
   - Follow the example
   - Test it immediately

2. **Learn Best Practices** - Understand what makes great skills
   - Read [skill-foundry/references/BEST_PRACTICES.md]
   - Read [skill-foundry/references/SKILL_ANATOMY.md]

3. **Create Real Skills** - Build skills for your actual workflows
   - Use meta-skill: `@workspace /skill skill-foundry`
   - Or scaffold: `python scripts/scaffold.py my-skill "Description"`

4. **Iterate** - Refine based on real usage
   - Test with Claude on real tasks
   - Add examples when it misunderstands
   - Set boundaries when it does wrong things

---

## Support

- **Documentation:** See [README.md](README.md) for overview
- **Examples:** See [examples/](examples/) directory
- **Issues:** Report in Ubod repository
- **Updates:** Pull Ubod submodule for latest version
