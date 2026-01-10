# Deprecated Agents

This directory contains deprecated agent definitions that have been replaced by improved implementations.

## adr-writer.agent.md.deprecated

**Deprecated:** 2026-01-10  
**Replaced By:** `adr.agent.md` + 4-prompt system  
**Reason:** Monolithic design (506 lines) violated single-responsibility principle

### What Was Wrong

The original `adr-writer.agent.md` tried to do everything in one agent:
- Assessment logic (should this be an ADR?)
- Routing logic (where should it go?)
- Deduplication checks
- Context gathering
- MADR formatting
- Validation
- Commit operations

**Total:** 506 lines of mixed concerns

### What Replaced It

**New ADR System** (inspired by Halo-Halo pattern catalog architecture):

**Agent:** `adr.agent.md` (~200 lines)
- Conversational orchestration wrapper
- Invokes specialized prompts
- Thin layer, no logic duplication

**Prompts:** `ubod-meta/prompts/adr/` (4 prompts, ~250 lines each)
- `/adr-gatekeeper` - Assessment, routing, deduplication
- `/adr-writer` - MADR format, context gathering
- `/adr-commit` - Validation, git operations
- `/adr-health` - Catalog maintenance

**Configuration:** `ubod-meta/prompts/adr/adr-criteria.json`
- Decision tree for threshold assessment
- Lifecycle states and transitions
- Routing rules for monorepo
- Impact level definitions

**Total:** ~1,200 lines, but separated by concern (single-responsibility)

### Why This Is Better

1. **Single-Responsibility** - Each prompt does ONE thing well
2. **Explicit Control** - Users can invoke prompts directly (skip agent)
3. **Testable** - Each prompt can be tested independently
4. **Maintainable** - Changes to routing don't affect validation logic
5. **Extensible** - Easy to add new prompts (e.g., adr-export, adr-search)
6. **Cross-Tool** - Prompts work across GitHub Copilot, Claude Code, etc.

### Migration Guide

**If you were using the old agent:**

```
# Old way (monolithic)
@adr-writer "Document retry logic decision"

# New way (orchestration)
@adr "Document retry logic decision"
```

The new agent (`@adr`) provides the same conversational interface but orchestrates specialized prompts internally.

**If you want explicit control:**

```
# Use prompts directly
/adr-gatekeeper       # Assess decision
/adr-writer          # Create ADR file
/adr-commit          # Validate & commit
```

### Key Improvements

**Old Agent:**
- ❌ Mixed concerns (assessment + writing + validation)
- ❌ Hard to test individual steps
- ❌ 506 lines of complexity
- ❌ Difficult to extend or modify
- ❌ Tool-specific features leaked into logic

**New System:**
- ✅ Single-responsibility prompts
- ✅ Each step independently testable
- ✅ ~250 lines per concern (digestible)
- ✅ Easy to extend (add new prompts)
- ✅ Tool-agnostic (works everywhere)
- ✅ Optional orchestration (agent) OR explicit control (prompts)

### Lessons Learned

**From Halo-Halo Pattern Catalog:**
- Keep prompts focused (~100-250 lines)
- Separate concerns cleanly
- Provide both orchestration AND explicit control
- Make each step useful on its own

**Applied to ADR System:**
- Assessment separate from writing
- Writing separate from validation
- Validation separate from commit
- Health checks as optional maintenance
- Agent as thin orchestration layer

### References

- **Design Discussion:** [conversation-summary-2026-01-10.md]
- **New Agent:** `templates/agents/adr.agent.md`
- **New Prompts:** `ubod-meta/prompts/adr/*.prompt.md`
- **Criteria:** `ubod-meta/prompts/adr/adr-criteria.json`
- **Inspiration:** Halo-Halo v0.2.0+ pattern catalog architecture

---

**Do not use this deprecated agent. Use `@adr` or the `/adr-*` prompts instead.**
