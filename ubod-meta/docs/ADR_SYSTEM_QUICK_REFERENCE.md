# ADR System Quick Reference

**Version:** 1.0.0  
**Last Updated:** 2026-01-10

---

## One-Line Summary

Document **why** decisions were made with MADR-format ADRs using specialized prompts or conversational agent.

---

## When to Use

**Post-Implementation:** After feature complete, tests pass, ready to document context

**Threshold Assessment:** Let `/adr-gatekeeper` assess if decision warrants ADR

**Batch Documentation:** Document multiple decisions from same sprint/phase

---

## Quick Commands

### Conversational Workflow

```
@adr "We just implemented [feature]"
```

Agent will:
1. Assess decisions against threshold criteria
2. Suggest which warrant ADRs
3. Create ADR files with your input
4. Validate and commit

### Explicit Control

```
/adr-gatekeeper      # Assess decision, check duplicates, route location
/adr-writer         # Create/update ADR file (MADR format)
/adr-commit         # Validate ADR, final dedupe, commit to git
/adr-health         # Scan catalog for stale/broken/conflicting ADRs
```

---

## Decision Criteria (Quick)

| Impact | Create ADR? | Examples |
|--------|-------------|----------|
| **HIGH** | ✅ YES | Multi-layer architecture, novel patterns, framework choice, data model design |
| **MEDIUM** | ✅ YES | Integration patterns, UX architecture, error handling strategy |
| **LOW** | ⚠️ MAYBE | Implementation details (only if non-obvious trade-offs) |
| **TRIVIAL** | ❌ NO | Coding style, variable names, formatting |

**Golden Rule:** If reversal would be costly or future devs/AI would struggle without context → create ADR

---

## MADR Format (Quick)

```markdown
---
status: accepted
date: 2026-01-10
decision-makers: [your-name]
---

# [Short Title in Imperative Mood]

## Context and Problem Statement

[What problem are we solving? What constraints exist?]

## Decision Drivers

* [Driver 1]
* [Driver 2]

## Considered Options

* [Option 1]
* [Option 2]

## Decision Outcome

Chosen option: "[Option X]", because [justification].

### Consequences

* Good: [Positive outcome]
* Bad: [Trade-off or downside]

## Validation

[How will we know this was the right decision?]

## Links

* [PRD](link to PRD)
* [Related ADR](link to related ADR)
```

---

## File Locations

### App-Specific ADRs

```
apps/{app-name}/docs/ADR/YYYY-MM-DD-decision-title.md
```

**When:** Decision affects only one app (Tala, nextjs-chat-app, etc.)

### Monorepo-Wide ADRs

```
docs/ADR/YYYY-MM-DD-decision-title.md
```

**When:** Decision affects infrastructure, shared tooling, or multiple apps

**Routing is automatic** - `/adr-gatekeeper` determines correct location

---

## Lifecycle States

| State | Meaning | Next States |
|-------|---------|-------------|
| `proposed` | Initial draft, not yet implemented | `accepted`, `rejected` |
| `accepted` | Implemented and in use | `deprecated`, `superseded` |
| `deprecated` | No longer recommended | - |
| `superseded` | Replaced by newer ADR | - |
| `rejected` | Decided against this approach | - |

**State transitions documented in frontmatter**

---

## Common Workflows

### Scenario 1: Post-Feature Documentation

```
You: @adr "We just finished document upload with retry logic"

Agent: I see 3 decisions:
       1. Dual-layer retry (client + job) - HIGH
       2. HTTP exception handling - MEDIUM
       3. Rate limit vs quota - LOW
       
       Create ADRs for #1 and #2?

You: Yes, and #3 too

Agent: [Creates 3 ADRs]
       Ready to commit?

You: Yes

Agent: ✅ Committed 3 ADRs (commit abc1234)
```

### Scenario 2: Quick Decision Check

