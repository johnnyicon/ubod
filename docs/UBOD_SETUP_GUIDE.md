# Ubod Setup Guide

This guide walks you through implementing Ubod in your monorepo, step by step.

## Prerequisites

- **Monorepo setup** (like bathala-kaluluwa)
- **Access to an LLM** - See [ubod-meta/MODEL_RECOMMENDATIONS.md](../ubod-meta/MODEL_RECOMMENDATIONS.md) for detailed guidance
  - **Foundational work:** Claude Opus 4.5, GPT 5.1+, or Gemini 3 Pro (stronger reasoning)
  - **Implementation:** Claude Sonnet 4.5, GPT 5 (efficient execution)
  - **Review pass:** Use a *different model family* than initial generation
- **30 minutes** for first-time setup
- **Editor** (VS Code or similar for copy-paste)
- **Git** (to commit results)

## If Ubod Is a Git Submodule

If your monorepo includes Ubod as a submodule (for example at `projects/ubod/`), clone and initialize submodules so `projects/ubod/` is populated:

```bash
git clone --recurse-submodules <your-monorepo-repo-url>

# If you already cloned:
git submodule update --init --recursive
```

## Implementation Path

This guide assumes you're starting fresh. Pick your path:

### Path 1: Full Implementation (Recommended)
Do Phase 1 (Universal Kernel + Meta) and Phase 2 (App-Specific). Takes 30 minutes. Best results.

### Path 2: Universal Kernel Only
Do Phase 1 only. Takes 20 minutes. Good for exploring or framework testing.

### Path 3: Quick Test
Do one app with Phase 2 only. Takes 10 minutes. Quick validation.

