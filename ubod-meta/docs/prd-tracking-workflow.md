# PRD Tracking Workflow (Hybrid Approach)

**Status:** Recommended Pattern
**Source:** [Research: PRD Tracking Strategy](../research/prd-tracking-strategy/README.md)

---

## Overview

Use **local Markdown files** for active PRD work + **GitHub Issues** for deferred items.

This balances AI agent latency (0ms local access) with tracking (GitHub reminders for P2/P3 items).

---

## Workflow

### Phase 1: Active Development

1. **Create PRD from template** (`templates/prds/PRD_TEMPLATE.md`)
   - Add YAML frontmatter with metadata
   - Structure with phases (00_master, 01_phase, etc.)
   - Keep all context in Markdown (diagrams, code, architecture)

2. **AI agents read directly** from local files
   - Zero latency (no API calls)
   - Full context available (including code blocks, tables)
   - Works offline

3. **Update status as you go**
   - Mark phases ✅ DONE or ⏸️ DEFERRED
   - Document what shipped vs. what didn't
   - Capture learnings and decisions

### Phase 2: Archiving (When PRD Complete)

1. **Extract deferred items to GitHub Issues**
   
   For each P2/P3 feature marked ⏸️ DEFERRED:
   
   ```markdown
   Title: [Feature Name] (P2/P3 from First-Class Documents PRD)
   
   ## Context
   Originally scoped in: prds/{{APP_NAME}}/mvp/{{PRD_FOLDER}}/
   Priority: P2 (or P3)
   Deferred because: [reason]
   
   ## Description
   [Copy from PRD]
   
   ## Acceptance Criteria
   [Copy from PRD]
   
   ## Links
   - PRD: [Link to GitHub]
   - Related Issues: [Any dependencies]
   ```

2. **Update PRD with Issue links**
   
   In deferred section, add:
   ```markdown
   ## P2 - Deferred
   
   ### Feature Name (GitHub Issue #123)
   [Brief summary]
   → Tracked in: https://github.com/org/repo/issues/123
   ```

3. **Update YAML frontmatter**
   ```yaml
   ---
   status: archived
   archived_date: 2026-01-10
   deferred_issues:
     - 123
     - 124
   ---
   ```

### Phase 3: Revisiting Deferred Work

1. **Review GitHub Issues** for P2/P3 items
2. **Link back to PRD** for full context
3. **Create new PRD if scope grows** (don't reopen archived PRDs)

---

## YAML Frontmatter (Required)

Add to top of every PRD:

```yaml
---
title: {{Feature Name}}
app: {{tala|nextjs-chat|rails-inertia}}
status: {{active|archived|deferred}}
priority: {{P0|P1|P2|P3}}
created_date: YYYY-MM-DD
target_date: YYYY-MM-DD
archived_date: YYYY-MM-DD  # when archived
deferred_issues: []  # GitHub issue numbers
tags: [{{mvp}}, {{rag}}, {{ui}}, ...]
---
```

### Status Values

- `active` - Currently being worked on
- `archived` - Implementation complete (shipped or explicitly cancelled)
- `deferred` - Entire PRD postponed

---

## Filtering PRDs

With YAML frontmatter, you can filter:

```bash
# Find all active PRDs
grep -l "status: active" prds/**/*.md

# Find all deferred P2 items
grep -l "priority: P2" prds/**/*.md | xargs grep "status: deferred"

# Find PRDs with GitHub Issues
grep -l "deferred_issues:" prds/**/*.md
```

Or use AI agent:

```
"Show me all active P1 PRDs for the Tala app"
```

---

## Why This Workflow?

**✅ Benefits:**
- **Fast AI access** - 0ms latency for agent reads
- **Rich context** - Markdown supports diagrams, code, tables
- **Version control** - Full git history for PRDs
- **Tracking** - GitHub Issues prevent loss of deferred items
- **Searchable** - YAML frontmatter enables filtering
- **Works offline** - No API dependencies during active work

**⚠️ Trade-offs:**
- Manual extraction to GitHub Issues (one-time cost when archiving)
- Two sources of truth (but clearly separated: active = local, deferred = Issues)

---

## Migration Guide

For existing PRDs without frontmatter:

1. Add YAML frontmatter to top of file
2. Set `status: archived` if complete
3. Extract any P2/P3 items to GitHub Issues
4. Link issues back in PRD's deferred section

---

## Examples

See:
- `templates/prds/PRD_TEMPLATE.md` - Template with frontmatter
- Consumer repo: `prds/tala/mvp/20260106_first_class_documents/` - Example archived PRD

---

## Research Background

This workflow came from research analyzing 3 options across 10 evaluation criteria, validated by 3 independent LLMs (ChatGPT 5.2, Claude Opus 4.5, Gemini 3 Pro). All converged on this hybrid approach with 85-90% confidence.

See: [PRD Tracking Strategy Research](../research/prd-tracking-strategy/README.md)
