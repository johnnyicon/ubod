---
name: GPT Instructions Conversion
description: Methodology for converting ubod agent specifications into ChatGPT GPT system instructions while preserving behavioral controls.
version: 1.0.0
---

# GPT Instructions Conversion Skill

**Purpose:** Guide for transforming ubod-format agents into token-efficient GPT instructions

**When to Use:**
- Converting a ubod agent.md for deployment as a ChatGPT GPT
- Updating GPT instructions after agent changes
- Validating that behavioral controls survived compression
- Documenting conversion patterns for future reference

---

## Quick Commands

1. **Convert Agent** – Transform ubod agent → GPT instructions
2. **Validate Fidelity** – Check behavioral controls are preserved
3. **Compare Before/After** – Show what changed and why
4. **List Knowledge Files** – Identify which files to upload to GPT
5. **Generate Test Cases** – Create prompts to verify GPT behavior

---

## Architecture Differences

### ubod Agent Environment

**Execution model:**
- Agents have file-reading tools (`read_file`, `grep_search`)
- Progressive disclosure: agent.md → skill.md → references/*
- Explicit file calls work: "Read skill/skill.md for methodology"
- Token budget: effectively unlimited (loads on demand)

**Structure:**
- agent.md: ROLE, COMMANDS, BOUNDARIES, SCOPE, WORKFLOW, DOMAIN CONTEXT
- skill/skill.md: detailed methodology
- skill/references/: examples, templates, deep-dives

---

### ChatGPT GPT Environment

**Execution model:**
- **No file-reading tools** (file refs are non-functional syntax)
- Knowledge base: auto-retrieved via semantic search
- **System instructions: 8,000 character hard limit** (not tokens, not words — characters)
- Retrieval is probabilistic (not guaranteed like explicit file reads)

**Constraints:**
- System prompt must be self-contained
- Behavioral rules must be in instructions (not just Knowledge)
- Examples/templates can live in Knowledge
- Token efficiency is critical
- **If over 8,000 chars: move detailed examples, templates, and verbose structures to Knowledge files**

---

## Conversion Patterns

### 1. Compress Without Losing Control

**KEEP in instructions (always):**
- Voice bans (forbidden words, tone rules, structural anti-patterns)
- Output format defaults (how many options, labeling structure)
- Validation checklists (pass/fail criteria)
- Decision rules (when to ask vs. default)
- Non-negotiables (hook-first, no meta-narration, etc.)

**COMPRESS (prose → rules):**
- Long paragraphs → bullet lists
- Repeated explanations → single if/then rule
- "Here's why this matters..." → cut (save tokens)

**MOVE to Knowledge (examples/templates):**
- Detailed voice examples
- Platform-specific templates
- Brand facts, guest bios, episode summaries
- Operational FAQs

---

### 2. Convert File References

**ubod syntax (works with file tools):**
```
Read: skill/skill.md (core methodology)
If deeper guidance needed:
  Read: skill/references/voice-examples.md
```

**GPT syntax (documents intent, triggers retrieval):**
```
Consult knowledge files for core methodology, voice examples, and templates.

When writing, reference:
- Voice patterns (knowledge base)
- Platform templates (knowledge base)
- Brand facts (knowledge base)

Note: Explicit file references below document the knowledge structure,
even though GPT retrieves semantically rather than via file paths.

Files:
- skill.md: core methodology
- voice-examples.md: detailed examples
- platform-templates.md: format guidance
```

**Why keep file references?**
- Documents what *should* be in Knowledge
- Makes conversion reversible (can reconstruct ubod format)
- Helps humans understand the structure
- Acts as a "loading manifest" for future updates

---

### 3. Structure for GPT

**Recommended order (token-efficient):**

```
1. Identity (1-2 sentences)
   "You are [name]: [purpose]."

2. Job description (what you create, for whom)
   "Create [outputs] for [platforms/contexts]."

3. Knowledge instruction
   "Use attached knowledge files as canonical reference. Consult them when relevant."

4. Voices (if multi-voice agent)
   Brief definition + when to use each.

5. Commands (user intents)
   Action-oriented list, not workflows.

6. Boundaries
   Always do / Ask first / Never do (bullet lists).

7. Scope
   What you create / don't create.

8. Workflows (mode-specific)
   Separate by mode (Write Post, Analyze Content, etc.).
   Use if/then triggers.

9. Output defaults
   "Provide Recommended + Alt 1 + Alt 2 unless user asks for single option."
   "Include hashtags only if requested."

10. Guardrails (testable bans)
    Voice bans, vocabulary bans, structural bans.

11. Privacy/naming rules (if applicable)
    "Never output these names: [list]"

12. File manifest (optional but recommended)
    "Knowledge files:
     - skill.md: methodology
     - voice-examples.md: tone guidance
     - templates.md: platform formats"
```

---

## Behavioral Preservation Checklist

Before delivering GPT instructions, verify:

- [ ] **Voice bans intact?** (Forbidden words, tone rules, "no X" patterns)
- [ ] **Output format preserved?** (Number of options, labeling, structure)
- [ ] **Validation checklist present?** (Pass/fail criteria from original agent)
- [ ] **Decision rules converted?** (Prose → if/then triggers)
- [ ] **Non-negotiables explicit?** (Hook-first, no meta-narration, etc.)
- [ ] **Knowledge references clear?** (What to consult when)
- [ ] **File manifest included?** (Documents Knowledge structure)
- [ ] **Character count under 8,000?** (Run `wc -c` to verify)

If any fail: compress differently or add back critical controls.

---

## Example: Voice Ban Conversion

**ubod agent.md (detailed prose):**
```
🚫 Never do:
- Use corporate language: "innovative," "synergy," "stakeholders," "leverage," "disruptive"
- Sound polished, slick, or like a press release
- Be cynical or contemptuous (critical but constructive only)
- Use fake enthusiasm: "Exciting news!", "We're thrilled to announce!"
- Preach or lecture the audience
- Create generic content that could apply to any podcast
- Skip the systems lens—always connect to root causes and patterns
```

**GPT instructions (compressed, testable):**
```
Never do:
- Corporate jargon (innovative, synergy, stakeholders, leverage, disruptive)
- Press-release tone, slick hype, fake enthusiasm ("Exciting news!", "We're thrilled...")
- Cynicism, contempt, preaching/lecturing
- Generic content (must be specific to this podcast/guest)
- Skip systems lens (always connect to root causes/patterns)
```

---

## Example: File Reference Conversion

**ubod agent.md (functional file calls):**
```
### 2. Load Context

Read: skill/skill.md (core methodology)
If deeper guidance needed:
  Read: skill/references/sg2gg-voice-quick-reference.md
  Read: skill/references/platform-templates.md
```

**GPT instructions (documents intent, triggers retrieval):**
```
Consult knowledge files for methodology, voice examples, and platform templates.

Knowledge structure (auto-retrieved by topic):
- Core methodology: skill.md
- Voice guidance: sg2gg-voice-quick-reference.md
- Platform formats: platform-templates.md
- Brand facts: sg2gg-brand-facts.md

When writing, reference voice patterns and templates from knowledge base.
```

---

## Character Budget Guidelines

**Hard limit: 8,000 characters for GPT system instructions**

This is a GPT platform constraint. Not tokens, not words — characters (including spaces and punctuation).

**Target: ~4,000-6,000 characters** (leaves room for iteration)

**If over 8,000 characters:**
- Move detailed examples to Knowledge files
- Convert prose to bullets
- Combine similar rules
- Reference Knowledge for details ("See Knowledge for platform templates")
- Remove verbose explanations ("Here's why..." → cut)

**Never cut to save characters:**
- Voice bans (behavioral controls)
- Output format specs
- Validation checklist items (can compress, not remove)
- Non-negotiables

**Validation:** Run `wc -c filename.md` to check character count before delivery.

---

## Conversion Learnings (Patterns to Apply)

These patterns emerged from real-world feedback on GPT instructions:

### 1. Assumption Defaults > Ask Lists

**Problem:** Long "ask first" lists cause the GPT to stall every request with questions.

**Fix:** Convert blocking questions to if/then defaults with placeholders.

| If Missing... | Default To... |
|---------------|---------------|
| URL | Use `[link]` placeholder, note "Drop link when ready" |
| Handles | Write "(tag @guest + @org)" reminder |
| Asset type | Assume clip unless context suggests full episode |

**Rule:** Only ask when missing info truly blocks the task.

---

### 2. Opt-in > Default-on for Marketer-Coded Behaviors

**Problem:** Default-on behaviors like "include 3-6 hashtags" can push outputs into "social marketer" territory, contradicting operator-warm voice.

**Fix:** Make hashtags, emojis, and other marketer tells opt-in or default to minimal (0-3).

---

### 3. Retrieval Fallback Clause

**Problem:** "Auto-retrieved by topic" implies guaranteed retrieval, which GPT cannot promise.

**Fix:** Always include fallback language:
```
If knowledge files are not retrieved or unavailable, proceed with defaults from these instructions and state assumptions.
```

---

### 4. Brittle Style Bans Need Context

**Problem:** Hard style bans (like "no em-dashes") may be intentional (user-specified) or overly rigid (loss of useful pacing tool).

**Fix:** When converting, ask: "Is this ban user-specified or inferred?" If user-specified, keep it hard. If inferred, soften to "avoid overuse."

**Exception:** If user explicitly wants a hard ban, preserve it exactly.

---

### 5. Implied Asset Assumptions

**Problem:** Platform rules may assume source material that doesn't exist (e.g., "YouTube timestamps" requires time markers in transcript).

**Fix:** Add conditionals:
```
Provide timestamps only when source includes time markers; otherwise suggest 3-5 chapter titles.
```

---

### 6. Review/Analyze Commands Need Output Shape

**Problem:** Commands like "Review Copy" lack specificity on what to return.

**Fix:** Specify output format for each command:
```
Review Copy: scorecard + 1 improved rewrite + 1 punchier rewrite
```

---

## Resources (Level 3 - Load on Demand)

For deeper guidance, reference these files:

| File | Contents |
|------|----------|
| `compression-patterns.md` | Specific before/after patterns for common agent elements |
| `gpt-architecture-constraints.md` | Technical details about GPT system prompt limits, retrieval behavior |
| `behavioral-preservation-checklist.md` | Detailed checklist for validating conversions |
| `examples/conversions/` | Real conversion examples with before/after comparisons |

---

*Version 1.1.0 | Last updated: February 2, 2026*
