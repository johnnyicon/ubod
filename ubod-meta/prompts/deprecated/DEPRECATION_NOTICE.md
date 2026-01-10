# Deprecated Ubod Prompts

This directory contains deprecated prompt definitions that have been replaced by improved implementations.

## ubod-checkin.prompt.md.deprecated

**Deprecated:** 2026-01-10  
**Replaced By:** `ubod-checkin.agent.md` + 4-prompt system  
**Reason:** Monolithic design (258 lines) violated single-responsibility principle

### What Was Wrong

The original `/ubod-checkin` prompt tried to do everything in one prompt:
- Version calculation and CHANGELOG updates
- Migration file creation
- Validation checks (sanitization, schemas, etc.)
- Git staging, commit message generation
- Push to origin
- Consumer deployment orchestration

**Total:** 258 lines of mixed concerns

### What Replaced It

**New Ubod Checkin System** (inspired by Halo-Halo + ADR system architecture):

**Agent:** `ubod-meta/agents/ubod-checkin.agent.md` (~350 lines)
- Conversational orchestration wrapper
- Invokes specialized prompts
- Thin layer, no logic duplication
- Provides guided workflow with gates

**Prompts:** `ubod-meta/prompts/ubod-*.prompt.md` (4 prompts)
- `/ubod-version-bump` (~350 lines) - Version calculation, CHANGELOG updates
- `/ubod-migration-create` (~400 lines) - Migration file creation and validation
- `/ubod-validate` (~350 lines) - All validation checks (sanitization, schema, etc.)
- `/ubod-commit` (~400 lines) - Git staging, commit, push, consumer invocation
- `/ubod-upgrade` (existing) - Consumer repo deployment

**Total:** ~1,850 lines, but separated by concern (single-responsibility)

### Why This Is Better

1. **Single-Responsibility** - Each prompt does ONE thing well
2. **Explicit Control** - Users can invoke prompts directly (skip agent)
3. **Testable** - Each prompt can be tested independently
4. **Maintainable** - Changes to validation don't affect commit logic
5. **Extensible** - Easy to add new steps (e.g., ubod-test, ubod-rollback)
6. **Cross-Tool** - Prompts work across GitHub Copilot, Claude Code, etc.
7. **Complexity Handling** - Each prompt handles Ubod's unique complexity (template updates, not just copies)

### Migration Guide

**If you were using the old prompt:**

```
# Old way (monolithic)
/ubod-checkin

# New way (orchestration)
@ubod-checkin
```

The new agent (`@ubod-checkin`) provides the same workflow but orchestrates specialized prompts internally.

**If you want explicit control:**

```
# Use prompts directly
/ubod-version-bump      # Calculate version, update CHANGELOG
/ubod-migration-create  # Create migration if breaking
/ubod-validate          # Run all validation checks
/ubod-commit            # Stage, commit, push
/ubod-upgrade           # Deploy to consumer (already existed)
```

### Key Improvements

**Old Prompt:**
- ❌ Mixed concerns (version + migration + validation + commit)
- ❌ Hard to test individual steps
- ❌ 258 lines of embedded logic
- ❌ Difficult to extend or modify
- ❌ Validation logic intertwined with commit logic

**New System:**
- ✅ Single-responsibility prompts
- ✅ Each step independently testable
- ✅ ~350-400 lines per concern (digestible)
- ✅ Easy to extend (add new prompts)
- ✅ Validation separate from commit
- ✅ Optional orchestration (agent) OR explicit control (prompts)
- ✅ Handles Ubod's complexity (template updates, not just copies)

### Lessons Learned

**From Halo-Halo Pattern Catalog:**
- Keep prompts focused (~100-400 lines depending on complexity)
- Separate concerns cleanly
- Provide both orchestration AND explicit control
- Make each step useful on its own

**From ADR System Redesign:**
- 4-prompt architecture works well for complex workflows
- Orchestration agent provides conversational interface
- Prompts handle domain complexity
- Users appreciate choice (agent vs prompts)

**Applied to Ubod Checkin:**
- Version bump separate from migration
- Migration separate from validation
- Validation separate from commit
- Commit separate from consumer deployment
- Agent as thin orchestration layer

### Differences from Halo/ADR

**Halo-Halo:**
- Copies static templates to consuming repos
- No file updates, just new files
- Simpler workflow (pattern → validate → commit)

**ADR System:**
- Creates new ADR files
- Updates existing ADRs (amendments)
- Moderate complexity

**Ubod System:**
- Updates existing templates in consumer repos
- Handles submodule pointer updates
- Manages migrations for breaking changes
- Most complex of the three
- Needs robust validation (schema, sanitization, structure)

**Key Insight:** Prompts absorb domain complexity, agent stays thin.

### References

- **Design Discussion:** [conversation-summary-2026-01-10.md]
- **New Agent:** `ubod-meta/agents/ubod-checkin.agent.md`
- **New Prompts:** `ubod-meta/prompts/ubod-*.prompt.md`
- **Inspiration:** Halo-Halo v0.2.0+ pattern catalog + ADR system architecture

---

**Do not use this deprecated prompt. Use `@ubod-checkin` or the `/ubod-*` prompts instead.**
