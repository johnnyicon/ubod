# Ubod Versioning Workflow

**Last Updated:** 2026-01-06  
**Purpose:** Multi-repo version management to avoid conflicts

---

## The Versioning System

### Version File: `.ubod-version`

Located at monorepo root, tracks current Ubod version:

```yaml
version: 1.3.1
commit: 8edc697
updated: 2026-01-06
```

**Purpose:**
- Consumer repos know which Ubod version they're using
- Upgrade script compares current vs latest
- Tracks submodule commit hash for exact reproducibility

---

## Multi-Repo Scenario: Version Collision Risk

**The Problem:**

If two repos (e.g., Tala MVP and Tahua Engage) both:
1. Make improvements to Ubod
2. Bump the version independently
3. Push to Ubod repo

**Result:** Version collision (both try to create v1.3.2, for example)

---

## Workflow Rules

### Rule 1: Always Pull Before Bumping

**Before making ANY changes to Ubod:**

```bash
cd projects/ubod
git pull origin main
git log --oneline -5  # Check latest changes
```

**Why:** Ensures you're working from latest version, prevents collision

### Rule 2: Check Other Repos First

**Before bumping version, check if other repos have pending changes:**

```bash
# If you have access to other repos:
cd ~/Workspace/tahua-engage-monorepo
cd projects/ubod
git status  # Are there uncommitted changes?
git log --oneline origin/main..main  # Unpushed commits?
```

**If yes:** Coordinate with yourself/team to merge first

### Rule 3: Version Bump = Immediate Push

**As soon as you bump the version in Ubod:**

```bash
# In Ubod submodule:
cd projects/ubod
git add .
git commit -m "feat: v1.3.2 - [feature description]"
git push origin main  # Push IMMEDIATELY

# In parent repo:
cd ..
git add .ubod-version projects/ubod
git commit -m "chore: Upgrade to Ubod 1.3.2"
git push origin [branch]
```

**Why:** Minimizes window where another repo might bump same version

### Rule 4: Use Feature Branches for Major Changes

**For significant Ubod improvements:**

```bash
cd projects/ubod
git checkout -b feat/new-capability
# Make changes
git commit -m "feat: Add new capability"
# DON'T bump version yet

# Open PR to Ubod main
# Coordinate version bump as part of merge
```

**Why:** Prevents premature version bumps, allows review before release

---

## Collision Resolution

**If collision happens (two repos create same version):**

### Option A: Fast-Follow Version

```bash
# Repo 2 discovers Repo 1 already pushed v1.3.2
cd projects/ubod
git pull origin main
# Your changes conflict with v1.3.2

# Resolve conflicts, then bump to v1.3.3:
# Update CHANGELOG.md:
# - v1.3.3 (your changes)
# - v1.3.2 (other repo's changes)

git add .
git commit -m "feat: v1.3.3 - [your feature]"
git push origin main
```

### Option B: Semantic Versioning for Parallel Work

**If both changes are unrelated:**

- Repo 1: v1.3.2 (bug fix)
- Repo 2: v1.4.0 (new feature)

Use semantic versioning to indicate scope:
- Patch bump (1.3.x): Bug fixes, small improvements
- Minor bump (1.x.0): New features, backward-compatible
- Major bump (x.0.0): Breaking changes

---

## Best Practices

### Practice 1: Daily Sync

**If actively working on Ubod in multiple repos:**

```bash
# Morning routine:
cd projects/ubod
git pull origin main
git log --oneline -10  # What changed overnight?
```

### Practice 2: Announce Version Bumps

**In your workflow (Slack, notes, etc.):**

```
"Bumping Ubod to v1.3.2 with agent migration fix - pulling to Tahua Engage next"
```

**Why:** Prevents simultaneous bumps

### Practice 3: Consumer Repo Updates

**After Ubod version bump, update all consumer repos:**

```bash
# In each monorepo:
cd projects/ubod
git pull origin main

cd ..
./projects/ubod/scripts/ubod-upgrade.sh

# Commit and push parent repo
git add .ubod-version projects/ubod .github/
git commit -m "chore: Upgrade to Ubod [version]"
git push
```

**Why:** Keeps all repos in sync, prevents drift

---

## The .ubod-version Contract

### What It Tracks

```yaml
version: 1.3.1        # Semantic version (major.minor.patch)
commit: 8edc697       # Exact submodule commit hash
updated: 2026-01-06   # Last upgrade date
```

### How It's Used

**By ubod-upgrade.sh:**
```bash
# Compares:
CURRENT_VERSION=$(grep "version:" .ubod-version | awk '{print $2}')
LATEST_VERSION=$(cd projects/ubod && git describe --tags --abbrev=0)

if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
  echo "Upgrade available: $CURRENT_VERSION → $LATEST_VERSION"
fi
```

