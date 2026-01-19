# PRD Discovery Checklist

**PRD:** ubod Meta-Scaffolding Agents  
**Date:** 2026-01-19  
**Status:** Planning

---

## Discovery Findings

### Existing Patterns

**✅ ubod Spec Files (Verified):**
- `ubod-meta/instructions/vscode-custom-instructions-spec.instructions.md` (exists)
- `ubod-meta/instructions/vscode-custom-prompt-spec.instructions.md` (exists)
- `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md` (exists)
- `ubod-meta/instructions/github-custom-instructions-spec.instructions.md` (exists)
- `ubod-meta/instructions/github-custom-agent-spec.instructions.md` (exists)

**✅ ubod Templates (Verified):**
- `templates/instructions/` - Instruction templates
- `templates/prompts/` - Prompt templates
- `templates/agents/` - Agent templates (including prd-writer.agent.md)

**✅ Reference Implementations:**
- Tala design system (strategy doc) - Shows need for this feature
- Tala PRD schema - Demonstrates artifact validation patterns
- Existing ubod agents - Show agent definition patterns

### Similar Features

**✅ Existing Agent: prd-writer**
- Location: `templates/agents/prd-writer.agent.md`
- Purpose: Generate PRD files following ubod schema
- Pattern: Read schema → Ask questions → Generate artifact → Validate
- **Reusable pattern for our 3 agents**

**Key Insight:** prd-writer agent already implements the core workflow we need. Our 3 agents follow same pattern but for different artifact types.

---

## Architectural Decisions

### Decision 1: Spec Reading Strategy

**Chosen:** File-based reading (read spec .md files directly)

**Evidence:**
- All specs are stable markdown files in `ubod-meta/instructions/`
- Specs have clear frontmatter schema
- No need for complex parsing (standard YAML + markdown)

**Risk:** Spec file location or format changes
**Mitigation:** Version specs in frontmatter, agent checks version

### Decision 2: Validation Approach

**Chosen:** YAML parser + section structure validation

**Evidence:**
- Frontmatter is standard YAML
- Sections are markdown headers
- Both have robust parsers available

**Risk:** Malformed YAML or missing sections
**Mitigation:** Graceful error handling, suggest fixes

### Decision 3: Multi-Platform Support

**Chosen:** VS Code focus first, GitHub Copilot optional

**Evidence:**
- VS Code specs more mature
- GitHub specs follow similar pattern
- Easy to add GitHub support later

**Risk:** GitHub users need agents too
**Mitigation:** Phase 2 adds GitHub variant or unified agent

---

## Edge Cases Identified

### Edge Case 1: Optional Frontmatter Fields

**Scenario:** User skips optional fields (e.g., tags, priority)

**Solution:**
- Provide smart defaults
- Ask "Use default X?" instead of forcing input
- Allow empty for truly optional fields

### Edge Case 2: Invalid File Patterns

**Scenario:** User provides invalid glob pattern in applyTo

**Example:** `apps/tala/**.js` (missing middle *)

**Solution:**
- Validate glob syntax
- Suggest correction: "Did you mean `apps/tala/**/*.js`?"
- Don't write file until valid

### Edge Case 3: Spec Version Mismatch

**Scenario:** Spec updated, agent uses old version

**Solution:**
- Check spec version in frontmatter
- Warn if mismatch: "Spec is v2.1, agent expects v2.0"
- Suggest agent update

### Edge Case 4: User Provides Full Example

**Scenario:** User pastes full code example in question response

**Solution:**
- Detect code blocks (```...```)
- Format properly in generated artifact
- Preserve syntax highlighting language

---

## Open Questions

### Q1: Should agents support updating existing artifacts?

**Status:** Deferred to v2

**Rationale:**
- v1 complexity: medium (create from scratch)
- v2 complexity: high (parse existing, merge changes)
- MVP validates pattern first

### Q2: Should agents suggest improvements to specs?

**Status:** Out of scope

**Rationale:**
- Spec improvements are meta-meta-level
- Manual review better for spec evolution
- Agents should follow specs, not question them

### Q3: Should validation be strict or lenient?

**Decision:** Strict for required fields, lenient for optional

**Rationale:**
- Required fields must be present (spec compliance)
- Optional fields can be empty (user choice)
- Warnings for recommendations, errors for violations

### Q4: Should agents handle platform differences (VS Code vs GitHub)?

**Decision:** Phase 1 = VS Code only, Phase 2 = add GitHub

**Rationale:**
- VS Code specs more complete
- GitHub specs similar but have differences
- Start simple, expand once pattern proven

---

## Dependencies

### Internal (ubod)

✅ **Specs exist and are stable:**
- Last updated: ~2026-01
- Format: Frontmatter + markdown sections
- Location: `ubod-meta/instructions/`