**Note:** Phase 1 now includes both universal kernel AND meta content deployment (they're deployed together).

---

## Phase 1: Universal Kernel + Meta Content (20 minutes)

**What you'll deploy:**
- Universal instructions (discovery, verification, testing, etc.)
- Universal agent templates (discovery, implementation, verification)
- Ubod meta content (maintainer agent, meta prompts, model recommendations)

**Why deploy meta content now:** Every repo should be able to maintain ubod from day one. Meta content enables self-improvement.

### Step 1.1: Prepare Your Monorepo Info

Have this information ready (the prompt will ask for it):

```
Your monorepo name: bathala-kaluluwa
Your monorepo path: /Users/kanekoa/Workspace/bathala-kaluluwa-Worktrees/bathala-kaluluwa-tala-mvp

Your apps:
  - apps/tala/ (Rails 8.1.1 + Hotwire + Stimulus)
  - apps/nextjs-chat-app/ (Next.js + React)
  - apps/v0-tala/ (Next.js + React - v0 reference)
  - apps/rails8-inertia-chat-app/ (Rails 8 + Inertia + React)

Your testing approach:
  - Minitest for Rails apps
  - Jest for Next.js apps
  - System/integration tests with Playwright

Your framework magic spots:
  - ViewComponent + Stimulus in Rails apps
  - Turbo Streams for real-time updates
  - Portals in shadcn-rails components
  - Tailwind v4 with custom themes
```

### Step 1.2: Access the Prompt

Open `prompts/01-setup-universal-kernel.prompt.md` (or get it from [here](../prompts/01-setup-universal-kernel.prompt.md))

### Step 1.3: Run the Prompt

1. **Copy** the entire prompt content
2. **Open** your LLM (Claude.ai recommended)
3. **Paste** the prompt into a new conversation
4. **Answer** the interactive questions about your monorepo
5. **Wait** for the LLM to generate output (2-3 minutes)

### Step 1.4: Process the Output

The LLM will generate multiple files. You'll receive:

1. **Universal instruction files** (8-12 files)
   - discovery-methodology.instructions.md
   - verification-checklist.instructions.md
   - testing-strategy.instructions.md
   - ... others based on your monorepo

2. **Universal agent templates** (4-6 files)
   - discovery-planner.agent.md
   - implementer.agent.md
   - verifier.agent.md
   - ... others

3. **Implementation guide** (1 file)
   - How to organize the outputs
   - Which files go where

### Step 1.5: Save Universal Kernel Outputs

Create folders in your monorepo:

```bash
mkdir -p /path/to/monorepo/.github/instructions
mkdir -p /path/to/monorepo/.github/agents
```

Save each generated instruction file with the `.instructions.md` extension:

```
.github/instructions/
├── discovery-methodology.instructions.md
├── verification-checklist.instructions.md
├── testing-strategy.instructions.md
├── runtime-verification.instructions.md
├── task-completion-verification.instructions.md
└── ... (other universal instructions)
```

Save generated agent files (**at root level only, no subfolders**):

```
.github/agents/
├── universal-discovery-planner.agent.md
├── universal-implementer.agent.md
├── universal-verifier.agent.md
└── ...
```

### Step 1.6: Deploy Ubod Meta Content

**Now deploy meta content for ubod self-maintenance:**

Create ubod subfolders (prompts and instructions only):

```bash
mkdir -p /path/to/monorepo/.github/prompts/ubod
mkdir -p /path/to/monorepo/.github/instructions/ubod

# NOTE: Agents CANNOT use subfolders (VS Code limitation)
# They must be at .github/agents/ root level
```

Copy meta content:

```bash
# Copy agent to ROOT (VS Code only discovers agents at root level)
cp projects/ubod/ubod-meta/agents/ubod-maintainer.agent.md \
   .github/agents/ubod-maintainer.agent.md

# Copy prompts (subfolders OK)
cp projects/ubod/ubod-meta/prompts/ubod-*.prompt.md \
   .github/prompts/ubod/

# Copy instructions (subfolders OK)
cp projects/ubod/ubod-meta/instructions/ubod-*.instructions.md \
   .github/instructions/ubod/
```

**Final structure:**

```
.github/
├── agents/
│   ├── ubod-maintainer.agent.md              # ✓ Meta agent at root
│   ├── universal-discovery-planner.agent.md  # ✓ Universal agents
│   └── universal-implementer.agent.md
├── prompts/
│   └── ubod/                                 # ✓ Meta prompts in subfolder
│       ├── ubod-bootstrap-app-context.prompt.md
│       ├── ubod-create-instruction.prompt.md
│       ├── ubod-update-instruction.prompt.md
│       └── ubod-generate-complexity-matrix.prompt.md
└── instructions/
    ├── discovery-methodology.instructions.md  # Universal at root
    ├── verification-checklist.instructions.md
    └── ubod/                                  # ✓ Meta instructions in subfolder
        └── ubod-model-recommendations.instructions.md
```

### Step 1.7: Verify Phase 1 (Universal + Meta)

✅ Universal Kernel:
- [ ] At least 8 `.instructions.md` files in `.github/instructions/`
- [ ] At least 3 `.agent.md` files in `.github/agents/`
- [ ] Files mention your actual app names and frameworks

✅ Meta Content:
- [ ] `ubod-maintainer.agent.md` in `.github/agents/` (root level)
- [ ] 4 prompts in `.github/prompts/ubod/` (subfolders OK)
- [ ] 1 instruction in `.github/instructions/ubod/` (subfolders OK)

✅ Spot-check content:
- [ ] Universal files reference your actual frameworks (Rails, Next.js, etc.)
- [ ] Meta prompts are prefixed with `ubod-`
- [ ] Model recommendations match your available LLMs

If anything looks off, re-run Prompt 1 or re-copy meta content.

### Step 1.8: Commit Phase 1 (Universal + Meta)

```bash
cd /path/to/monorepo

git add .github/instructions/ .github/agents/ .github/prompts/
git commit -m "setup: Deploy Ubod universal kernel and meta content

- Add universal instructions (discovery, verification, testing, runtime, completion)
- Add universal agent templates (discovery, implementation, verification)
- Add ubod meta agent (maintainer) for framework self-maintenance
- Add ubod meta prompts (bootstrap, create, update, complexity matrix)
- Add ubod meta instructions (model recommendations)
- Foundation for consistent AI agent setup across all tools
- Enable ubod self-maintenance from consuming repo

Generated via: Ubod Phase 1 (Universal Kernel + Meta Content)"
```

---

## Phase 2: App-Specific Customization (15 minutes per app)

### Step 2.1: Prepare Your App Info

For each app you want to customize, gather:

```
App name: Tala
App path: apps/tala/
Framework stack: Rails 8.1.1 + Hotwire + Stimulus + ViewComponent
Domain: AI Chat Agent with RAG/Document Context
Key patterns:
  - Stimulus controllers for interactivity
  - ViewComponent for reusable UI
  - Turbo Streams for real-time updates
  - Shadcn-rails for UI components
  - PostgreSQL + PGVector for embeddings
Testing:
  - Minitest for models/controllers
  - Capybara for integration tests
  - Playwright for system tests
Gotchas/Magic:
  - Stimulus controllers break when inside <template> elements
  - ViewComponent slots don't support deep nesting
  - Portals move DOM elements outside their parent hierarchy
  - Turbo may intercept form submissions
  - Tailwind v4 doesn't generate classes from gem files
```

### Step 2.2: Access the Prompt

Open `prompts/02-setup-app-specific.prompt.md`

### Step 2.3: Run the Prompt (Per App)

Repeat for each app:

1. **Copy** Prompt 2 content
2. **Open** your LLM (same conversation or new one)
3. **Paste** the prompt
4. **Provide** app-specific information
5. **Also provide** Phase 1 outputs (copy/paste key points)
6. **Wait** for generation (3-5 minutes)

### Step 2.4: Process the Output

For each app, you'll receive:

1. **App-specific instruction files** (6-10 files)
   - {app-name}-critical-gotchas.instructions.md
   - {app-name}-architecture.instructions.md
   - {app-name}-testing.instructions.md
   - {app-name}-patterns.instructions.md
   - ... others specific to your app

2. **App-specific agents** (3-5 files)
   - {app-name}-discovery-planner.agent.md
   - {app-name}-implementer.agent.md
   - {app-name}-verifier.agent.md
   - ... others

3. **App-specific prompts** (2-4 files)
   - Common task prompts for this app
   - Framework-specific guidance

### Step 2.5: Save App-Specific Files

Create `.copilot/instructions/` for each app:

```bash
mkdir -p /path/to/monorepo/apps/{app-name}/.copilot/instructions
mkdir -p /path/to/monorepo/apps/{app-name}/.copilot/agents
mkdir -p /path/to/monorepo/apps/{app-name}/.copilot/prompts
```

Save instruction files:

```
apps/tala/.copilot/instructions/
├── tala-critical-gotchas.instructions.md
├── tala-architecture.instructions.md
├── tala-testing.instructions.md
├── tala-patterns.instructions.md
├── tala-framework-verification.instructions.md
└── ...
```

Save agent files:

```
apps/tala/.copilot/agents/
├── tala-discovery-planner.agent.md
├── tala-implementer.agent.md
├── tala-verifier.agent.md
└── ...
```

Save prompt files:

```
apps/tala/.copilot/prompts/
├── common-tasks.prompt.md
├── framework-guidance.prompt.md
└── ...
```

### Step 2.6: Verify Phase 2

For each app, check:

✅ Files exist:
- [ ] At least 6 instruction files (with app name prefix)
- [ ] At least 3 agent files (with app name prefix)
- [ ] At least 2 prompt files

✅ Content references actual app:
- [ ] Files mention your framework correctly
- [ ] Files reference your specific patterns
- [ ] Files describe your actual testing approach
- [ ] Gotchas match your known issues

### Step 2.7: Configure VS Code (Optional but Recommended)

Add app-specific instructions to `.vscode/settings.json`:

```json
{
  "copilot.contextualActions.instructions": [
    ".github/instructions/*.instructions.md",
    "apps/tala/.copilot/instructions/*.instructions.md"
  ]
}
```

This tells VS Code Copilot to load these instruction files automatically.

### Step 2.8: Commit Phase 2

```bash
cd /path/to/monorepo

git add apps/tala/.copilot/
git commit -m "refactor(tala): Add app-specific agent configuration from Ubod

- Add critical gotchas for Stimulus + ViewComponent + portals
- Add architecture guide for Rails + Hotwire stack
- Add testing strategy for Minitest + Capybara + Playwright
- Add Tala-specific patterns and conventions
- Add specialized agents (discovery, implementation, verification)
- Add prompt templates for common Tala tasks

Generated via: Ubod Prompt 2 (App-Specific Customization)"
```

---

## Phase 3: Create Copilot Navigation (5 minutes)

**Why this phase?** `.github/copilot-instructions.md` is the main entry point for GitHub Copilot. It acts as a navigation index that references all your instruction files, agents, and prompts. This file makes Ubod resources discoverable.

**Ubod provides a template** at `templates/copilot-instructions.template.md` that follows the framework structure.

### Step 3.1: Understand copilot-instructions.md

This file is a **high-level index** that:
- References instruction files (which auto-load via `.vscode/settings.json`)
- Documents available prompts and workflow commands
- Lists available agents
- Provides monorepo structure overview
- Lists tech stack and resources

**It's NOT where instructions live** - it just points to them.

### Step 3.2: Copy and Customize the Template

**Option A: Creating a new file (fresh Ubod deployment)**

```bash
cp projects/ubod/templates/copilot-instructions.template.md .github/copilot-instructions.md
```

Then edit `.github/copilot-instructions.md` and fill in the placeholders:
- Replace `[REPO_NAME]` with your monorepo name
- Replace `[DATE]` with current date
- Replace `[LIST_YOUR_APPS_HERE]` with your app list
- Replace `[ADD_YOUR_CUSTOM_PROMPTS_HERE]` with custom prompts (if any)
- Replace `[ADD_YOUR_CUSTOM_AGENTS_HERE]` with custom agents (if any)
- Replace `[PRIMARY_APP]` with your main app name
- Replace `[LIST_TECH_STACK_HERE]` with your tech stack
- Add any custom sections specific to your monorepo

**Option B: Updating existing file (already have copilot-instructions.md)**

Use the `/ubod-migrate-copilot-instructions` prompt to automatically add Ubod sections to your existing file.

If you already have `.github/copilot-instructions.md`, add these Ubod sections manually:

#### After "## 📂 Repository Structure", add:

```markdown
**Framework:**
- **`projects/ubod/`** - Universal AI agent kernel (git submodule)
  - Universal instructions for discovery, verification, testing
  - Meta content for maintaining ubod itself
  - App-specific customization templates
```

#### After "## 🎯 Workflow Prompts", add:

```markdown
## 🔧 Ubod Maintenance

Use these prompts to maintain the Ubod framework itself:

- **`/ubod-bootstrap-app-context`** - Set up Ubod context for a new app
- **`/ubod-create-instruction`** - Create a new instruction file
- **`/ubod-update-instruction`** - Update an existing instruction
- **`/ubod-generate-complexity-matrix`** - Generate complexity matrix for model selection

**Location:** `.github/prompts/ubod/*.prompt.md`

**Agent:** `@ubod-maintainer` - Specialized agent for maintaining Ubod framework

**Instructions:** `.github/instructions/ubod/ubod-model-recommendations.instructions.md` - Model selection guidance
```

#### In "## 🔧 Always-On Instructions" under "Universal (all files):", add:

```markdown
**Ubod Meta (framework maintenance):**
- `.github/instructions/ubod/ubod-model-recommendations.instructions.md` - Model selection
```

#### Add new "## 🤖 Available Agents" section (after "## 📚 Deep Guidance"):

```markdown
## 🤖 Available Agents

**Universal Agents (work across all contexts):**
- `@universal-discovery-planner` - Discovery and planning for any task
- `@universal-implementer` - Implementation following discovery
- `@universal-verifier` - Verification and testing

**App-Specific Agents (Tala):**
- `@tala-discovery-planner` - Tala-specific discovery
- `@tala-implementer` - Tala-specific implementation
- `@tala-verifier` - Tala-specific verification
- `@tala-ui-ux-designer` - Tala UI/UX design

**Framework Maintenance:**
- `@ubod-maintainer` - Maintain and improve Ubod framework itself

**Debugging:**
- `@debug-stuck` - Systematic debugging when stuck

**Location:** `.github/agents/*.agent.md` (root level only, no subfolders)
```

### Step 3.3: Example Updated copilot-instructions.md

Here's what your updated file should look like:

```markdown
# Your Monorepo - Repository Instructions

**Purpose:** High-level repository guidance and routing for GitHub Copilot

---

## 🚨 Critical Rules (Read First)

**Before ANY task:** The critical rules are always loaded via:
`.github/instructions/universal-critical-rules.instructions.md`

---

## 📂 Repository Structure

This is a **monorepo** with multiple apps:

- **`apps/tala/`** - Rails 8.1.1 + Hotwire + Stimulus (primary app)
- **`apps/nextjs-chat-app/`** - Next.js + React

**Framework:**
- **`projects/ubod/`** - Universal AI agent kernel (git submodule)
  - Universal instructions for discovery, verification, testing
  - Meta content for maintaining ubod itself
  - App-specific customization templates

---

## 🎯 Workflow Prompts

- **`/create-prd`** - Create PRD
- **`/review-prd`** - Review PRD
- **`/implement-phase`** - Implement PRD phase

**Location:** `.github/prompts/*.prompt.md`

---

## 🔧 Ubod Maintenance

Use these prompts to maintain the Ubod framework itself:

- **`/ubod-bootstrap-app-context`** - Set up Ubod context for a new app
- **`/ubod-create-instruction`** - Create a new instruction file
- **`/ubod-update-instruction`** - Update an existing instruction
- **`/ubod-generate-complexity-matrix`** - Generate complexity matrix

**Location:** `.github/prompts/ubod/*.prompt.md`

**Agent:** `@ubod-maintainer` - Specialized agent for maintaining Ubod

**Instructions:** `.github/instructions/ubod/ubod-model-recommendations.instructions.md`

---

## 📚 Deep Guidance (Skills)

- **`@workspace /skill discovery-methodology`** - How to discover before implementing

**Location:** `.github/skills/*/SKILL.md`

---

## 🤖 Available Agents

**Universal Agents:**
- `@universal-discovery-planner` - Discovery and planning
- `@universal-implementer` - Implementation
- `@universal-verifier` - Verification

**App-Specific Agents (Tala):**
- `@tala-discovery-planner`
- `@tala-implementer`
- `@tala-verifier`

**Framework Maintenance:**
- `@ubod-maintainer` - Maintain Ubod framework

**Debugging:**
- `@debug-stuck` - Systematic debugging

---

## 🔧 Always-On Instructions

**Universal (all files):**
- `.github/instructions/discovery-methodology.instructions.md`
- `.github/instructions/verification-checklist.instructions.md`
- `.github/instructions/runtime-verification.instructions.md`

**Ubod Meta (framework maintenance):**
- `.github/instructions/ubod/ubod-model-recommendations.instructions.md`

**Tala-specific (auto-loads for `apps/tala/**/*`):**
- `apps/tala/.copilot/instructions/tala-critical-gotchas.instructions.md`
- `apps/tala/.copilot/instructions/tala-architecture.instructions.md`

---

**Remember:** This file is a navigation index. Detailed guidance is in instruction files.
```

### Step 3.4: Verify Navigation Update

Check that your `.github/copilot-instructions.md` includes:
- [ ] Reference to `projects/ubod/` in Repository Structure
- [ ] Ubod Maintenance section with meta prompts
- [ ] `@ubod-maintainer` agent listed
- [ ] Ubod meta instructions referenced in Always-On Instructions
- [ ] Available Agents section (new)

### Step 3.5: Commit Navigation Update

```bash
cd /path/to/monorepo

git add .github/copilot-instructions.md
git commit -m "docs: Update Copilot navigation with Ubod resources

- Add Ubod submodule reference in repository structure
- Add Ubod maintenance prompts section
- Add @ubod-maintainer agent
- Add Available Agents section listing all agents
- Reference ubod meta instructions in Always-On list
- Provide clear navigation for framework maintenance

Completes: Ubod Phase 3 (Navigation Update)"
```

```bash
# Verify agents
ls .github/agents/ubod/
# Expected: ubod-maintainer.agent.md

# Verify prompts
ls .github/prompts/ubod/
# Expected: 4 prompt files with ubod- prefix

# Verify instructions
ls .github/instructions/ubod/
# Expected: ubod-model-recommendations.instructions.md
```

### Step 3.6: Test Ubod Maintenance Capability

Try using the deployed meta content:

1. **Ask about model selection:**
   - Open `.github/instructions/ubod/ubod-model-recommendations.instructions.md`
   - Verify guidance applies to your workflow

2. **Test the ubod-maintainer agent (if your tool supports custom agents):**
   - Reference the agent when making ubod changes
   - Verify it understands sanitization and placeholder requirements

3. **Try a meta prompt:**
   - Open `.github/prompts/ubod/ubod-create-instruction.prompt.md`
   - Paste into your LLM and verify it guides you through creating a new instruction

### Step 3.7: Commit Phase 3

```bash
cd /path/to/monorepo

git add .github/agents/ubod/ .github/prompts/ubod/ .github/instructions/ubod/
git commit -m "refactor: Deploy ubod meta content for self-maintenance

- Add ubod-maintainer agent for ubod updates
- Add ubod meta prompts (create, update, bootstrap, complexity matrix)
- Add ubod model recommendations instruction
- Every consuming repo can now maintain and update ubod

Source: projects/ubod/ubod-meta/"
```

---

## Phase 4: Validation (5 minutes)

### Step 4.1: Run Validation Script

```bash
cd /path/to/ubod  # Your Ubod directory
bash scripts/validate-setup.sh /path/to/monorepo
```

This checks:
- ✅ All required files exist
- ✅ Files have correct format
- ✅ Instructions reference your actual apps
- ✅ Agents are properly structured
- ✅ No broken placeholders remaining
- ✅ Meta content deployed to consuming repo

### Step 4.2: Test with Copilot

1. Open Copilot in your editor
2. Go to Copilot's settings
3. Verify it's loading your instruction files
4. Ask a discovery question: "How should I approach adding chat history persistence?"
5. Verify Copilot references your actual patterns and gotchas

### Step 4.3: Spot Check

Ask Copilot (or Claude) a task related to your app:

- **Discovery question:** "How would you approach adding [feature] to [your-app]?"
- **Expected response:** References your actual patterns, frameworks, and gotchas
- **Bad sign:** Generic advice not specific to your stack

---

## Customization & Refinement

After initial setup, you can customize Ubod to better match your team:

### Update Templates

If you discover a better pattern:

1. Edit the template in `ubod/templates/`
2. Update the {{PLACEHOLDER}} descriptions
3. Re-run Prompt 1/2 to regenerate

### Add App-Specific Variations

If one app has unique needs:

1. Create custom instruction files in `apps/{app}/.copilot/instructions/`
2. Reference them in VS Code settings
3. Copilot will load them in addition to universal instructions

### Extend to New Tools

When adding a new AI tool (e.g., Anti-Gravity):

1. Create new folder: `ubod/tools/anti-gravity/`
2. Add tool-specific README and examples
3. Create tool-specific prompt templates
4. Re-run Prompt 1/2 with tool-specific output format

---

## Troubleshooting

### Issue: LLM output is too generic

**Cause:** Not enough context about your monorepo  
**Solution:** Provide more specific examples in the prompt. Include actual code snippets.

### Issue: Generated files are too long/short

**Cause:** LLM is being too detailed or too brief  
**Solution:** Adjust prompt to say "concise" or "comprehensive" to set expectations.

### Issue: Files reference wrong app names

**Cause:** Copy-paste error or app naming inconsistency  
**Solution:** Edit the generated files manually, re-run prompt with clearer app names.

### Issue: Some frameworks are missing

**Cause:** Monorepo has apps in different folders  
**Solution:** In Prompt 1, provide complete list of ALL apps and frameworks.

### Issue: Validation script fails

**Cause:** Missing files or wrong folder structure  
**Solution:** Verify you saved files in exactly the right locations. Check validation script output.

---

## Next Steps

1. **Run Phase 1** - Universal kernel (15 min)
2. **Run Phase 2** - App-specific (15 min per app)
3. **Run Phase 3** - Deploy ubod meta content (10 min)
4. **Run Phase 4** - Validate setup (5 min)
5. **Configure** - Update VS Code settings (5 min)
6. **Test** - Ask Copilot a question, verify it uses your patterns (5 min)
7. **Iterate** - Refine based on how AI tools respond

---

## Tips for Best Results

### Tip 1: Use the Right Model for the Task

See [ubod-meta/instructions/ubod-model-recommendations.instructions.md](../ubod-meta/instructions/ubod-model-recommendations.instructions.md) for detailed guidance.

**Quick Reference:**
- **Foundational work** (initial setup, methodology): Claude Opus 4.5, GPT 5.1+, Gemini 3 Pro
- **Implementation work** (filling templates, generating code): Claude Sonnet 4.5, GPT 5
- **Review pass**: Always use a different model family than the initial generation

Multi-pass approach (generate with one model, review with another) catches more issues than single-pass.

### Tip 2: Provide Code Examples

When running prompts, include:
- Example of a ViewComponent
- Example of a Stimulus controller
- Example of a test file
- Example of a Turbo Stream

This helps LLM understand your actual patterns.

### Tip 3: Review Before Committing

Don't blindly trust LLM output:
- Read generated instruction files
- Verify frameworks and patterns are correct
- Check if gotchas match your known issues
- Fix anything that seems off before committing

### Tip 4: Iterate and Improve

First run might not be perfect:
- Generate, review, refine
- After using for a week, you'll know what to improve
- Re-run Prompt 1/2 with adjustments
- Share improvements with team

### Tip 5: Keep Ubod Local or in Submodule

Options:
1. **Clone Ubod locally** - Keep in `projects/ubod/` as separate Git repo
2. **Fork Ubod** - Make your own version with team customizations
3. **Keep reference** - Store Ubod link in team documentation

---

## Updating Ubod (After Initial Setup)

Once Ubod is deployed, use the update system to stay current.

### Version Tracking

Ubod uses semantic versioning. Your repo tracks the deployed version in `.ubod-version`:

```
version: 1.0.0
commit: a8008ca
updated: 2026-01-05
```

### Updating to Latest Version

**After pulling submodule updates:**

```bash
# Pull latest ubod submodule
cd projects/ubod && git pull origin main && cd ../..

# Run update script
cd projects/ubod && ./scripts/ubod-update.sh
```

**Update modes:**
- **Semi-automated (default):** Shows changelog, syncs files, lists prompts to run
- **Full automated:** `./scripts/ubod-update.sh --auto` (syncs everything)
- **Preview only:** `./scripts/ubod-update.sh --dry-run`

### Changelog

See [CHANGELOG.md](../CHANGELOG.md) for version history. Each entry includes:
- Human-readable description
- LLM-actionable instructions (action type, source, target)

### Architecture Reference

See [docs/ARCHITECTURE.md](ARCHITECTURE.md) for how agents and instructions work together.

---

## Updating Ubod Itself

When you need to modify or extend Ubod's instructions and prompts:

### Use Meta-Prompts

Ubod includes prompts for self-updating (in `ubod-meta/prompts/`):

1. **ubod-update-instruction.prompt.md** - Modify existing instruction files
2. **ubod-create-instruction.prompt.md** - Create new instruction files  
3. **ubod-bootstrap-app-context.prompt.md** - Set up app-specific files in consuming repos
4. **ubod-generate-complexity-matrix.prompt.md** - Create app-specific complexity signals

If you deployed Phase 3, these are also available in your consuming repo at `.github/prompts/ubod/`.

### Use the Ubod Maintainer Agent

For comprehensive ubod maintenance, use the `ubod-maintainer` agent (in `ubod-meta/agents/`):
- Understands sanitization requirements
- Knows placeholder patterns
- Follows model selection guidance

### Model Selection for Updates

- **Methodology changes** (new patterns, philosophy updates): Use Opus 4.5 / GPT 5.1+
- **Template fixes** (typos, formatting): Use Sonnet 4.5 / GPT 5
- **Always sanitize**: Remove project-specific details, use `{{PLACEHOLDER}}` syntax
- **Always review**: Use a different model family to verify changes

See [ubod-meta/instructions/ubod-model-recommendations.instructions.md](../ubod-meta/instructions/ubod-model-recommendations.instructions.md) for detailed guidance.

---

**Questions?** See [TROUBLESHOOTING.md](../docs/TROUBLESHOOTING.md)

**Ready to start?** Go to `prompts/01-setup-universal-kernel.prompt.md`

---

**Last Updated:** January 5, 2026  
**Status:** Ready for production use
