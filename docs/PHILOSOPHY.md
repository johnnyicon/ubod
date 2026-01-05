# Ubod Philosophy

**Ubod** is the universal kernel for AI agent configuration. This document explains the core principles, design decisions, and vision behind Ubod.

## The Problem Ubod Solves

### Before Ubod

When setting up AI coding agents (GitHub Copilot, Claude Code, etc.) for a monorepo:

1. **Fragmentation** - Each tool has different configuration formats
2. **Duplication** - Same instructions written separately for each tool
3. **Inconsistency** - Methodology drifts across tools
4. **Scaling Problems** - Adding a new tool means re-doing everything
5. **Maintenance Burden** - Updating instructions requires edits in multiple places

**Result:** Teams end up with scattered, inconsistent AI agent configurations that are hard to maintain and scale.

### The Ubod Solution

Ubod introduces a **single source of truth** for AI agent methodology, which is then automatically generated into tool-specific configurations.

**Before:**
```
Copilot Config (manual)
↑ Different
Claude Code Config (manual)
↑ Different
Anti-Gravity Config (manual)
```

**After (with Ubod):**
```
Methodology Templates (tool-agnostic)
↓ (Prompt 1)
Universal Kernel
↓ (Prompt 2 per app)
Copilot Config | Claude Code Config | Anti-Gravity Config (auto-generated, consistent)
```

## Core Principles

### 1. Methodology Over Configuration

**Principle:** What matters most is HOW you work, not what tools you use.

Most people think about configuration:
- "What agents do I need?"
- "What settings should I use?"
- "What format does this tool require?"

Ubod asks different questions:
- "What methodology do we want to follow?" (discovery before implementing)
- "What patterns work best?" (Stimulus + ViewComponent for Rails)
- "How do we verify things work?" (tests pass + runtime verification)
- "What tooling helps us follow this methodology?"

**Example:** Instead of defining Copilot agents, define "we do evidence-first discovery" → then Ubod generates agents that enforce this across all tools.

### 2. Template-Driven Generation

**Principle:** Reuse templates by filling in actual values, don't rewrite from scratch.

Every monorepo is unique:
- Different frameworks (Rails, Next.js, Django)
- Different patterns (Stimulus controllers, React hooks)
- Different testing approaches (Minitest, Jest, Playwright)

But the **methodology is the same:**
- Discover before implementing
- Verify assumptions
- Test thoroughly
- Think about edge cases

Ubod solves this with templates + LLM customization:

```yaml
Template (80% of the work):
  name: Discovery Methodology
  description: How to approach new features systematically
  steps:
    - Search for similar features
    - Find existing patterns
    - Check git history
    - Read actual source code
    - Document findings

Customization (20% of the work):
  Fill in:
    - {{MONOREPO_APPS}} → [tala, v0-tala, nextjs-chat-app]
    - {{FRAMEWORK_STACKS}} → [Rails + Hotwire, Next.js, etc.]
    - {{TESTING_APPROACH}} → [Minitest, Jest, Playwright]

Result:
  Customized instructions using your actual frameworks and patterns
```

### 3. Two-Phase Generation

**Principle:** Separate universal methodology from app-specific expertise.

**Phase 1: Universal Kernel**
- Scan the entire monorepo
- Identify shared patterns
- Extract common methodology
- Generate universal instructions, discovery practices, verification checklists
- **Output:** Foundation that works across ALL apps

**Phase 2: App-Specific Customization**
- For each app individually
- Identify unique patterns and gotchas
- Generate app-specific agents with deep expertise
- Create app-specific prompts and instructions
- **Output:** Deep domain knowledge for that specific app

This separation means:
- **Universal changes** are made once, applied everywhere
- **App-specific improvements** don't affect other apps
- **New apps** can reuse the universal kernel immediately
- **Tool changes** are isolated to tool-specific folders

### 4. LLM-Powered, Not Automated Magic

**Principle:** LLMs are tools for filling templates, not for magic automation.

The key insight: **LLMs are good at:**
- Reading actual code and understanding patterns
- Filling in templates based on concrete examples
- Generating tool-specific variations
- Explaining tradeoffs

**LLMs are bad at:**
- Guessing your methodology without explicit guidelines
- Maintaining consistency across multiple runs
- Understanding implicit conventions in your codebase

Ubod works by:
1. **You define methodology** - "We do discovery first" → captured in templates
2. **LLM reads your codebase** - Prompt 1 asks LLM to scan monorepo structure
3. **LLM fills templates** - Prompt 2 fills {{PLACEHOLDERS}} with actual findings
4. **You verify and refine** - Review outputs, adjust templates if needed
5. **Regenerate anytime** - When codebase changes, re-run prompts

### 5. Tool-Agnostic Core, Tool-Specific Variants

**Principle:** Core methodology works everywhere; tool differences are isolated.

The templates in `ubod/templates/` are **tool-agnostic**:
- Instructions that work for any AI tool
- Agent definitions in generic format
- Prompts using common patterns

Each tool folder (github-copilot/, claude-code/) contains:
- **Tool-specific adapters** - How to use tool X's features
- **Configuration examples** - Settings for this tool
- **Customization guides** - Unique capabilities to leverage

This means:
- Most of Ubod is reusable across tools
- Tool-specific parts are clearly isolated
- Adding a new tool is straightforward
- Template improvements benefit all tools

### 6. Extensibility by Design