**By you:**
- Quick check: "What version am I using?"
- Reproducibility: "What exact commit is this?"
- Upgrade decision: "Should I upgrade now?"

---

## When to Bump Versions

### Patch (1.3.x → 1.3.y)

**Bug fixes, documentation, small improvements:**
- Fix typo in prompt
- Update documentation
- Small script improvement
- No new features

**Example:** v1.3.1 (agent migration fix)

### Minor (1.x.0 → 1.y.0)

**New features, backward-compatible:**
- New agent template section (COMMANDS, BOUNDARIES)
- New prompt added
- New workflow capability
- Existing features still work

**Example:** v1.3.0 (orchestration simplification)

### Major (x.0.0 → y.0.0)

**Breaking changes:**
- File structure changes requiring manual migration
- Removed prompts (force users to update)
- Changed agent template structure (incompatible)
- Renamed required fields

**Example:** v2.0.0 (hypothetical: complete restructure)

---

## Quick Reference: Pre-Bump Checklist

**Before bumping ANY version:**

- [ ] Pull latest from Ubod main (`git pull origin main`)
- [ ] Check other repos for pending Ubod changes
- [ ] Update CHANGELOG.md with version entry
- [ ] Run tests (if applicable)
- [ ] Commit all changes
- [ ] Tag version: `git tag v1.3.2` (optional but helpful)
- [ ] Push immediately: `git push origin main --tags`
- [ ] Update all consumer repos ASAP

---

## Multi-Repo Coordination Examples

### Example 1: Sequential Updates (Recommended)

**Timeline:**

1. **Day 1, Repo A:** Make improvement, bump to v1.3.2, push
2. **Day 1, Repo A:** Pull v1.3.2 into consumer repos
3. **Day 2, Repo B:** Pull latest (gets v1.3.2), make improvement, bump to v1.3.3, push
4. **Day 2, Repo A:** Pull v1.3.3 into consumer repos

**Result:** No conflicts, clean version history

### Example 2: Parallel Work (Requires Coordination)

**Timeline:**

1. **Day 1, Both:** Pull latest Ubod (v1.3.1)
2. **Day 1, Repo A:** Start working on feature A (branch: feat/feature-a)
3. **Day 1, Repo B:** Start working on feature B (branch: feat/feature-b)
4. **Day 2, Repo A:** Open PR, merge to main as v1.3.2
5. **Day 2, Repo B:** Pull v1.3.2, rebase feat/feature-b, merge as v1.3.3

**Result:** Coordinated via branches, clean merge

### Example 3: Collision (What NOT To Do)

**Timeline:**

1. **Day 1, Both:** Pull latest Ubod (v1.3.1)
2. **Day 1, Repo A:** Make improvement, bump to v1.3.2, push
3. **Day 1, Repo B:** Make improvement, bump to v1.3.2, try to push
4. **Day 1, Repo B:** Push rejected (non-fast-forward)

**Result:** Repo B must pull, resolve, bump to v1.3.3

**Fix:** Follow Rule 1 (always pull first)

---

## Future Improvements

**Potential enhancements to prevent collisions:**

### Idea 1: Lock File

```yaml
# .ubod-lock
locked_by: tahua-engage-monorepo
locked_at: 2026-01-06T14:30:00Z
reason: Working on v1.3.2 agent improvements
```

**Workflow:**
- Before bumping, create lock file
- Push lock file (signals "I'm working on this")
- Other repos see lock, wait or coordinate

### Idea 2: Automated Version Check

```bash
# In ubod-upgrade.sh:
check_pending_versions() {
  # Query GitHub API for unpushed branches with version bumps
  # Warn user if collision detected
}
```

### Idea 3: Version Reservation

```yaml
# NEXT_VERSION.md
reserved: v1.3.2
by: tahua-engage-monorepo
at: 2026-01-06
```

**Workflow:**
- Reserve next version before working
- Push reservation to main
- Prevents others from using same version

---

## Summary

**Key Principles:**

1. **Always pull first** - Prevents most collisions
2. **Bump and push immediately** - Minimizes collision window
3. **Use feature branches for major work** - Allows coordination
4. **Communicate version bumps** - Manual coordination works
5. **Fast-follow if collision** - Simple resolution strategy

**For your workflow (one person, two repos):**

- Pull Ubod main before starting work in ANY repo
- Push version bumps immediately
- Update other repos same day
- Document which repo is actively working on Ubod

This prevents 99% of collisions with minimal overhead.