```
You: /adr-gatekeeper
     Decision: "Use TypeScript for new service"
     
Prompt: [Assesses]
        ❌ LOW impact - Technology choice is obvious
        Recommendation: Document in README, not ADR
```

### Scenario 3: Update Existing ADR

```
You: /adr-writer
     Update: apps/tala/docs/ADR/2026-01-05-retry-strategy.md
     Change: "Added exponential backoff"

Prompt: [Adds amendment section to existing ADR]
        ✅ Updated with amendment
```

### Scenario 4: Health Check

```
You: /adr-health

Prompt: Scanning 47 ADRs...
        
        ⚠️ Warnings:
        - 2025-12-01-rag-pipeline.md (6 months old, review?)
        - 2025-11-15-auth-flow.md (broken PRD link)
        
        🔴 Critical:
        - Conflict: 2026-01-08-cache-strategy.md supersedes
          2025-09-10-cache-strategy.md but old one not marked
        
        Fix automatically?
```

---

## Tips for Writing Good ADRs

**DO:**
- ✅ Document alternatives considered (critical context!)
- ✅ Explain trade-offs accepted (why not other options?)
- ✅ Link to PRDs, commits, related ADRs
- ✅ Write for future readers (they don't have your context)
- ✅ Focus on **why**, not **what** (code shows what)

**DON'T:**
- ❌ Write before implementation (premature documentation)
- ❌ Document obvious choices (waste of time)
- ❌ Skip alternatives (future devs wonder "why not X?")
- ❌ Use vague language ("better", "cleaner" without specifics)

---

## Validation Rules

**ADRs must pass these checks before commit:**

- [ ] Valid YAML frontmatter (status, date, decision-makers)
- [ ] All required sections present (problem, options, decision, consequences)
- [ ] No empty sections (all sections have content)
- [ ] Links are valid (PRDs, related ADRs exist)
- [ ] Date format is YYYY-MM-DD
- [ ] Status is valid lifecycle state
- [ ] File naming: `YYYY-MM-DD-kebab-case-title.md`

**Validation runs at commit time** - blocks commit if fails

---

## Deduplication Strategy

**Check 1: Write Time** (`/adr-writer`)
- Semantic search for similar decisions
- Suggests updating existing ADR vs creating new

**Check 2: Commit Time** (`/adr-commit`)
- Final scan for duplicates
- Blocks commit if duplicate found
- Suggests merge or supersede

**Both checks required** - prevents duplicate ADRs

---

## Configuration

**Threshold Criteria:** `ubod-meta/prompts/adr/adr-criteria.json`

Defines:
- Impact level thresholds (HIGH/MEDIUM/LOW)
- Decision tree for assessment
- Routing rules (app vs root)
- Lifecycle state transitions
- Sanitization rules (if needed)

**Customization:** Edit criteria.json to adjust threshold for your team

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Should I create ADR for X?" | Use `/adr-gatekeeper` to assess against criteria |
| "Where should this ADR go?" | Gatekeeper auto-routes (app-specific vs root) |
| "Is this a duplicate?" | Deduplication runs twice (write + commit) |
| "ADR validation failed" | Check format against MADR schema, fix errors |
| "Lots of stale ADRs" | Run `/adr-health` to scan and fix |

---

## Related Documentation

- **MADR Spec:** https://adr.github.io/madr/
- **ADR Agent:** `templates/agents/adr.agent.md`
- **Prompts:** `ubod-meta/prompts/adr/*.prompt.md`
- **Criteria:** `ubod-meta/prompts/adr/adr-criteria.json`
- **Deprecation Notice:** `templates/agents/deprecated/DEPRECATION_NOTICE.md`

---

## Version History

- **1.0.0** (2026-01-10) - Initial 4-prompt system with orchestration agent
- Replaces monolithic `adr-writer.agent.md` (506 lines)

---

**Remember:** ADRs are living documents. Update when decisions evolve. Mark as superseded when replaced. Keep catalog healthy.