✅ **Templates exist for reference:**
- Show expected artifact structure
- Can use as fallback examples

### External

**Required:**
- YAML parser (Ruby: `YAML`, Python: `yaml`)
- File system access (read specs, write artifacts)
- Markdown formatter (basic string manipulation)

**Optional:**
- Glob pattern validator (Ruby: `File.fnmatch`)
- Code syntax highlighter (for examples)

### Assumptions

1. Specs remain in current location
2. Spec format (frontmatter + sections) remains stable
3. Developers have ubod in workspace when using agents
4. File paths are relative to workspace root

---

## Technical Constraints

### Constraint 1: Agent Runs in AI Context

**Impact:** No UI for complex input (file uploads, forms)

**Workaround:** Conversational Q&A, accept multi-line text

### Constraint 2: Validation Must Be Deterministic

**Impact:** Can't rely on LLM to "judge" validity

**Workaround:** Use schema-based validation (YAML parsing, regex)

### Constraint 3: Artifact Generation Must Be Fast

**Impact:** User expects <30 second response

**Workaround:** Simple template substitution, no complex logic

---

## Testing Approach

### Validation Strategy

**Test against existing artifacts:**
1. Take existing instruction/prompt/agent file
2. Extract inputs (frontmatter values, sections)
3. Feed to agent
4. Compare generated vs original
5. **Target:** 90%+ match for core content

### Regression Prevention

**Spec change detection:**
1. Run agent with known inputs
2. Save generated output as baseline
3. On spec changes, regenerate and compare
4. Flag differences for review

### Coverage

**Per Agent:**
- Unit tests: 15-20 tests (parser, validator, generator)
- Integration tests: 5-8 tests (end-to-end workflows)
- Validation tests: 3-5 tests (against real artifacts)

**Total:** ~75-100 tests across 3 agents

---

## Implementation Order Rationale

### Why Sequential (01 → 02 → 03)?

1. **Pattern Establishment:** PRD-01 proves the core pattern
2. **Code Reuse:** PRD-02 reuses 70% of PRD-01 code
3. **Complexity Ramp:** PRD-03 is most complex, benefits from learnings

### Risk if Parallel:

- Duplicate code across agents
- Pattern discovered late requires 3x refactoring
- Testing overhead (3 agents in progress)

### Benefit of Sequential:

- PRD-01 → Extract reusable modules
- PRD-02 → Reuse modules, refine patterns
- PRD-03 → Reuse refined modules, add complexity

**Time Saved:** ~30% (24 hours → 17 hours with code reuse)

---

## Success Metrics Validation

### Time Reduction Claims

**Baseline (manual):**
- Instruction creation: 2 hours (verified from Tala experience)
- Prompt creation: 1.5 hours (verified from workflow docs)
- Agent creation: 3 hours (verified from agent authoring)

**Target (with agent):**
- Instruction: 20 minutes (83% faster)
- Prompt: 15 minutes (83% faster)
- Agent: 30 minutes (83% faster)

**Validation:** Time 3 developers creating artifacts manually vs with agent

### Quality Claims

**Baseline (manual):**
- ~70% spec compliance (based on PR reviews finding issues)

**Target (with agent):**
- 100% spec compliance (schema validation guarantees)

**Validation:** Run validator on 10 manual artifacts vs 10 generated artifacts

---

## Lessons from Similar Features

### From prd-writer.agent.md:

✅ **What worked:**
- Conversational Q&A for input collection
- Preview before writing file
- Schema-based validation

⚠️ **What to improve:**
- More granular questions (not monolithic)
- Better error messages (cite spec sections)
- Iterative refinement (not just yes/no approval)

### From Tala ViewComponent Experience:

✅ **What worked:**
- Instructions enforced conventions automatically
- Agents guided full workflows
- Validation caught issues early

⚠️ **What caused issues:**
- Missing instructions led to inconsistencies
- Manual artifact creation was slow/error-prone
- **Validated need for meta-scaffolding agents**

---

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-01-19 | Sequential implementation (01→02→03) | Maximize code reuse, reduce risk |
| 2026-01-19 | VS Code specs first, GitHub later | VS Code more mature, prove pattern first |
| 2026-01-19 | Strict validation for required fields | Ensure spec compliance |
| 2026-01-19 | Defer "update existing" to v2 | Reduce MVP complexity |

---

## Next Steps

1. ✅ PRD completed (this checklist)
2. ⏳ Begin PRD-01 implementation (instruction-writer)
3. ⏳ Extract reusable modules during PRD-01
4. ⏳ Apply learnings to PRD-02 (prompt-writer)
5. ⏳ Complete PRD-03 (agent-writer) with refined patterns

**Ready to proceed with implementation.**
