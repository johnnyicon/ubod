# PRD Tracking Strategy Research

**Date:** 2026-01-10
**Status:** Completed - Consensus Reached
**Decision:** Hybrid Approach (Option 3)

---

## Research Question

Should PRD tracking use:
1. **Local Files Only** (status quo)
2. **GitHub Issues Only** (centralized tracking)
3. **Hybrid** (local files + GitHub Issues for deferred items)

---

## Methodology

Created comprehensive research prompt with:
- Full PRD context (first-class documents implementation)
- Options with detailed pros/cons
- Evaluation criteria (latency, integration, searchability, etc.)
- Specific guidance on synthesizing recommendations

Executed via 3 independent LLMs:
- ChatGPT 5.2
- Claude Opus 4.5
- Gemini 3 Pro

---

## Outcome

**All 3 models independently recommended Option 3 (Hybrid)** with 85-90% confidence.

### Recommended Implementation

1. **Keep PRDs as local Markdown files** during active development
   - Zero latency for AI agent access
   - Rich formatting with code blocks, tables, diagrams
   - Works offline
   - Full version control history

2. **Extract deferred items to GitHub Issues** when archiving PRD
   - Prevents loss of P2/P3 items in archived PRDs
   - Provides tracking and reminders
   - Cross-references back to original PRD

3. **Add YAML frontmatter** to PRD files
   - Enable filtering and queries
   - Track status, priority, dates without losing readability

### Key Insights

- **Latency matters:** Local files provide 0ms access vs 200-500ms API calls (critical for AI coding flows)
- **Context richness:** PRDs need diagrams, code snippets, architecture context - Markdown excels
- **Deferred items problem:** GitHub Issues solve "out of sight, out of mind" for P2/P3 features
- **Hybrid complexity justified:** Benefits outweigh overhead for serious product development

---

## Research Artifacts

- [ChatGPT 5.2 Analysis](./2026-01-10-chatgpt-52-prd-tracking-analysis.md)
- [Claude Opus 4.5 Analysis](./2026-01-10-claude-opus-45-prd-tracking-analysis.md)
- [Gemini 3 Pro Analysis](./2026-01-10-gemini-3-pro-prd-tracking-analysis.md)

---

## Application

See [PRD Tracking Workflow](../../docs/prd-tracking-workflow.md) for implementation guide.

Updated PRD template: `templates/prds/PRD_TEMPLATE.md`

---

## Meta

This research demonstrates:
- Using multiple LLMs for independent validation
- Lightweight synthesis (this README vs. full synthesis doc)
- Research storage in `ubod-meta/research/` vs. docs in `ubod-meta/docs/`
