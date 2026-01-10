---
description: ADR Health Check — Scan ADR catalog for stale, broken, or conflicting records
name: adr-health
---

# ADR Health Check

You scan the ADR catalog for health issues: stale decisions, broken links, conflicting ADRs, and lifecycle violations.

**Purpose:** Maintain ADR catalog quality over time

---

## Step 1: Determine Scope

**Ask user:**
```markdown
## ADR Health Check

**Scope options:**
1. **Full scan** - All ADRs in repository/monorepo
2. **App-specific** - Only ADRs for specific app (e.g., `apps/tala/docs/ADR/`)
3. **Recent** - Only ADRs from last N days (quick check)

**Which scope?** (1/2/3 or specify)
```

**Based on response:**
- Option 1: Scan `docs/ADR/` + all `apps/*/docs/ADR/` + all `packages/*/docs/ADR/`
- Option 2: Scan specified app directory
- Option 3: Filter by git log date

---

## Step 2: Load Health Check Criteria

**Read `adr-criteria.json` section: `lifecycle.health_checks`**

Key indicators:
- `staleness_indicators` - What makes ADR stale
- `review_triggers` - When to review ADR
- `actions` - What to do about issues

---

## Step 3: Scan ADRs

**For each ADR file in scope:**

### 3.1: Parse ADR Metadata

Read:
- Frontmatter (Date, Status, Supersedes link)
- Title
- Related PRD link
- Key files mentioned
- Framework/technology versions

### 3.2: Check for Staleness

**Staleness indicators from criteria.json:**

1. **Framework version outdated:**
   - Extract framework versions mentioned (e.g., "Rails 8.1", "React 18")
   - Check if >2 major versions behind current
   - Example: ADR mentions "Rails 6.0", current is "Rails 8.1" → STALE

2. **Referenced PRD deprecated:**
   - Check if PRD link exists
   - If PRD has status "DEPRECATED" or "COMPLETE" → STALE

3. **Implementation file missing:**
   - Check "Key Files" or "More Information" section
   - Verify files exist in repo
   - If >50% files missing → STALE

4. **Contradicting ADR without superseding:**
   - Search for ADRs about same decision
   - If multiple ADRs for same topic without explicit superseding links → CONFLICT

5. **Technology EOL/abandoned:**
   - Check for known EOL technologies (e.g., "jQuery", "AngularJS")
   - If mentioned → STALE

6. **Old without amendments:**
   - Check date (>2 years old)
   - Check status (ACCEPTED but no amendments)
   - Flag for review → STALE_REVIEW

### 3.3: Check for Broken Links

**Validate all links:**

- [ ] Related PRD exists
- [ ] Related ADRs exist
- [ ] Commits are valid
- [ ] Key files exist
- [ ] Supersedes link (if status=SUPERSEDED) is valid

**If broken:** Flag as BROKEN

### 3.4: Check Lifecycle Compliance

**Status validation:**

- `SUPERSEDED` → Must have "Supersedes:" link in frontmatter
- `AMENDED` → Must have amendment section
- `DEPRECATED` → Should have reason documented
- `PROPOSED` → Should be rare (most ADRs are post-implementation)

**If non-compliant:** Flag as LIFECYCLE_VIOLATION

---

## Step 4: Report Findings

**Organize results by severity:**

### Critical Issues (blocks ADR utility):
```markdown
## 🔴 Critical Issues ({count})

### Broken Links
1. **[apps/tala/docs/ADR/2026-01-03-rag-schema-design.md](path)**
   - PRD link 404: `prds/tala/mvp/20260103-rag-enhancements/01-schema.md`
   - Related ADR missing: `2026-01-02-rag-architecture.md`
   - **Action:** Fix links or mark as DEPRECATED

### Lifecycle Violations
2. **[apps/tala/docs/ADR/2024-12-15-tailwind-v3.md](path)**
   - Status: SUPERSEDED
   - Missing "Supersedes:" link in frontmatter
   - **Action:** Add superseding link or correct status

### Conflicts (duplicate decisions)
3. **[apps/tala/docs/ADR/2026-01-04-background-jobs.md](path)**
   vs **[apps/tala/docs/ADR/2025-12-20-job-architecture.md](path)**
   - Both document background job architecture
   - No superseding relationship defined
   - **Action:** Consolidate or link as related
```

### Warnings (needs review):
```markdown
## ⚠️ Warnings ({count})

### Stale Technology References
1. **[apps/tala/docs/ADR/2023-05-10-webpack-setup.md](path)**
   - Mentions: Webpack 4 (current: Webpack 5, but using Vite now)
   - Date: 2023-05-10 (2.5 years old)
   - **Action:** Review if still relevant, mark DEPRECATED if not

### Old ADRs Without Review
2. **[apps/tala/docs/ADR/2022-03-15-authentication-strategy.md](path)**
   - Date: 2022-03-15 (3.8 years old)
   - Status: ACCEPTED (no amendments)
   - **Action:** Review if still accurate, add amendment if changed
```

### Info (optional improvements):
```markdown
## ℹ️ Info ({count})

### Missing Optional Fields
1. **[apps/tala/docs/ADR/2026-01-10-retry-strategy.md](path)**
   - No "Related ADR" links (could link to error handling ADR)
   - No commit references (could add implementation commits)
   - **Action:** Optional - enhance documentation

### Recent ADRs (No Issues)
- {count} ADRs created in last 30 days - All healthy ✅
```

---

## Step 5: Suggest Actions

**For each category, provide actionable commands:**

