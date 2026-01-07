# Ubod Document Templates

**Purpose:** Universal document schemas and templates for AI coding agent workflows

**Last Updated:** 2026-01-07

---

## Contents

### Architecture Decision Records (ADRs)

**Purpose:** Document "why" architectural decisions were made, not just "what"

**Files:**
- **`ADR_SCHEMA.md`** - Canonical MADR-style template with all sections explained
- **`ADR_SCHEMA.json`** - JSON Schema for automated validation
- **`ADR_EXAMPLE.md`** - Complete example showing best practices

**When to Use:**
- After implementation is complete (not speculative)
- Architecture-level decisions (affects multiple components)
- Non-obvious trade-offs (future "why did we do this?" questions)
- Reversible but costly decisions (hard to change later)

**Why ADRs Matter:**
- **Prevents LLM assumption loops** - Documents "we tried X, rejected it because Y"
- **Captures constraints** - "Why not use gem Z?" → "Not in Gemfile, not worth adding"
- **Preserves rationale** - "Why HNSW over IVFFlat?" → "Dynamic data, 15x faster"
- **Builds institutional memory** - New LLM sessions read ADRs, avoid repeating mistakes

**Deployment:**
1. Copy `ADR_SCHEMA.md` to `{{PROJECT_ROOT}}/docs/ADR_SCHEMA.md`
2. Copy `ADR_SCHEMA.json` to `{{PROJECT_ROOT}}/docs/ADR_SCHEMA.json`
3. Copy `ADR_EXAMPLE.md` to `{{PROJECT_ROOT}}/docs/ADR_EXAMPLE.md` (optional reference)
4. Deploy ADR Writer agent from `templates/agents/adr-writer.agent.md`
5. Create first ADR using agent: `@adr-writer` (after implementation)

**Example ADR Title:**
```
2026-01-07-use-rubyllm-for-multi-provider-llm.md
```

**Structure:**
```markdown
# [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Accepted
**Deciders:** [Who decided]

## Context and Problem Statement
[What problem are we solving?]

## Decision Drivers
* [Priority 1]
* [Priority 2]

## Considered Options
* Option 1: [Title]
* Option 2: [Title]

## Decision Outcome
**Chosen:** [Option X]
**Rationale:** [Why this over others]
**Trade-offs:** [What we gave up vs gained]

## Consequences
### Positive
* [Good outcome 1]

### Negative
* [Challenge 1]

## Pros and Cons of the Options
[Detailed analysis of each option]

## More Information
* **PRD:** [Link]
* **Commits:** [SHAs]
```

---

## Future Templates

**Planned additions:**
- API documentation schemas
- Test strategy templates
- Migration runbook templates
- Incident retrospective templates

---

## Related Files

**Agent Templates:**
- `../agents/adr-writer.agent.md` - Universal ADR Writer agent

**Schema Documentation:**
- `../../ubod-meta/schemas/agent-schema.md` - Agent structure schema
- `../prd/PRD_SCHEMA.md` - PRD structure schema (if exists)

---

## Usage in Consuming Repos

**Monorepo structure:**
```
consuming-repo/
├── apps/
│   └── tala/
│       └── docs/
│           ├── ADR/
│           │   ├── ADR_SCHEMA.md
│           │   ├── ADR_SCHEMA.json
│           │   ├── ADR_EXAMPLE.md
│           │   └── YYYY-MM-DD-decision-title.md
│           └── ...
└── .github/
    └── agents/
        └── adr-writer.agent.md
```

**Single-app structure:**
```
consuming-repo/
├── docs/
│   ├── ADR/
│   │   ├── ADR_SCHEMA.md
│   │   ├── ADR_SCHEMA.json
│   │   ├── ADR_EXAMPLE.md
│   │   └── YYYY-MM-DD-decision-title.md
│   └── ...
└── .github/
    └── agents/
        └── adr-writer.agent.md
```

---

**Remember:** These are universal templates. Customize for your project's specific needs, but preserve the core structure for consistency.
