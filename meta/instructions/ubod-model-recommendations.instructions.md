---
applyTo: "**/*"
---

# Model Recommendations for ubod Framework

**Purpose:** Guide model selection for framework setup, updates, and app-specific customization

---

## Core Principle

**Framework setup requires reasoning and methodology understanding more than raw coding ability.**

The ubod framework defines HOW to work with AI coding agents. This meta-level work benefits from:
- Deep reasoning about workflows
- Cross-referencing patterns across domains
- Identifying gaps and edge cases
- Synthesizing methodology from experience

---

## Model Selection Matrix

### For Framework Setup (New Repo)

| Phase | Recommended Models | Reasoning |
|-------|-------------------|-----------|
| **Initial Scaffolding** | Claude Opus 4.5, GPT 5.1+, Gemini 3 Pro | Deep reasoning, context synthesis, methodology understanding |
| **Review Pass** | *Different model family than initial* | Cross-check assumptions, catch blind spots from different perspective |
| **File Creation** | Sonnet 4.5, GPT 5, Haiku 4.5 | Straightforward implementation once methodology is clear |

### For Framework Updates

| Task Type | Recommended Models | Notes |
|-----------|-------------------|-------|
| **New Methodology Pattern** | Claude Opus 4.5, GPT 5.1+ | Requires understanding existing patterns and how new one fits |
| **Refining Existing Instruction** | Sonnet 4.5, GPT 5 | Context is clearer, less synthesis needed |
| **Adding Examples/Templates** | Any capable model | Mostly content generation with clear spec |
| **Sanitization/Generification** | Claude Opus 4.5 | Nuanced judgment about what's app-specific vs universal |

### For App-Specific Customization

| Task Type | Recommended Models | Notes |
|-----------|-------------------|-------|
| **Generate Complexity Matrix** | Sonnet 4.5 + app context | Needs to understand app's tech stack |
| **Generate Architecture Doc** | Claude Opus 4.5 with codebase access | Deep codebase analysis |
| **Create App Patterns** | Sonnet 4.5 | Pattern matching with existing code |

---

## Multi-Pass vs One-Shot

### When to Use Multi-Pass (2-3 Models)

**Use multi-pass for foundational work:**

1. **Initial framework setup** in a new repo
2. **Major methodology changes** (new instruction categories)
3. **Architectural decisions** about instruction structure
4. **Sanitization work** (what's universal vs app-specific)

**Recommended multi-pass workflow:**

```
Pass 1: Initial Draft (Claude Opus or GPT 5.1)
   ↓
Pass 2: Review + Refinement (Different model family)
   ↓
Pass 3: Final Verification (Third model or human review)
```

### When to Use One-Shot

**Use one-shot for incremental work:**

1. **Adding a single instruction** following established patterns
2. **Updating examples** in existing instructions
3. **Fixing typos or clarifications**
4. **Generating app-specific files** from prompts

---

## Model Characteristics for ubod Work

### Claude Opus 4.5
- **Strengths:** Deep reasoning, methodology understanding, nuanced judgment
- **Best for:** Initial framework design, sanitization decisions, gap analysis
- **Watch for:** Can be verbose; may over-engineer

### GPT 5.1+ / GPT 5.2
- **Strengths:** Broad knowledge, good at cross-referencing patterns
- **Best for:** Review passes, finding edge cases, alternative perspectives
- **Watch for:** May suggest trendy patterns that don't fit

### Gemini 3 Pro
- **Strengths:** Good at structural analysis, finding inconsistencies
- **Best for:** Review passes, template validation, consistency checks
- **Watch for:** May focus on format over substance

### Sonnet 4.5 / GPT 5
- **Strengths:** Fast, capable, good at implementation
- **Best for:** File creation, straightforward updates, app-specific generation
- **Watch for:** May miss subtle methodology issues

### Haiku 4.5 / Lighter Models
- **Strengths:** Fast, cheap, good for simple tasks
- **Best for:** Template filling, simple updates, verification checks
- **Watch for:** May miss nuance in methodology work

---

## Summary

| Work Type | Model Choice | Pass Count |
|-----------|--------------|------------|
| Framework setup | Opus/GPT 5.1+ | Multi (2-3) |
| Major methodology change | Opus/GPT 5.1+ | Multi (2-3) |
| Sanitization decisions | Opus | Multi (2) |
| New instruction (simple) | Sonnet 4.5 | Single + self-review |
| Update existing | Sonnet 4.5 | Single |
| App-specific generation | Sonnet 4.5 | Single |
| Quick fixes | Any | Single |

---

**Remember:** The goal is not to use the most expensive model everywhere, but to match model capability to task complexity. Framework methodology work is inherently high-complexity and benefits from stronger reasoning.
