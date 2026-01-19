---
title: "ubod Meta-Scaffolding Agents"
project: ubod
type: feature
complexity: complex
estimated_hours: 24-32
priority: high
status: planning
created: 2026-01-19
updated: 2026-01-19
tags: [meta-tooling, agents, scaffolding, DX]
---

# ubod Meta-Scaffolding Agents - Master Index

**Executive Summary:** Create three meta-level agents that use ubod's own specifications to generate instructions, prompts, and agent definition files. These agents reduce artifact creation time by ~80% and ensure 100% spec compliance.

**Problem:** Currently, creating ubod artifacts (instructions/prompts/agents) requires manually reading specs, structuring frontmatter, and validating against schema. This is tedious, error-prone, and doesn't scale as ubod evolves.

**Solution:** Build agents that READ ubod specs and GENERATE spec-compliant artifacts through guided workflows.

---

## Sub-PRDs

This PRD is divided into 3 implementation units:

| PRD | Title | Est. Hours | Dependencies | Status |
|-----|-------|------------|--------------|--------|
| [01](01_instruction_writer.md) | Instruction Writer Agent | 8-10h | None | Planning |
| [02](02_prompt_writer.md) | Prompt Writer Agent | 8-10h | PRD-01 (pattern) | Planning |
| [03](03_agent_writer.md) | Agent Writer Agent | 8-12h | PRD-01, PRD-02 (pattern) | Planning |

**Total Estimated Time:** 24-32 hours

**Implementation Order:** Sequential (PRD-01 → PRD-02 → PRD-03) to reuse patterns

---

## Architecture Overview

### High-Level Flow

```
Developer invokes agent
        ↓
Agent reads ubod spec
        ↓
Agent asks targeted questions
        ↓
Agent generates artifact
        ↓
Agent validates against spec
        ↓
Developer reviews & approves
```

### Shared Components

All three agents share:

1. **Spec Reader Module**
   - Reads `.instructions.md` spec files
   - Extracts frontmatter schema
   - Identifies required/optional fields
   - Parses section structure

2. **Question Generator**
   - Based on spec, asks domain-specific questions
   - Example: "What file patterns should this instruction apply to?"
   - Collects user input to populate artifact

3. **Artifact Generator**
   - Uses spec as template
   - Populates with user responses
   - Generates valid frontmatter
   - Structures sections per spec

4. **Validator**
   - Checks frontmatter completeness
   - Verifies section structure
   - Validates against spec rules
   - Reports violations

### Agent Differentiation

| Agent | Spec Used | Output | Domain Questions |
|-------|-----------|--------|------------------|
| instruction-writer | `vscode-custom-instructions-spec.instructions.md` | `.instructions.md` | What to enforce? Which files? |
| prompt-writer | `vscode-custom-prompt-spec.instructions.md` | `.prompt.md` | Workflow steps? Success criteria? |
| agent-writer | `vscode-custom-agent-spec.instructions.md` | `.agent.md` | Agent expertise? Workflow? Boundaries? |

---

## Success Criteria

### Functional Requirements

**All Agents Must:**
- ✅ Read and parse ubod spec files
- ✅ Generate spec-compliant artifacts
- ✅ Ask targeted domain questions
- ✅ Validate generated artifacts
- ✅ Handle edge cases (optional fields, examples, etc.)

**Quality Gates:**
- ✅ Generated artifacts pass schema validation
- ✅ Zero manual fixes needed after generation
- ✅ Agent explains decisions/recommendations
- ✅ Agent cites spec sections in output

### Performance Targets

| Metric | Without Agent | With Agent | Improvement |
|--------|---------------|------------|-------------|
| Time to create instruction | 2 hours | 20 minutes | 83% faster |
| Time to create prompt | 1.5 hours | 15 minutes | 83% faster |
| Time to create agent | 3 hours | 30 minutes | 83% faster |
| Spec compliance rate | ~70% | 100% | +30 points |

### User Experience

**Developer workflow:**
1. Invoke: `@ubod-instruction-writer "Create Tala design system instructions"`
2. Answer 5-8 targeted questions
3. Review generated artifact
4. Approve or request changes
5. File created, ready to use

**Time investment:** 15-30 minutes vs 1-3 hours manual

---

## Technical Decisions

### Decision 1: Spec Reading Strategy

**Chosen:** Static file reading + parsing

**Alternatives Considered:**
- Dynamic spec generation (too complex)
- Hardcoded schemas (not maintainable)

**Rationale:** Specs are stable markdown files, simple file reading works.

### Decision 2: Validation Approach

**Chosen:** Schema-based validation (parse frontmatter YAML, check structure)

**Alternatives Considered:**
- Regex-based (too fragile)
- LLM-based (expensive, non-deterministic)

**Rationale:** Frontmatter is YAML, standard parsers exist.

### Decision 3: Question Flow

**Chosen:** Sequential Q&A (one question at a time)

**Alternatives Considered:**
- Single prompt with all questions (overwhelming)
- Form-based input (requires UI)

**Rationale:** Conversational flow matches AI agent interaction model.

