# Ubod Resources

External references and inspiration for Ubod's design and implementation.

---

## Agent Design & Best Practices

### How to Write a Great agents.md (GitHub, 2025)
**Source:** [GitHub Blog](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)  
**Date Referenced:** January 5, 2026  
**Key Insights:**
- Analysis of 2,500+ repositories with agent files
- Best practices for agent metadata structure
- Importance of executable commands early in agent files
- Three-tier boundary system (✅ Always / ⚠️ Ask first / 🚫 Never)
- Code examples more effective than explanations
- Six core areas: commands, testing, structure, style, git workflow, boundaries

**What We Adopted:**
- COMMANDS section in agent templates (executable commands with flags)
- BOUNDARIES section with emoji markers (✅⚠️🚫)
- Visual formatting for clarity

**What We Didn't Adopt (and why):**
- Self-contained agents - Ubod's distributed architecture (instructions + thin agents) is more maintainable for monorepos
- Embedding project knowledge in agents - We generate `ARCHITECTURE.md` instead
- Duplicating rules across agents - Instructions via `applyTo` scope provide depth without duplication

---

## Monorepo Management

[Add future references here]

---

## AI-Assisted Development

[Add future references here]

---

## Contributing

When adding resources:
1. Include source URL and date referenced
2. Summarize key insights relevant to Ubod
3. Note what we adopted vs. what we didn't (with rationale)
4. Keep entries concise but informative