**Principle:** Ubod is designed to grow with your infrastructure.

Ubod is the first infrastructure project in `projects/` folder:
```
projects/
├── ubod/           ← First project (core methodology)
├── custom-tool/    ← Could be next (custom DSL, evaluator, etc.)
└── other-tool/     ← Could be future (whatever helps next)
```

Ubod is extensible in three ways:

1. **New templates** - Add new instruction/agent/prompt templates
2. **New tools** - Add new folder (anti-gravity/), extend multi-tool support
3. **New methodology** - Refine templates based on learnings, improve documentation

### 7. Copy-Paste Friendly

**Principle:** Prompts should work with ANY LLM via copy-paste.

You shouldn't need:
- Special APIs
- Custom scripts
- Specific tool integration

Just:
1. Open `prompts/01-setup-universal-kernel.prompt.md`
2. Copy the content
3. Paste into Claude (or any LLM)
4. Follow the prompts
5. Paste results back into your repo

This simplicity means:
- Works with any LLM (Claude, ChatGPT, Gemini, etc.)
- Works offline if you have a local LLM
- Works in any environment
- No dependencies on tool APIs

## Design Decisions

### Why Templates with {{PLACEHOLDERS}} Instead of Config Files?

**Option 1 (Not chosen):** JSON/YAML config file
```json
{
  "monorepo_apps": ["tala", "v0-tala"],
  "frameworks": ["rails", "nextjs"]
}
```
❌ Problem: Requires parsing, validation, complex schema

**Option 2 (Chosen):** Markdown templates with {{PLACEHOLDERS}}
```markdown
Your monorepo has these apps:
- {{APP1_NAME}} ({{APP1_FRAMEWORK}})
- {{APP2_NAME}} ({{APP2_FRAMEWORK}})
```
✅ LLMs understand this naturally and fill it in correctly

### Why Two Prompts Instead of One?

**Option 1 (Not chosen):** Single prompt for everything
❌ Problem: Too much context, LLM loses focus, inconsistent app-specific details

**Option 2 (Chosen):** Two sequential prompts
✅ Prompt 1 generates universal foundation, Prompt 2 specializes per-app
✅ Cleaner separation of concerns
✅ Easier to re-generate just app-specific files when app changes

### Why Markdown for Instructions Instead of YAML Frontmatter?

**Option 1 (Not chosen):** Pure YAML configuration
```yaml
---
title: Discovery Methodology
priority: critical
---
Steps...
```
❌ Problem: Harder to read, edit, and version control with meaningful diffs

**Option 2 (Chosen):** Markdown with embedded metadata
```markdown
# Discovery Methodology (Universal - Critical)

Steps...
```
✅ Highly readable, easy to edit, good version control, AI-friendly

### Why Separate Tool Folders Instead of One Config Per Tool?

**Option 1 (Not chosen):** Single config file with tool-specific sections
```
ubod/
├── config.json
│   {
│     "github_copilot": {...},
│     "claude_code": {...}
│   }
```
❌ Problem: Mixing concerns, hard to extend, unclear what changes affect what

**Option 2 (Chosen):** Separate tool folders with own README and examples
```
ubod/
├── github-copilot/  ← All Copilot-specific stuff
├── claude-code/     ← All Claude-specific stuff
├── anti-gravity/    ← All Anti-Gravity-specific stuff
```
✅ Clear separation, easy to understand each tool's needs
✅ Easy to add new tools (just add new folder)
✅ Tool improvements don't affect other tools

## How These Principles Work Together

1. **Methodology Over Configuration** + **Template-Driven Generation**
   - Define methodology in templates
   - LLM fills with your actual framework and patterns
   - Result: Methodology is enforced through tools

2. **Two-Phase Generation** + **Tool-Agnostic Core**
   - Universal kernel works across tools
   - Each tool gets same methodology, different format
   - Result: Consistency with tool-specific optimization

3. **LLM-Powered** + **Copy-Paste Friendly**
   - LLM fills templates by reading your code
   - You verify results before committing
   - Result: Accurate, customized setup without magic

4. **Extensibility** + **Tool-Agnostic Core**
   - Core templates work for new tools automatically
   - Add tool-specific folder when new tool appears
   - Result: Grows with your infrastructure

## Future Vision

Ubod v1.0 focuses on AI agent configuration. Future versions could extend to:

### Ubod v1.1 - Evaluation Framework
- Templates for defining evaluation metrics
- Prompt templates for evaluation tasks
- Tool-specific evaluation configurations

### Ubod v2.0 - Custom Infrastructure Tools
- Scaffold new infrastructure projects using Ubod methodology
- `projects/ubod/` as the reference for all project infrastructure
- Template-driven setup for new tools

### Ubod v3.0 - Multi-Org Support
- Reuse Ubod across multiple organizations
- Organization-level customization templates
- Shared methodology library

## Why "Ubod"?

"Ubod" is Filipino for "seed" or "kernel" - the foundational element from which growth emerges. Like a seed, Ubod is:

- **Small but powerful** - Simple concept, broad impact
- **Generative** - From one kernel grows many configurations
- **Natural** - Works with LLMs (they understand natural language templates)
- **Rooted** - Grounded in proven methodology, not speculation

---

**Next:** Read [SETUP_GUIDE.md](SETUP_GUIDE.md) to understand how to implement Ubod.

**Questions?** See [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

**Last Updated:** January 5, 2026  
**Version:** 1.0
