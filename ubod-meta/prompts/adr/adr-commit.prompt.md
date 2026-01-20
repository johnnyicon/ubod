---
name: "ADR: Commit & Validate"
description: "Validate, dedupe, and commit ADR files to git"
---

# ADR Commit

You validate ADR files, perform final deduplication check, generate commit messages, and commit ADR files to git.

**Prerequisites:** ADR files have been created/updated via `/adr-writer`

---

## Step 1: Discover Uncommitted ADR Files

**Find all new/modified ADR files:**

```bash
# Check git status for ADR-related changes
git status --porcelain | grep -E 'docs/ADR|ADR/'
```

**Parse results:**
- `A` = New file (added)
- `M` = Modified file (updated)
- `??` = Untracked file (new, not staged)

**List for user:**
```markdown
## Uncommitted ADRs Found

1. **[apps/tala/docs/ADR/2026-01-10-dual-layer-retry-strategy.md](path)** (NEW)
   - Title: Adopt Dual-Layer Retry Strategy
   - Status: ACCEPTED
   - Impact: HIGH

2. **[apps/tala/docs/ADR/2026-01-07-tiptap-editor-component.md](path)** (AMENDED)
   - Title: Adopt Reusable Tiptap Editor ViewComponent
   - Status: AMENDED
   - Impact: MEDIUM

**Commit all (Y) or select specific ones (S)?**
```

**User response:**
- `Y` → Proceed with all
- `S` → Ask which ones to commit (numbered list)
- `N` → Abort

---

## Step 2: Validate Each ADR (MANDATORY)

**For EACH ADR file to be committed:**

### 2.1: Schema Validation

Read ADR and check:

- [ ] **Frontmatter present:**
  - Date (YYYY-MM-DD format)
  - Status (PROPOSED/ACCEPTED/DEPRECATED/SUPERSEDED/AMENDED)
  - Deciders (team or person name)

