---
name: "ADR: Generate Index"
description: "Generate categorized index of ADRs for AI discoverability"
---

# ADR Index

You generate and maintain a categorized index of Architecture Decision Records (ADRs). You scan ADR files, extract metadata, categorize by domain, and produce a navigable index.

**Prerequisites:** ADR files exist in repository (typically `apps/{app}/docs/ADR/` or `docs/ADR/`)

---

## Step 1: Determine Mode

**Three operational modes:**

1. **INITIALIZE** - Create index from scratch (first-time setup)
   - Scan all existing ADR files
   - Extract metadata from each
   - Categorize by domain
   - Generate complete index file

2. **UPDATE** - Add single new ADR entry (called after commit)
   - Receive ADR file path from caller
   - Extract metadata from new ADR
   - Append to appropriate category in existing index
   - Update statistics

3. **REFRESH** - Rescan all ADRs and regenerate index (manual maintenance)
   - Scan all ADR files
   - Detect new ADRs, status changes, moved files
   - Regenerate entire index
   - Report changes detected

**User specifies mode via:**
- `/adr-index` alone → INITIALIZE (if no index) or REFRESH (if index exists)
- `/adr-index [file_path]` → UPDATE (add specific ADR)
- `/adr-index refresh` → REFRESH (force regeneration)

---

## Step 2: Locate ADR Directory

**Find ADR folder:**

```bash
# Check for monorepo structure
if [ -d "apps" ]; then
  # Ask user which app (if not provided)
  find apps/*/docs/ADR -type d 2>/dev/null
else
  # Single-repo structure
  find docs/ADR -type d 2>/dev/null
fi
```

**Determine index location:**
- Index lives in same folder as ADRs: `{adr_folder}/INDEX.md`
- Example: `apps/tala/docs/ADR/INDEX.md`

**If ADR folder not found**, ask user:
```markdown
❌ **ADR folder not found**

Expected locations:
- `apps/{app}/docs/ADR/` (monorepo)
- `docs/ADR/` (single-repo)

Please provide ADR folder path:
```

---

## Step 3: Extract Metadata from ADRs

**For each ADR file:**

1. **Parse filename** for date pattern:
   - `YYYY-MM-DD-title.md` → Extract date
   - `NNNN-title.md` (numeric prefix) → Use file mtime as date
   - `title.md` (no prefix) → Use file mtime as date

2. **Read frontmatter** (YAML between `---` delimiters):
   - `status:` → PROPOSED / ACCEPTED / REJECTED / DEPRECATED / SUPERSEDED / AMENDED
   - `date:` → Override filename date if present
   - `impact:` → HIGH / MEDIUM / LOW
   - `category:` → User-specified domain (optional)
   - `supersedes:` → Link to superseded ADR

3. **Extract title** from first H1 heading:
   - Look for `# Title` after frontmatter
   - Fallback: Use filename (kebab-case → Title Case)

4. **Determine category** (if not in frontmatter):
   - **RAG & AI:** Keywords: rag, retrieval, embedding, vector, llm, ai, prompt
   - **UI & Frontend:** Keywords: stimulus, turbo, viewcomponent, ui, css, frontend, portal, component
   - **Data & Models:** Keywords: model, schema, database, migration, versioning, multi-tenancy, org
   - **Infrastructure:** Keywords: deploy, test, job, queue, cache, retry, error, exception
   - **Uncategorized:** Fallback if no match

**Metadata structure:**
```json
{
  "filename": "2026-01-10-dual-layer-retry-strategy.md",
  "date": "2026-01-10",
  "status": "ACCEPTED",
  "title": "Adopt Dual-Layer Retry Strategy",
  "impact": "HIGH",
  "category": "Infrastructure",
  "supersedes": null
}
```

---

## Step 4: Generate Index Content

**Index structure:**

```markdown
# Architecture Decision Records - Index

**Last Updated:** {current_date}  
**Total ADRs:** {count}

---

## {Category 1} ({count})

| Date | Status | Title | Impact |
|------|--------|-------|--------|
| {date} | {status} | [{title}]({filename}) | {impact} |
| ... | ... | ... | ... |

---

## {Category 2} ({count})

[Same table structure]

---

## Quick Stats

**By Status:**
- ACCEPTED: {count} ({percentage}%)
- PROPOSED: {count} ({percentage}%)
- SUPERSEDED: {count} ({percentage}%)
- [etc.]

**By Impact:**
- HIGH: {count} ({percentage}%)
- MEDIUM: {count} ({percentage}%)
- LOW: {count} ({percentage}%)

**Most Recent:** {date} ({title})  
**Oldest:** {date} ({title})

---

## Index Maintenance

This index is auto-generated and updated by ubod's ADR system.

**To refresh manually:** `/adr-index refresh`  
**Auto-updated:** After each `/adr-commit`

**Index Generation:**
- Categories determined by keyword matching in title/content
- Sorted by date (newest first) within each category
- Status and impact extracted from ADR frontmatter
```

**Sorting rules:**
- Within category: Sort by date descending (newest first)
- Categories: Fixed order (RAG & AI, UI & Frontend, Data & Models, Infrastructure, Uncategorized)

---

## Step 5: Write Index File

**Mode-specific behavior:**

### INITIALIZE Mode:
```markdown
✅ **Index Created**

Location: `{adr_folder}/INDEX.md`

**Summary:**
- Total ADRs: {count}
- Categories: {category_count}
- Most recent: {date}

**Breakdown by category:**
- RAG & AI: {count}
- UI & Frontend: {count}
- Data & Models: {count}
- Infrastructure: {count}
- Uncategorized: {count}

Commit this index? (will be included in next `/adr-commit`)
```

