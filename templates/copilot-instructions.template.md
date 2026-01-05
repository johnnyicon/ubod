# [REPO_NAME] - Repository Instructions

**Purpose:** High-level repository guidance and routing for GitHub Copilot

**Last Updated:** [DATE]

---

## 🚨 Critical Rules (Read First)

**Before ANY task:** The critical rules are always loaded via:
`.github/instructions/universal-critical-rules.instructions.md`

That file contains 4 non-negotiable rules:
1. Inspect First (show evidence before coding)
2. Clarify Before Assume (ask questions)
3. Try Simple First (CSS before code)
4. Two-Phase Response (discovery → approval → implementation)

---

## 📂 Repository Structure

This is a **monorepo** with multiple apps:

[LIST_YOUR_APPS_HERE - Example format:]
- **`apps/your-app/`** - Tech stack description
- **`apps/another-app/`** - Tech stack description

**Framework:**
- **`projects/ubod/`** - Universal AI agent kernel (git submodule)

**App-specific instructions auto-load** based on file path (see `.vscode/settings.json`).

---

## 🎯 Workflow Prompts

Use these prompts for structured workflows:

[ADD_YOUR_CUSTOM_PROMPTS_HERE - Example format:]
- **`/your-prompt`** - Description of what it does
- **`/another-prompt`** - Description

**Location:** `.github/prompts/*.prompt.md`

---

## 🔧 Ubod Maintenance

Use these prompts to maintain the Ubod framework itself:

- **`/ubod-bootstrap-app-context`** - Set up Ubod context for a new app
- **`/ubod-create-instruction`** - Create a new instruction file
- **`/ubod-update-instruction`** - Update existing instruction file
- **`/ubod-generate-complexity-matrix`** - Generate complexity matrix for task routing
- **`/ubod-migrate-copilot-instructions`** - Update this file when monorepo changes

**Location:** `.github/prompts/ubod/*.prompt.md`

---

## 📚 Deep Guidance (Skills)

Use these for comprehensive methodology:

- **`@workspace /skill discovery-methodology`** - How to discover before implementing
[ADD_YOUR_CUSTOM_SKILLS_HERE if any]

**Location:** `.github/skills/*/SKILL.md`

---

## 🔧 Always-On Instructions

These load automatically based on file path:

**Universal (all files):**
- `.github/instructions/discovery-methodology.instructions.md` - Discovery reminder
- `.github/instructions/monorepo-routing.instructions.md` - Monorepo context detection
- `.github/instructions/universal-critical-rules.instructions.md` - Critical rules
- `.github/instructions/stuck-detection.instructions.md` - Stuck detection protocol
- `.github/instructions/task-completion-verification.instructions.md` - Completion verification
- `.github/instructions/runtime-verification.instructions.md` - Runtime verification for UI
- `.github/instructions/verification-checklist.instructions.md` - Verification checklist
- `.github/instructions/two-phase-response.instructions.md` - Two-phase response pattern
- `.github/instructions/task-complexity-signals.instructions.md` - Complexity signals

**Ubod Framework:**
- `.github/instructions/ubod/ubod-model-recommendations.instructions.md` - Model selection guidance

**[APP_NAME]-specific (auto-loads for `apps/[app]/**/*`):**
[LIST_APP_SPECIFIC_INSTRUCTIONS_HERE - Example format:]
- `apps/your-app/.copilot/instructions/app-critical-gotchas.instructions.md`
- `apps/your-app/.copilot/instructions/app-architecture.instructions.md`
- `apps/your-app/.copilot/instructions/app-testing.instructions.md`

---

## 🤖 Available Agents

Use `@agent-name` to invoke specialized agents:

- **@ubod-maintainer** - Maintain Ubod framework (create/update instructions, prompts)
[ADD_YOUR_CUSTOM_AGENTS_HERE - Example format:]
- **@your-agent** - Description of what it does

**Location:** `.github/agents/*.agent.md`

---

## 🏗️ Tech Stack Summary

**[PRIMARY_APP] (Primary App):**
[LIST_TECH_STACK_HERE - Example format:]
- Backend: [Framework, Database, Job System]
- Frontend: [Framework, State Management, Component Library]
- Testing: [Test Framework, Browser Testing]
- AI/RAG: [AI Services, Vector DB]

**Other Apps:** See respective README files

---

## 📖 Additional Resources

**Workflow Documentation:**
[ADD_YOUR_DOCS_HERE - Example format:]
- `docs/workflow/QUICK_START.md` - Quick start guide
- `docs/workflow/LEARNINGS.md` - Learnings log

**PRD Templates:**
[ADD_YOUR_PRD_TEMPLATES_HERE if any - Example format:]
- `prds/templates/PRD_TEMPLATE.md` - Template for new PRDs

---

**Remember:** This file is a high-level index. Detailed guidance is in prompts, skills, and instructions files.