- [ ] **Required sections present:**
  - Title (starts with #, action-oriented)
  - Context and Problem Statement
  - Decision Drivers (at least 2)
  - Considered Options (at least 2)
  - Decision Outcome (chosen + rationale + trade-offs)
  - Consequences (positive + negative + neutral)
  - Pros and Cons of Options (for each option)
  - More Information (links section)

- [ ] **File naming convention:**
  - Format: `YYYY-MM-DD-slug.md`
  - Date matches frontmatter date
  - Slug is kebab-case

**If validation FAILS:**
```markdown
❌ **Validation Failed**

File: `{path}`
Issues:
- Missing required section: [section name]
- Invalid frontmatter: [what's wrong]
- File naming issue: [what's wrong]

**Cannot commit until fixed.**

Would you like me to:
1. Fix issues automatically
2. Show you what needs fixing
3. Skip this ADR for now
```

**Block commit if ANY ADR fails validation** (user must fix or skip)

### 2.2: Link Validation

Check all links in ADR:

```markdown
**Links to verify:**
- [ ] Related PRD exists (if linked)
- [ ] Related ADRs exist (if linked)
- [ ] Commit hashes are valid (if referenced)
- [ ] Superseded ADR exists + has reciprocal link (if status=SUPERSEDED)
```

**If links broken:**
```markdown
⚠️ **Broken Links Found**

File: `{path}`
Issues:
- PRD link 404: `{link}`
- Related ADR not found: `{link}`
- Commit hash invalid: `{hash}`

**Action:**
- Fix links before commit (recommended)
- OR commit anyway with broken links (not recommended)

Fix now? (Y/N)
```

**Allow commit with broken links** (warning, not blocker) - user decides

### 2.3: Sanitization Check (for public repos only)

**Check repo visibility:**
```bash
git remote -v | grep -E 'github.com|gitlab.com'
# If public repo, perform sanitization check
```

**Scan ADR content for:**
- API keys (patterns: `key=`, `token=`, `secret=`)
- Internal URLs (patterns: `.internal`, `.local`, specific domains)
- Email addresses (pattern: `@[domain]`)
- Phone numbers (pattern: digit sequences)

**If sensitive data found:**
```markdown
🔒 **Sensitive Data Detected** (Public Repo)

File: `{path}`
Found:
- API key on line 45: `openai_key=sk-...`
- Internal URL on line 67: `https://internal.example.com`

**Cannot commit to public repo with sensitive data.**

Would you like me to:
1. Replace with placeholders (recommended)
2. Show me where to manually redact
3. Skip this ADR for now
```

**Block commit if sensitive data in public repo** (security risk)

---

## Step 3: Final Deduplication Check

**For each ADR being committed, search for similar ADRs one more time:**

```markdown
**Why check again?**
- Dedupe at write time: Prevents creating duplicate
- Dedupe at commit time: Catches duplicates from parallel work
```

**Search strategy:**
1. Extract keywords from ADR title + problem statement
2. Search ADR directory with `semantic_search()` or `grep_search()`
3. For each result with >70% similarity:
   - Read ADR
   - Compare decision/problem/solution

**If similar ADR found:**
```markdown
⚠️ **Similar ADR Detected**

**Your ADR:** `{path}`
- Decision: {summary}

**Existing ADR:** `{existing_path}`
- Decision: {summary}
- Status: {status}
- Similarity: {%}

**Options:**
1. **Update existing ADR** (add amendment) - Recommended if core decision same
2. **Mark existing as SUPERSEDED** - If your decision replaces old one
3. **Proceed with new ADR** (link as related) - If decisions are distinct
4. **Abort commit** - Reconsider if needed

What would you like to do? (1/2/3/4)
```

**Take action based on user choice** (may require file modifications)

---

## Step 4: Generate Commit Message

**Auto-generate commit message based on ADRs being committed:**

### Single ADR:
```
docs(adr): Add ADR for [decision title]

- Decision: [Brief summary from chosen option]
- Context: [Problem being solved]
- Impact: [HIGH/MEDIUM/LOW]

Related PRD: [link if exists]
```

### Multiple ADRs (same feature/phase):
```
docs(adr): Add N ADRs for [feature/phase name]

- [ADR 1 title] ([impact level])
- [ADR 2 title] ([impact level])
- [ADR 3 title] ([impact level])

Decisions document architectural choices made during [phase]
implementation.

Related PRD: [link if exists]
```

### Multiple ADRs (different contexts):
```
docs(adr): Add N ADRs across multiple features

- [ADR 1 title] - [feature 1] ([impact])
- [ADR 2 title] - [feature 2] ([impact])

Related: [links if exist]
```

### Amendment ADR:
```
docs(adr): Amend ADR for [decision title]

- Updated: [What changed]
- Reason: [Why amendment needed]
- Original decision: [Still valid / Superseded]
```

**Show to user:**
```markdown
## Proposed Commit Message

```
[Auto-generated message]
```

**Edit message? (Y/N)**
[If Y, show editable version]
```

---

## Step 5: Stage and Commit

**Stage ADR files:**
```bash
git add {file1} {file2} {file3}
```

**Commit with message:**
```bash
git commit -m "{finalized_message}"
```

**Verify success:**
```bash
git log -1 --oneline
```

**Report to user:**
```markdown
✅ **ADRs Committed Successfully**

**Commit:** `{hash}` - {summary line}

**Files committed:**
- {file1}
- {file2}
- {file3}

**Next steps:**
- Push to remote: `git push`
- Or continue working (will be pushed with next push)

**ADR locations:**
- View ADRs: `{adr_directory}`
- Search ADRs: `/adr-health` (check ADR catalog health)
```

---

## Step 6: Update ADR Index (Auto)

**After successful commit, automatically update ADR index:**

```markdown
Updating ADR index...
```

**Invoke `/adr-index` for each committed ADR:**

```bash
# For each committed ADR file
/adr-index {adr_file_path}
```

**Index update modes:**
- If `INDEX.md` exists → UPDATE mode (append entries)
- If `INDEX.md` missing → Prompt user to initialize

**Success:**
```markdown
✅ **Index Updated**

Added {N} entries to ADR index:
- {adr1_title} (Category: {category})
- {adr2_title} (Category: {category})

Index now has {total_count} ADRs.
```

**If index missing:**
```markdown
ℹ️ **ADR Index Not Found**

This repository doesn't have an ADR index yet.

**Create index now?** (Y/N)

[If Y] Running `/adr-index` to initialize...
[If N] Skipping index update. Run `/adr-index` manually later.
```

**Error handling:**
- If `/adr-index` fails, warn but don't block
- User can manually refresh index later

---

## Step 7: Post-Commit Checks (Optional)

**Suggest follow-up actions:**

```markdown
## Post-Commit Suggestions

**Documentation:**
- [ ] Update project README with ADR reference (if first ADR)
- [ ] Link from PRD to ADR (if PRD exists)
- [ ] Notify team (Slack/Discord/email if applicable)

**Maintenance:**
- [ ] Set reminder to review ADR in 6-12 months (lifecycle management)

**Run `/adr-health` to check overall ADR catalog health?** (Y/N)
```

---

## Error Handling

### Error: No uncommitted ADRs found
```markdown
ℹ️ **No Uncommitted ADRs**

All ADR files are already committed.

Would you like to:
1. Check for ADRs that need amendments
2. Run `/adr-health` to check catalog health
3. Nothing (exit)
```

### Error: Git not initialized
```markdown
❌ **Git Not Initialized**

This directory is not a git repository.

Would you like me to:
1. Initialize git (`git init`)
2. Skip git commit (just create files)
3. Abort
```

### Error: Conflicts during commit
```markdown
❌ **Git Conflict Detected**

Conflicts in:
- {file1}
- {file2}

**Resolution:**
1. Resolve conflicts manually
2. Run `/adr-commit` again after resolving
3. Or commit manually: `git add {files} && git commit`
```

### Error: Validation failures
```markdown
❌ **Cannot Commit - Validation Failures**

{X} ADRs failed validation:

1. {file1}:
   - {issue 1}
   - {issue 2}

2. {file2}:
   - {issue 1}

**Options:**
1. Fix issues now (run `/adr-writer` to update)
2. Skip failing ADRs (commit only valid ones)
3. Force commit anyway (not recommended)

What would you like to do? (1/2/3)
```

---

## Special Cases

### Case 1: Amending Recently Committed ADR

If user says "I just committed but need to update":

```markdown
**Amending Recent Commit**

Options:
1. **Amend commit** (if not pushed): `git commit --amend`
2. **New commit** (if already pushed): New commit with fix
3. **Amendment ADR** (if content needs addendum): Add amendment section

Which approach? (1/2/3)
```

### Case 2: Batch Commit Multiple Unrelated ADRs

If >3 ADRs from different contexts:

```markdown
**Large Batch Detected** ({N} ADRs)

Recommendation: Split into multiple commits by context/feature.

Groups detected:
1. Retry logic (3 ADRs)
2. Upload UX (2 ADRs)
3. Editor (1 ADR)

**Commit:**
- All together (1 commit)
- By group (3 commits)
- Individually ({N} commits)

Your preference? (all/group/individual)
```

### Case 3: First ADR in Repository

If this is first ADR:

```markdown
🎉 **First ADR in Repository!**

**Suggestions:**
1. Create `docs/ADR/README.md` (or `apps/{app}/docs/ADR/README.md`)
2. Add ADR documentation to project README
3. Set up ADR template for future contributors

Would you like me to create ADR README? (Y/N)
```

---

## Validation Reference

### Required Frontmatter:
```yaml
Date: YYYY-MM-DD
Status: PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED | AMENDED
Deciders: [Team or person name]
Related PRD: [Optional link]
Supersedes: [Optional link if status=SUPERSEDED]
```

### Required Sections (in order):
1. Title (# Level 1 heading)
2. Frontmatter block
3. Context and Problem Statement (## Level 2)
4. Decision Drivers (## Level 2, bulleted list)
5. Considered Options (## Level 2, bulleted list)
6. Decision Outcome (## Level 2, with Chosen + Rationale + Trade-offs subsections)
7. Consequences (## Level 2, with Positive + Negative + Neutral subsections)
8. Pros and Cons of Options (## Level 2, with ### Level 3 for each option)
9. More Information (## Level 2, with links)

### File Naming:
```
Pattern: YYYY-MM-DD-slug.md
Examples:
- 2026-01-10-dual-layer-retry-strategy.md
- 2026-01-07-tiptap-editor-component.md
- 2026-01-04-solid-queue-background-jobs.md

Invalid:
- dual-layer-retry.md (missing date)
- 2026-1-10-retry.md (month/day not zero-padded)
- 2026_01_10_retry.md (underscores, not hyphens)
```

---

## Remember

- **Validation is mandatory** (blocks commit if fails)
- **Deduplication is recommended** (warns but doesn't block)
- **Commit message is auto-generated** (but editable)
- **Batch commits are encouraged** (unless contexts differ)
- **Final check prevents regrets** (easier to fix before push)

---

**Ready to commit? Let's validate and finalize these ADRs!**