### UPDATE Mode:
```markdown
✅ **Index Updated**

Added: `{filename}`
- Category: {category}
- Status: {status}
- Impact: {impact}

Index now has {new_count} ADRs (was {old_count})
```

### REFRESH Mode:
```markdown
✅ **Index Refreshed**

Scanned: {total_adrs} ADRs

**Changes detected:**
- New ADRs: {count} ({list})
- Status changes: {count} ({list})
- Moved/renamed: {count} ({list})

Index regenerated successfully.
```

---

## Step 6: Error Handling

**Common errors:**

### No ADRs Found:
```markdown
⚠️ **No ADRs Found**

Location checked: `{adr_folder}`

This could mean:
- ADRs not yet created (run `/adr-writer` to create first ADR)
- Wrong folder structure (check if ADRs are in different location)
- Empty ADR folder (create ADRs first)

Cannot generate index without ADRs.
```

### Malformed ADR:
```markdown
⚠️ **Malformed ADR Detected**

File: `{filename}`
Issue: {description}

Options:
1. Skip this ADR and continue (will be marked "⚠️ PARSE ERROR" in index)
2. Fix ADR manually and re-run
3. Abort indexing

What would you like to do?
```

### Index Already Exists (INITIALIZE):
```markdown
⚠️ **Index Already Exists**

Location: `{adr_folder}/INDEX.md`

Options:
1. **Refresh** - Regenerate index from scratch (overwrites existing)
2. **Update** - Append new ADRs to existing index
3. **Abort** - Keep existing index unchanged

What would you like to do?
```

---

## Step 7: Integration with Other Prompts

### Called by `/adr-commit`:

After successfully committing ADR(s), `/adr-commit` should invoke:

```
/adr-index {committed_adr_file_path}
```

This automatically adds the new ADR to index without user intervention.

### Called by ADR Agent:

User says: `@adr "Create index"` or `"Update ADR index"`

Agent invokes: `/adr-index` (INITIALIZE or REFRESH mode)

---

## Best Practices

**Categorization:**
- Use keyword matching on title + first 500 chars of content
- Allow manual override via frontmatter `category:` field
- Keep categories broad (4-5 max) to avoid fragmentation

**Metadata extraction:**
- Prioritize frontmatter over filename/content
- Use sensible defaults (status=ACCEPTED, impact=MEDIUM)
- Warn if critical fields missing

**Index maintenance:**
- Auto-update after commits (via integration)
- Provide manual refresh for drift correction
- Include "Last Updated" timestamp for staleness detection

**Performance:**
- For large repos (100+ ADRs), show progress during scan
- Cache metadata to avoid re-parsing unchanged files (future optimization)

---

## Example: INITIALIZE Mode

**User:** `/adr-index`

**Prompt:**
```markdown
Scanning ADRs in `apps/tala/docs/ADR/`...

Found 55 ADR files. Extracting metadata...

**Progress:**
- [20/55] Extracting metadata from 2026-01-10-dual-layer-retry-strategy.md...
- [40/55] Extracting metadata from 2025-12-20-use-hybrid-retrieval-keyword-vector-with-rrf.md...
- [55/55] Complete!

**Categorization:**
- RAG & AI: 15 ADRs
- UI & Frontend: 22 ADRs
- Data & Models: 12 ADRs
- Infrastructure: 6 ADRs

Generating index file...

✅ **Index Created**

Location: `apps/tala/docs/ADR/INDEX.md`

**Summary:**
- Total ADRs: 55
- Categories: 4
- Most recent: 2026-01-19 (Lookbook Naming Convention)

Commit this index?
```

---

## Example: UPDATE Mode

**Called by `/adr-commit` after committing:**

```markdown
✅ **ADR Committed:** 2026-01-20-context-priority-api.md

Updating index...

Extracted metadata:
- Title: "Context Priority Document API"
- Category: RAG & AI (detected from keywords: "rag", "retrieval", "document")
- Status: ACCEPTED
- Impact: HIGH

✅ **Index Updated**

Added entry to "RAG & AI" section.
Index now has 56 ADRs (was 55).
```

---

## Example: REFRESH Mode

**User:** `/adr-index refresh`

**Prompt:**
```markdown
Scanning all ADRs in `apps/tala/docs/ADR/`...

Found 58 ADR files (index showed 55 → 3 new files detected)

**Changes detected:**
- **New ADRs:**
  - 2026-01-20-context-priority-api.md
  - 2026-01-20-scope-resolver-refactor.md
  - 2026-01-21-unified-embedding-pipeline.md

- **Status changes:**
  - 2026-01-07-tiptap-editor-component.md: ACCEPTED → AMENDED

- **No moves/renames detected**

Regenerating index with 58 ADRs...

✅ **Index Refreshed**

Previous: 55 ADRs, 4 categories
Current: 58 ADRs, 4 categories

Diff: +3 new, 1 status change

Would you like to review the updated index before committing?
```

---

## Advanced: Custom Categories

**If user wants custom categorization**, they can add to ADR frontmatter:

```yaml
---
status: ACCEPTED
date: 2026-01-20
impact: HIGH
category: Security & Auth  # Custom override
---
```

Index will respect this and create "Security & Auth" section.

**To force specific categorization across all ADRs**, user can provide mapping file:

`{adr_folder}/.adr-index-config.json`:
```json
{
  "categories": {
    "RAG & AI": ["rag", "retrieval", "vector", "embedding", "llm"],
    "UI & Frontend": ["ui", "component", "stimulus", "turbo", "css"],
    "Data & Models": ["model", "schema", "database", "migration"],
    "Infrastructure": ["deploy", "test", "job", "queue", "cache"],
    "Security": ["auth", "security", "permission", "encryption"]
  }
}
```

Prompt will read this config and use custom categories/keywords.

---

**Remember:** Index is auto-maintained but user can always refresh manually if drift occurs.