```markdown
## Recommended Actions

### Critical Issues (Fix Now)

**Broken Links:**
```bash
# Fix PRD link in ADR
/adr-writer --update apps/tala/docs/ADR/2026-01-03-rag-schema-design.md
```

**Lifecycle Violations:**
```bash
# Add superseding link
/adr-writer --update apps/tala/docs/ADR/2024-12-15-tailwind-v3.md
```

**Conflicts:**
```bash
# Review for consolidation
# Option 1: Mark older as SUPERSEDED
# Option 2: Differentiate and link as related
```

### Warnings (Review Soon)

**Stale ADRs:**
```markdown
Review these ADRs:
1. [2023-05-10-webpack-setup.md](path) - Webpack → Vite migration
   - If still relevant: Add amendment
   - If outdated: Mark DEPRECATED

2. [2022-03-15-authentication-strategy.md](path) - 3.8 years old
   - Review current implementation
   - If unchanged: Add amendment confirming still valid
   - If changed: Update or supersede
```

### Automated Fixes Available

Would you like me to:
- [ ] Fix broken links automatically (where possible)
- [ ] Add missing superseding links (with confirmation)
- [ ] Mark old stale ADRs as DEPRECATED (with confirmation)

**Proceed with automated fixes?** (Y/N or select specific)
```

---

## Step 6: Execute Fixes (Optional)

**If user approves automated fixes:**

### Fix Type 1: Broken Links

```markdown
**Fixing broken links...**

1. ADR: 2026-01-03-rag-schema-design.md
   - PRD link updated: `01-schema.md` → `02-schema.md`
   - ✅ Fixed

2. ADR: 2025-11-20-context-memory.md
   - Related ADR link dead (file deleted)
   - ⚠️ Removed broken link
```

### Fix Type 2: Status Updates

```markdown
**Updating ADR statuses...**

1. ADR: 2024-12-15-tailwind-v3.md
   - Status: SUPERSEDED
   - Adding frontmatter: `Supersedes: 2024-12-25-tailwind-v4-theme-alignment.md`
   - ✅ Updated

2. ADR: 2023-05-10-webpack-setup.md
   - Marking as DEPRECATED
   - Reason: "Replaced by Vite (see 2024-06-10-vite-setup.md)"
   - ✅ Updated
```

### Fix Type 3: Consolidation

**For conflicting ADRs, suggest merge:**

```markdown
**Conflicting ADRs detected:**

Option 1: **Consolidate** (merge into one)
   - Keep: 2026-01-04-background-jobs.md (newer, more complete)
   - Merge content from: 2025-12-20-job-architecture.md
   - Mark old as SUPERSEDED

Option 2: **Differentiate** (clarify scope)
   - ADR 1: Background job architecture (infrastructure)
   - ADR 2: Job retry strategy (application-level)
   - Link as related, update titles to clarify

**Which approach?** (1/2 or custom)
```

---

## Step 7: Generate Health Report

**Summary statistics:**

```markdown
## ADR Catalog Health Report

**Scan Date:** {today}
**Scope:** {full/app-specific/recent}
**Total ADRs:** {count}

### Overall Health: {HEALTHY / WARNING / CRITICAL}

**Breakdown:**
- ✅ Healthy: {count} ({%})
- ⚠️ Warnings: {count} ({%})
- 🔴 Critical: {count} ({%})

### Issues by Category:
- Broken links: {count}
- Lifecycle violations: {count}
- Conflicts: {count}
- Stale technology: {count}
- Old without review: {count}

### Recommendations:
1. Fix {count} critical issues immediately
2. Review {count} stale ADRs within next sprint
3. Set quarterly ADR health check reminder

**Next check suggested:** {date 3 months from now}
```

**Save report?** (Y/N)
- If yes: Create `docs/ADR/HEALTH_REPORT_{date}.md`

---

## Special Cases

### Case 1: First Health Check Ever

```markdown
🎉 **First ADR Health Check!**

**Tips:**
- Run health check quarterly (every 3 months)
- Set calendar reminder
- Assign health check to team rotation

**Baseline established:**
- Total ADRs: {count}
- Issues found: {count}

Track improvement over time in future checks.
```

### Case 2: Zero Issues Found

```markdown
✅ **Perfect ADR Catalog Health!**

No issues detected. Great maintenance!

**Best practices observed:**
- All links valid
- No lifecycle violations
- Recent reviews documented
- No conflicts

Keep it up! 🎉
```

### Case 3: Too Many Issues

**If >20 issues:**

```markdown
⚠️ **Large Number of Issues Detected** ({count} issues)

**Recommended approach:**
1. **Triage:** Focus on critical issues first
2. **Batch fix:** Group similar issues
3. **Sprint allocation:** Dedicate time to ADR maintenance

**Priority order:**
1. Broken links (blocks findability)
2. Lifecycle violations (incorrect metadata)
3. Conflicts (duplicate decisions)
4. Stale reviews (long-term maintenance)

**Start with top {N} critical issues?** (Y/N)
```

---

## Automation Opportunities

**Suggest automation if patterns detected:**

```markdown
## Automation Opportunities

**Pattern detected:** Many ADRs missing commit references

**Suggestion:** Create git hook to remind about ADR updates
```bash
# .git/hooks/post-commit
echo "Remember to update related ADR if architecture changed"
```

**Pattern detected:** Old ADRs without review (>2 years)

**Suggestion:** Set up quarterly health check automation
- Add to CI/CD pipeline
- Create GitHub Action to run `/adr-health`
- Generate report as PR comment

**Interested in automation setup?** (Y/N)
```

---

## Remember

- **Health checks are preventive** (catch issues early)
- **Regular cadence is key** (quarterly recommended)
- **Fix critical first** (broken links, violations)
- **Review is ongoing** (ADRs are living documents)
- **Automation helps** (reduce manual burden)

---

**Ready to check ADR catalog health? Let's scan!**
