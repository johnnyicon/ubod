# ADR Schema (MADR-style)

**Purpose:** Canonical template for Architecture Decision Records

**Format:** MADR (Markdown Any Decision Records)

**Last Updated:** 2026-01-07

---

## Overview

This schema defines the structure for Architecture Decision Records (ADRs) across all projects using the ubod framework. ADRs document **why** architectural decisions were made, not just **what** was implemented.

**Key Principles:**
- ADRs are created **after** implementation (not speculative)
- ADRs capture alternatives considered (not just chosen option)
- ADRs document trade-offs explicitly
- ADRs link to implementation evidence (PRDs, commits)

---

## File Naming Convention

```
YYYY-MM-DD-short-title-kebab-case.md
```

**Rules:**
- Date first for chronological sorting
- Kebab-case for consistency
- Title should describe the decision (not the problem)
- Max ~60 characters for readability

**Examples:**
- ✅ `2026-01-07-use-rubyllm-for-multi-provider-llm.md`
- ✅ `2026-01-06-adopt-hnsw-indexing-for-vector-search.md`
- ✅ `2025-12-25-tailwind-v4-css-first-theming.md`
- ❌ `adr-1.md` (no context in filename)
- ❌ `implement-chat.md` (not a decision)
- ❌ `2026-01-07-bug-fix.md` (bug fixes aren't architectural decisions)

---

## ADR Structure

### Front Matter (Required)

```markdown
# [Short Title - Max 50 chars]

**Date:** YYYY-MM-DD
**Status:** [Proposed | Accepted | Superseded | Deprecated]
**Deciders:** [Name(s) or "Team Decision"]
**Related PRD:** [PRD-XX if applicable]
**Supersedes:** [Link to superseded ADR if applicable]
```

**Field Descriptions:**

- **Date:** Date decision was made (not when ADR was written, if different)
- **Status:** Current state of the decision (see Status Values below)
- **Deciders:** Who made the decision (individuals or "Team Decision")
- **Related PRD:** Link to PRD that describes the feature/requirement
- **Supersedes:** Link to older ADR if this decision replaces a previous one

---

### Body Sections (Required)

#### 1. Context and Problem Statement

**Purpose:** Explain what problem we're solving and why it matters

**Structure:**
```markdown
## Context and Problem Statement

[2-3 paragraphs describing:]
- What is the architectural issue we're facing?
- What constraints exist? (technical, business, team)
- Why does this decision matter?
- What happens if we don't make this decision?
```

**Tips:**
- Write for someone with no context (future you, new team members, LLMs)
- Focus on WHY this matters, not HOW it's implemented
- Include relevant background (what came before, what changed)

---

#### 2. Decision Drivers

**Purpose:** List priorities/constraints that influenced the decision

**Structure:**
```markdown
## Decision Drivers

* [Priority 1 - e.g., "Performance at scale (1M+ vectors)"]
* [Priority 2 - e.g., "Developer experience (fast iteration)"]
* [Priority 3 - e.g., "Cost optimization (cloud spend < $500/mo)"]
* [Priority 4 - e.g., "Maintenance burden (minimize dependencies)"]
```

**Tips:**
- Be specific (include numbers/thresholds where possible)
- Order by importance (most critical first)
- Include both technical and business drivers
- Mention constraints (budget, time, team size)

---

#### 3. Considered Options

**Purpose:** List all alternatives that were seriously considered

**Structure:**
```markdown
## Considered Options

* Option 1: [Title - e.g., "PostgreSQL pgvector with HNSW indexing"]
* Option 2: [Title - e.g., "Pinecone managed vector database"]
* Option 3: [Title - e.g., "Elasticsearch with dense_vector type"]
```

**Tips:**
- Include at least 2 options (shows alternatives were considered)
- Use descriptive titles (not just "Option A")
- List the option you chose (don't hide it)
- Include "do nothing" if that was an option

---

#### 4. Decision Outcome

**Purpose:** State what was chosen and why

**Structure:**
```markdown
## Decision Outcome

**Chosen:** [Option X with specific details]

**Rationale:** [2-3 sentences explaining why this option was selected over others]

**Key Trade-offs Accepted:**
* [Trade-off 1 - what we gave up vs what we gained]
* [Trade-off 2 - what we gave up vs what we gained]
```

**Tips:**
- Be explicit about what was chosen
- Explain WHY this over others (not just what)
- Acknowledge trade-offs honestly (every decision has them)
- Link back to Decision Drivers (which drivers influenced this)

---

#### 5. Consequences

**Purpose:** Document expected outcomes (good, bad, neutral)

**Structure:**
```markdown
## Consequences

### Positive

* [Good outcome 1 - e.g., "15x faster similarity search"]
* [Good outcome 2 - e.g., "No external dependencies"]

### Negative

* [Challenge 1 - e.g., "Need to manage indexing ourselves"]
* [Challenge 2 - e.g., "Limited to PostgreSQL features"]

### Neutral

* [Neither good nor bad 1 - e.g., "Requires PostgreSQL 16+"]
```

**Tips:**
- Be honest about negatives (helps future decision-making)
- Include measurable outcomes where possible
- Mention mitigation strategies for negatives
- Neutral = things that are different but not clearly better/worse

---

#### 6. Pros and Cons of the Options (Detailed)

**Purpose:** Document detailed analysis of each option

**Structure:**
```markdown
## Pros and Cons of the Options

### Option 1: [Title]

**Approach:** [One-line summary of how this works]

**Pros:**
* [Advantage 1 - specific benefit]
* [Advantage 2 - specific benefit]

**Cons:**
* [Disadvantage 1 - specific drawback]
* [Disadvantage 2 - specific drawback]

**Estimated Effort:** [Small | Medium | Large]

### Option 2: [Title]

[Repeat same structure]

### Option 3: [Title]

[Repeat same structure]
```

**Tips:**
- Include the option you chose (document why it's better)
- Be specific in pros/cons (avoid vague claims like "better performance")
- Include effort estimates (helps understand why simpler option chosen)
- Document any assumptions (e.g., "assumes team knows PostgreSQL")

---

### Optional Sections

#### Implementation Notes

**When to include:** Complex decisions with specific implementation requirements

```markdown
## Implementation Notes

**Key Files:**
* [path/to/file1.rb - what it does]
* [path/to/file2.js - what it does]

**Verification:**
```bash
# Command to verify this decision is working
cd apps/{{APP}} && bin/test test/models/example_test.rb
```

**Rollback Plan:** [If we need to reverse this decision, what's the path?]
```

---

#### More Information

**When to include:** Always (links to supporting materials)

```markdown
## More Information

* **PRD:** [Link to related PRD](../../prds/PRD_09_FEATURE.md)
* **Discussion:** [Link to GitHub issue/PR](https://github.com/org/repo/pull/123)
* **Commits:** [SHA1](https://github.com/org/repo/commit/abc123), [SHA2](https://github.com/org/repo/commit/def456)
* **External References:** [Blog post](https://example.com), [Documentation](https://docs.example.com)
```

**Tips:**
- Always link to PRD if one exists
- Include commit SHAs for implementation
- Link to any discussions (issues, PRs, Slack threads)
- Include external resources (blog posts, papers, docs)

---

#### Addendum (for updates)

**When to include:** Decision evolved after initial implementation

```markdown
## Addendum

### [Date] - [Update Title]

[What changed? Why? Does this supersede the original decision?]

**Impact:** [How does this change the original decision?]
**New Trade-offs:** [Any new trade-offs introduced?]
```

**Tips:**
- Use addendums for minor updates (not major reversals)
- For major reversals, create new ADR and mark this as "Superseded"
- Include date to track when understanding evolved
- Explain WHY the update was needed

---

## Status Values

| Status | Meaning | When to Use |
|--------|---------|-------------|
| `Proposed` | Under consideration, not yet decided | Pre-implementation (rare for ADRs) |
| `Accepted` | Decision implemented and in use | Post-implementation (most common) |
| `Superseded` | Replaced by a newer ADR | When new ADR reverses this decision |
| `Deprecated` | No longer recommended, but not yet replaced | Phasing out gradually |

**Status Workflow:**
```
Proposed → Accepted → [Superseded OR Deprecated]
```

**Tips:**
- Most ADRs should be "Accepted" (created post-implementation)
- When creating "Superseded" status, link to new ADR
- "Deprecated" is rare (usually just supersede)

---

## Cross-References

**Linking to other ADRs:**
```markdown
**Supersedes:** [ADR-2026-01-01-old-decision](./2026-01-01-old-decision.md)
**Superseded by:** [ADR-2026-01-10-new-decision](./2026-01-10-new-decision.md)
**Related:** [ADR-2026-01-05-related-decision](./2026-01-05-related-decision.md)
```

**Linking to PRDs:**
```markdown
**Related PRD:** [PRD-09: RubyLLM Integration](../../prds/PRD_09_RUBYLLM.md)
```

**Linking to code:**
```markdown
**Implementation:** See [DocumentIngestJob](../../app/jobs/document_ingest_job.rb)
```

---

## Examples

### Minimal Valid ADR

```markdown
# Use PostgreSQL HNSW for Vector Search

**Date:** 2026-01-07
**Status:** Accepted
**Deciders:** Engineering Team

## Context and Problem Statement

We need to perform similarity search on 1M+ document embeddings. Current linear scan is too slow (3+ seconds per query).

## Decision Drivers

* Query performance (target < 100ms)
* Cost (minimize external dependencies)
* Maintenance burden

## Considered Options

* PostgreSQL pgvector with HNSW
* Pinecone managed service

## Decision Outcome

**Chosen:** PostgreSQL pgvector with HNSW

**Rationale:** 15x faster than linear scan, no external dependency, fits within existing PostgreSQL infrastructure.

**Trade-offs:**
* Gained: Lower cost, better data locality
* Lost: Less specialized features than Pinecone

## Consequences

### Positive
* 15x faster similarity search
* No external dependencies

### Negative
* Need to manage indexing ourselves

## Pros and Cons of the Options

### PostgreSQL pgvector with HNSW
**Pros:**
* No external dependency
* Better data locality

**Cons:**
* Need to manage indexing
* Limited to PostgreSQL features

### Pinecone
**Pros:**
* Specialized vector database
* Managed service

**Cons:**
* External dependency
* Monthly cost: $70+
```

---

## Validation Checklist

Before committing ADR, verify:

- [ ] **Filename:** YYYY-MM-DD-title.md format
- [ ] **Title:** Clear, describes decision (not problem)
- [ ] **Date:** Set to decision date
- [ ] **Status:** Appropriate for state (usually "Accepted")
- [ ] **Context:** Explains WHY this matters
- [ ] **Drivers:** At least 2 decision drivers listed
- [ ] **Options:** At least 2 options documented
- [ ] **Outcome:** Explicitly states what was chosen
- [ ] **Rationale:** Explains WHY this option
- [ ] **Trade-offs:** Acknowledged (what we gave up)
- [ ] **Consequences:** Both positive and negative
- [ ] **Pros/Cons:** Detailed for each option
- [ ] **Links:** Working links to PRDs/commits

---

## Anti-Patterns (Avoid)

❌ **"Option A" vs "Option B"** (use descriptive names)
❌ **Only documenting chosen option** (need alternatives for context)
❌ **Vague pros/cons** ("better performance" without metrics)
❌ **No trade-offs** (every decision has trade-offs)
❌ **Implementation details** (focus on decision, not code)
❌ **No links to PRDs/commits** (ADR is orphaned)
❌ **Title is the problem** ("Fix slow queries" → "Use HNSW indexing")

---

## Tips for Writing Good ADRs

**Focus on WHY:**
- Why this decision mattered
- Why this option over others
- Why not the alternatives

**Be specific:**
- Include numbers (performance, cost, time)
- Link to evidence (benchmarks, discussions)
- Name specific technologies/patterns

**Think future:**
- Write for someone with zero context
- Document assumptions explicitly
- Include rollback plan if decision fails

**Keep it concise:**
- 1-2 pages max
- Use bullet points
- Link to details instead of embedding

---

## Related Files

- **ADR Agent:** `{{PROJECT_ROOT}}/.github/agents/adr-writer.agent.md`
- **JSON Schema:** `{{PROJECT_ROOT}}/docs/ADR_SCHEMA.json` (for validation)
- **Example ADR:** `{{PROJECT_ROOT}}/docs/ADR_EXAMPLE.md` (complete example)

---

**Remember:** ADRs are for future you. Write assuming zero context about why decisions were made.