### Decision 4: Agent Scope

**Chosen:** Three separate agents (instruction/prompt/agent)

**Alternatives Considered:**
- One universal "artifact writer" agent
- Five agents (add skill/template writers)

**Rationale:** Three core artifact types, separating keeps each agent focused.

---

## Dependencies

### Internal (ubod)

- ✅ `ubod-meta/instructions/vscode-custom-instructions-spec.instructions.md` (exists)
- ✅ `ubod-meta/instructions/vscode-custom-prompt-spec.instructions.md` (exists)
- ✅ `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md` (exists)

### External

- YAML parser (for frontmatter validation)
- Markdown parser (for section structure)
- File system access (read specs, write artifacts)

### Assumptions

- Specs remain in current location (`ubod-meta/instructions/`)
- Spec format is stable (frontmatter + markdown sections)
- Developers have ubod specs in their workspace

---

## Risks & Mitigations

### Risk 1: Spec Changes Break Agents

**Impact:** High (agents generate invalid artifacts)

**Probability:** Medium (specs evolve over time)

**Mitigation:**
- Version specs in frontmatter: `spec_version: 2.1.0`
- Agents check spec version, warn if outdated
- Update agents when specs change (maintenance cost)

### Risk 2: Generated Artifacts Don't Match User Intent

**Impact:** Medium (manual fixes needed)

**Probability:** Medium (LLM misunderstands questions)

**Mitigation:**
- Show preview before writing file
- Allow iterative refinement ("Change X to Y")
- Provide examples in questions

### Risk 3: Agent Complexity Grows Over Time

**Impact:** Low (maintenance burden)

**Probability:** High (edge cases accumulate)

**Mitigation:**
- Keep agents focused (single artifact type)
- Document edge cases in agent code
- Provide escape hatch ("manual mode")

---

## Testing Strategy

See [TESTING_STRATEGY.md](TESTING_STRATEGY.md) for detailed test plans.

**High-Level Approach:**

1. **Unit Tests:** Spec parser, validator, question generator
2. **Integration Tests:** End-to-end agent workflows
3. **Validation Tests:** Generated artifacts pass schema checks
4. **Regression Tests:** Existing ubod artifacts re-generated match originals

**Test Coverage Target:** 80%+ for core modules

---

## Rollout Plan

### Phase 1: Build (Week 1-2)

- Week 1: Build instruction-writer agent + tests
- Week 2: Build prompt-writer agent (reuse patterns) + tests

**Milestone:** 2 agents working, tested against existing artifacts

### Phase 2: Complete & Dogfood (Week 2-3)

- Week 2-3: Build agent-writer agent + tests
- Week 3: Use agents to regenerate existing ubod artifacts
- Week 3: Document any spec violations discovered

**Milestone:** 3 agents complete, validated against real artifacts

### Phase 3: Integrate & Document (Week 3-4)

- Week 3: Integrate agents into ubod workflow documentation
- Week 4: Create tutorial: "Using Meta-Agents to Extend ubod"
- Week 4: Extract learnings for ubod best practices

**Milestone:** Agents documented, tutorial published, ready for external use

---

## Success Metrics

### Adoption Metrics

- **Target:** 80% of new ubod artifacts created via agents (vs manual)
- **Measure:** Track agent invocations vs manual artifact creation

### Quality Metrics

- **Target:** 100% spec compliance for agent-generated artifacts
- **Measure:** Run schema validation on generated files

### Efficiency Metrics

- **Target:** 80% time reduction (2 hours → 20 minutes)
- **Measure:** Self-reported time tracking

### Satisfaction Metrics

- **Target:** 4/5+ satisfaction rating from ubod contributors
- **Measure:** Survey after 1 month of agent use

---

## Future Enhancements

**Post-MVP Ideas:**

1. **Bulk Operations**
   - Update all instructions when spec changes
   - Migrate artifacts to new spec version

2. **Template Support**
   - Generate artifacts from templates
   - "Create Rails ViewComponent instructions like Tala's"

3. **Cross-Agent Workflows**
   - "Create agent + instructions + prompt for X domain"
   - Single workflow generates multiple artifacts

4. **Spec Evolution**
   - Agent suggests spec improvements based on usage patterns
   - "90% of instructions use this field, should it be required?"

---

## Related Documentation

- **Strategy:** `apps/tala/docs/design-system-governance-strategy.md`
- **Specs:** `ubod-meta/instructions/vscode-custom-*.instructions.md`
- **Discovery Checklist:** [PRD_DISCOVERY_CHECKLIST.md](PRD_DISCOVERY_CHECKLIST.md)
- **Testing Strategy:** [TESTING_STRATEGY.md](TESTING_STRATEGY.md)

---

## Questions & Decisions Log

*This section will be populated during implementation*

**Open Questions:**
- Should agents support GitHub Copilot specs in addition to VS Code?
- Should validation be strict (fail) or lenient (warn)?

**Decisions Made:**
- [TBD during implementation]

---

**Status:** Planning  
**Next Step:** Begin PRD-01 (Instruction Writer Agent) implementation
