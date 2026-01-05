# PRD Templates

**Purpose:** Product Requirements Document templates for consuming apps to create feature specifications.

---

## Contents

### `prd-template.md`

A comprehensive PRD template that enforces:
- **Discovery Phase first** - Verify assumptions before writing specs
- **Exact specifications** - No ambiguous language, exact code snippets
- **Remote actions checklist** - Catches frontend/backend mismatches
- **Comprehensive test plan** - Unit, integration, system, accessibility, telemetry
- **Staged rollout** - Feature flags, monitoring, rollback plan

---

## Usage

### 1. Copy Template to Your PRD Location

```bash
# From your monorepo root
cp projects/ubod/templates/prd/prd-template.md prds/[app]/[feature]/PRD_01_feature_name.md
```

### 2. Complete Discovery Phase FIRST

**Do not skip this.** The Discovery Phase (at the end of the template) requires you to:
- Search for similar features in codebase
- Check existing models, services, and patterns
- Document exact findings (not assumptions)

### 3. Fill In Specifications

Use findings from Discovery to write EXACT specifications:
- Exact error messages (not "appropriate error message")
- Exact validation order (not "validate inputs")
- Exact code snippets (not descriptions)

### 4. Review and Enhance

Pass the draft through a second review (can use a different LLM or human) focusing on:
- Edge cases
- Framework gotchas
- Accessibility
- Test coverage gaps

---

## Customization

The template is framework-agnostic. Customize for your stack by:

1. **Framework-Specific Gotchas section** - Add your tech stack's common pitfalls
2. **Test Plan section** - Add your specific testing tools and commands
3. **Telemetry section** - Add your specific logging/metrics patterns

---

## Related Agents

Use these agents in combination with PRD workflow:

| Agent | When to Use |
|-------|-------------|
| `discovery-planner.agent.md` | Before writing PRD - evidence-first discovery |
| `ui-ux-designer.agent.md` | When specifying frontend/UX - approach design |
| `verifier.agent.md` | After implementation - verify beyond "tests pass" |

---

## Why This Template?

This template prevents common failure modes:

1. **Wrong assumptions** → Discovery Phase catches them early
2. **Ambiguous specs** → EXACT specifications required
3. **Frontend/backend mismatch** → Remote Actions Checklist
4. **"Tests pass but broken"** → Browser Verification Tests section
5. **Missing edge cases** → Comprehensive Test Plan

**Result:** 95%+ complete specs before implementation, 6-9x faster implementation.
