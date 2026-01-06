# Local Development Workflow

**Purpose:** How to develop Ubod locally in a consuming monorepo

**Last Updated:** 2026-01-06

---

## The Setup

When you have Ubod as a submodule:

```
monorepo/
├── projects/ubod/              # Submodule (source of truth)
│   ├── templates/
│   ├── ubod-meta/
│   └── scripts/ubod-upgrade.sh
└── .github/                    # Deployed files (copied from submodule)
    ├── agents/
    ├── prompts/ubod/
    └── instructions/ubod/
```

**Key insight:** Changes in `projects/ubod/` don't automatically appear in `.github/`

---

## Workflow: Making Changes to Ubod

### Scenario 1: Quick Fix/Improvement While Working

**You discover an issue in Ubod while working on your app:**

1. **Make changes in `projects/ubod/`**
   ```bash
   # Edit files in submodule
   vim projects/ubod/templates/agents/discovery-planner.agent.md
   ```

2. **Test the change locally (optional)**
   ```bash
   # Run upgrade script to copy to .github/
   cd projects/ubod
   ./scripts/ubod-upgrade.sh --dry-run  # Preview
   ./scripts/ubod-upgrade.sh            # Actually sync
   ```
   This copies files from `projects/ubod/` → `.github/agents/`, `.github/prompts/ubod/`, etc.

3. **Verify in VS Code**
   - Reload window (if agents/prompts changed)
   - Test the agent/prompt
   - Confirm it works

4. **Commit to Ubod**
   ```bash
   cd projects/ubod
   git add .
   git commit -m "fix: [describe change]"
   git push origin main
   ```

5. **Update parent repo**
   ```bash
   cd ../..  # Back to monorepo root
   git add .github/ .ubod-version projects/ubod
   git commit -m "chore: Update ubod with [fix]"
   git push
   ```

### Scenario 2: Planned Ubod Enhancement

**You want to add a new feature to Ubod:**

1. **Branch in Ubod (optional but recommended)**
   ```bash
   cd projects/ubod
   git checkout -b feat/new-capability
   ```

2. **Make changes**
   - Edit templates, prompts, docs
   - Update CHANGELOG.md
   - Bump version if needed

3. **Test locally**
   ```bash
   ./scripts/ubod-upgrade.sh  # Sync to .github/
   # Test in VS Code
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: Add new capability"
   git push origin feat/new-capability  # Or main if not using branch
   ```

5. **Sync to other repos**
   - Pull in other consuming repos
   - Run ubod-upgrade.sh in each
   - Test and commit

---

## When to Run `ubod-upgrade.sh`

### Always Run After:

✅ **Making changes in `projects/ubod/` that affect deployed files**
- Edited templates (agents, instructions, prompts)
- Changed scripts
- Updated documentation that's deployed

✅ **Pulling latest Ubod from remote**
```bash
cd projects/ubod
git pull origin main
cd ../..
./projects/ubod/scripts/ubod-upgrade.sh
```

✅ **Switching branches in Ubod submodule**
```bash
cd projects/ubod
git checkout other-branch
cd ../..
./projects/ubod/scripts/ubod-upgrade.sh
```

### Don't Need to Run:

❌ **Making changes directly in `.github/`**
- If you edit `.github/agents/something.agent.md` directly
- Those changes are in parent repo, not Ubod
- (But you probably shouldn't do this - edit in `projects/ubod/` instead)

❌ **Changes to Ubod docs that aren't deployed**
- README.md updates
- Internal documentation
- Unless they're in `templates/` (which get copied)

---

## The Full Cycle

**Best practice for Ubod changes:**

```bash
# 1. Make sure you're current
cd projects/ubod
git pull origin main
cd ../..

# 2. Make your changes in projects/ubod/
vim projects/ubod/templates/...

# 3. Sync to .github/ to test
cd projects/ubod
./scripts/ubod-upgrade.sh
cd ../..

# 4. Test in VS Code
# (reload window if needed)
# Try the agent/prompt

# 5. If good, commit to Ubod
cd projects/ubod
git add .
git commit -m "fix: [change]"
git push origin main

# 6. Commit parent repo with updated submodule
cd ../..
git add .github/ .ubod-version projects/ubod
git commit -m "chore: Update ubod with [change]"
git push

# 7. Pull in other consuming repos
cd ~/other-monorepo
git pull
git submodule update --init --recursive
cd projects/ubod
./scripts/ubod-upgrade.sh
cd ../..
git add .github/ .ubod-version projects/ubod
git commit -m "chore: Update ubod with [change]"
git push
```

---

## Quick Commands

### Sync Ubod to Consuming Repo

```bash
# From monorepo root:
projects/ubod/scripts/ubod-upgrade.sh

# Or from within submodule:
cd projects/ubod
./scripts/ubod-upgrade.sh
cd ../..
```

### Pull Latest Ubod

```bash
cd projects/ubod
git pull origin main
cd ../..
projects/ubod/scripts/ubod-upgrade.sh
```

### Check What Would Change

```bash
projects/ubod/scripts/ubod-upgrade.sh --dry-run
```

---

## Common Pitfalls

### Pitfall 1: Forgetting to Run ubod-upgrade.sh

**Symptom:** You changed `projects/ubod/templates/agents/foo.agent.md` but VS Code still shows old version

**Why:** Changes in submodule don't auto-copy to `.github/agents/`

**Fix:** Run `projects/ubod/scripts/ubod-upgrade.sh`

### Pitfall 2: Editing `.github/` Directly

**Symptom:** Your changes get overwritten next time you run ubod-upgrade.sh

**Why:** ubod-upgrade.sh copies FROM `projects/ubod/` TO `.github/`

**Fix:** Always edit in `projects/ubod/`, then run upgrade script

### Pitfall 3: Forgetting to Update Other Repos

**Symptom:** Tala MVP has v1.3.2, but Tahua Engage still on v1.3.1

**Why:** Each repo needs to pull Ubod updates independently

**Fix:** After pushing Ubod changes, pull in ALL consuming repos same day

---

## Pro Tips

### Tip 1: Use Aliases

Add to `~/.zshrc` or `~/.bashrc`:

```bash
alias ubod-sync='projects/ubod/scripts/ubod-upgrade.sh'
alias ubod-pull='cd projects/ubod && git pull origin main && cd ../.. && projects/ubod/scripts/ubod-upgrade.sh'
```

Usage:
```bash
ubod-sync        # Just sync what's in submodule
ubod-pull        # Pull latest AND sync
```

### Tip 2: Check Diff Before Committing

```bash
# See what ubod-upgrade.sh would change:
projects/ubod/scripts/ubod-upgrade.sh --dry-run

# See what actually changed:
git diff .github/
```

### Tip 3: Use Ubod Maintainer Agent

When making Ubod improvements:

```
@ubod-maintainer I need to update the Discovery Planner template to include [feature]
```

The agent knows:
- Where files go (meta vs templates)
- Sanitization rules (no project-specific content)
- Proper {{PLACEHOLDER}} usage
- Cross-tool compatibility

---

## Summary

**Key Rule:** `projects/ubod/` is source, `.github/` is destination

**Workflow:**
1. Edit in `projects/ubod/`
2. Run `ubod-upgrade.sh` to sync
3. Test in VS Code
4. Commit to Ubod
5. Commit parent repo
6. Pull in other consuming repos

**Remember:** Changes in submodule need explicit sync via upgrade script.
