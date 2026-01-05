---
applyTo: "**/*"
---

# Discovery First (Universal Reminder)

**Purpose:** Always-on reminder to perform discovery before implementing

**Last Updated:** 2025-12-31

---

🔍 **DISCOVERY PROTOCOL ACTIVE** - Search and verify before implementing

---

## 🔍 Discovery Before Implementation

**ALWAYS perform discovery first. Never assume - always search and verify.**

### Quick Discovery Checklist

Before writing ANY code:

1. **Search for similar features** (semantic search)
2. **Find existing patterns** (grep for classes, methods, patterns)
3. **Check git history** (how was similar code implemented?)
4. **Read actual source** (verify assumptions against real code)
5. **Document findings** (what exists, what patterns to follow)

### For Detailed Discovery Methodology

**If you're on VS Code Stable (no skills yet):**
- Use the reusable prompt defined at: `.github/prompts/discovery-methodology.prompt.md`
- In Copilot, run the **Discovery Methodology (Search-First Workflow)** prompt to lead a full discovery phase.

**If you're on a build that supports Skills (future):**
Use the discovery skill for comprehensive, always-available guidance:
```
@workspace /skill discovery-methodology
```

Skill definition: `.github/skills/discovery-methodology/SKILL.md`

---

**Remember:** 5 minutes of discovery saves hours of rework.

---

✅ **DISCOVERY PROTOCOL COMPLETE** - Proceed to implementation with verified facts
