---
applyTo: "**/*.instructions.md,**/*copilot-instructions.md"
source: "https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/"
lastUpdated: 2026-01-06
---

# GitHub Copilot Custom Instructions Specification

**Purpose:** Cross-product custom instructions specification (GitHub.com, VS Code, Visual Studio, JetBrains, Eclipse)

**Source:** [GitHub Copilot Custom Instructions Documentation](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/)

**Related Spec:** See `vscode-custom-instructions-spec.instructions.md` for VS Code-specific features

---

## What Are Custom Instructions?

**Custom instructions** let you provide GitHub Copilot with guidance and preferences:
- Provide ongoing context for all your interactions
- Automatically applied (unlike prompt files which are invoked on-demand)
- Natural language format
- Multiple scopes: Personal, Repository, Organization

**Key characteristics:**
- Always active when in scope
- Combined when multiple scopes apply
- Priority: Personal > Repository > Organization
- Can be enabled/disabled per feature

---

## Instruction Scopes

### 1. Personal Instructions

**Scope:** Individual user across all repositories

**Supported platforms:** GitHub.com only (Copilot Chat, code review, coding agent)

**Use cases:**
- Personal coding style preferences
- Preferred language for responses
- Output format preferences
- Always-on preferences (e.g., "Always respond in Spanish")

**Location:** GitHub user profile settings

**Example instructions:**
```markdown
Always respond in Spanish.
Your style is a helpful colleague, minimize explanations but provide enough context.
Always provide examples in TypeScript.
```

**To configure:**
1. Go to [github.com/copilot](https://github.com/copilot)
2. Click profile picture → Personal instructions
3. Add instructions in natural language
4. Click Save

---

### 2. Repository Instructions

**Scope:** Single repository

**Supported platforms:** All (GitHub.com, VS Code, Visual Studio, JetBrains, Eclipse)

**Use cases:**
- Repository-specific context (architecture, tech stack)
- Build and test commands
- Project layout and file locations
- Coding standards for this repo
- Validation steps

**Three types of repository instructions:**

#### A. Repository-Wide Instructions

**File:** `.github/copilot-instructions.md`

**Applies to:** All requests in context of repository

**Supported features:**
- Copilot Chat (all platforms)
- Copilot code review (GitHub.com)
- Copilot coding agent (GitHub.com)
- Code completions (limited support)

**Content guidance:**
- High-level repository information (size, type, languages, frameworks)
- Build and validation commands (bootstrap, build, test, run, lint)
- Project layout and architecture
- Key file locations
- Environment setup steps
- Validation pipelines (CI/CD, GitHub workflows)

**Example structure:**
```markdown
# Repository Overview

This is a Rails 8.1 monorepo with multiple apps.

## Tech Stack

- Backend: Rails 8.1, PostgreSQL
- Frontend: Hotwire (Turbo + Stimulus), ViewComponent
- Testing: Minitest, Capybara

## Key Commands

**Setup:**
```bash
bin/setup
```

**Development server:**
```bash
bin/dev
```

**Run tests:**
```bash
bin/rails test
bin/rails test:system
```

## Project Layout

- `app/` - Main application code
  - `models/` - ActiveRecord models
  - `controllers/` - Rails controllers
  - `components/` - ViewComponents
- `test/` - Test files mirroring app structure
- `.github/` - GitHub configuration and custom instructions

## Coding Standards

- Follow Ruby Style Guide
- Use ViewComponents for reusable UI
- Write tests before implementation (TDD)
```

#### B. Path-Specific Instructions

**File:** `.github/instructions/NAME.instructions.md`

**Applies to:** Files/directories matching glob pattern in `applyTo` frontmatter

**Supported features:**
- Copilot coding agent (GitHub.com, VS Code)
- Copilot code review (GitHub.com, VS Code)

**File structure:**
```markdown
---
applyTo: "app/models/**/*.rb"
---

# Model Guidelines

For all ActiveRecord models:
- Include validations with clear error messages
- Add associations with inverse_of
- Use scopes for common queries
- Include JSDoc-style comments for methods
```

**Frontmatter properties:**

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `applyTo` | string | ✅ | Glob pattern for files to apply to |
| `excludeAgent` | string | ❌ | Exclude from `"code-review"` or `"coding-agent"` |

**Glob pattern examples:**
- `*` - All files in current directory
- `**` or `**/*` - All files in all directories
- `*.py` - All `.py` files in current directory
- `**/*.py` - All `.py` files recursively
- `src/*.py` - All `.py` files in `src` directory
- `src/**/*.py` - All `.py` files in `src` recursively
- `**/subdir/**/*.py` - All `.py` files in any `subdir` at any depth

**Multiple patterns:**
```markdown
---
applyTo: "**/*.ts,**/*.tsx"
---
```

**Exclude from agent:**
```markdown
---
applyTo: "**"
excludeAgent: "code-review"
---

These instructions only apply to coding agent, not code review.
```

#### C. Agent Instructions (AGENTS.md, CLAUDE.md, GEMINI.md)

**File:** `AGENTS.md` (or `CLAUDE.md`, `GEMINI.md` in root)

**Location:** Anywhere in repository (nearest in tree takes precedence)

**Supported features:** AI agents (OpenAI Agents, Claude, Gemini)

**Purpose:** Agent-specific instructions for external AI systems

**Note:** VS Code support requires enabling in settings (currently off by default)

**Learn more:** [openai/agents.md repository](https://github.com/openai/agents.md)

---

### 3. Organization Instructions

**Scope:** All repositories in GitHub organization

**Supported platforms:** GitHub.com only (Copilot Chat, code review, coding agent)

**Who can configure:** Organization owners

**Requires:** GitHub Copilot Business or Enterprise plan

**Use cases:**
- Organization-wide coding standards
- Security requirements
- Compliance guidelines
- Shared development practices

**To configure:**
1. Organization settings → Copilot → Custom instructions
2. Add instructions in natural language
3. Click Save changes

**Status:** Public preview (subject to change)

---

## Instruction Priority and Combination

### Priority Order

**When multiple instruction scopes apply:**

1. **Highest priority:** Personal instructions
2. **Medium priority:** Repository instructions
3. **Lowest priority:** Organization instructions

**Important:** All relevant instructions are still combined and sent to Copilot.

**Avoid conflicts:**
- Don't provide contradictory instructions across scopes
- More specific instructions (Personal) override general ones (Organization)
- Consider temporarily disabling repository instructions if concerned about quality

### Instruction Combination

**Multiple repository instructions can apply:**
- Repository-wide (`.github/copilot-instructions.md`)
- Path-specific (`.github/instructions/*.instructions.md`)
- Agent instructions (`AGENTS.md`)

**If path matches file Copilot is working on:**
- Both repository-wide AND path-specific instructions are used
- Instructions are additive, not replacement

**Example scenario:**
```
User: Personal instructions (always TypeScript)
Repository: copilot-instructions.md (use TDD)
Path-specific: app/models/*.rb (ActiveRecord guidelines)

When working on app/models/user.rb:
- Personal instructions applied
- Repository-wide instructions applied
- Path-specific instructions applied (matches glob)
- All three combined in prompt to Copilot
```

---

## How Instructions Are Used

### Visibility and Verification

**Instructions are NOT visible in chat UI**, but you can verify they're being used:

**In GitHub Copilot Chat:**
- Expand References list at top of response
- Check if `.github/copilot-instructions.md` is listed
- Click reference to open file

**In VS Code Copilot Chat:**
- Check References list in Chat view
- Look for `.github/copilot-instructions.md` reference

### Automatic Application

**Instructions automatically added to:**
- Copilot Chat prompts
- Code completion requests (limited support)
- Code review requests
- Coding agent requests

**No manual invocation needed** (unlike prompt files which use `/prompt-name`)

---

## Feature Support Matrix

### Repository-Wide Instructions (copilot-instructions.md)

| Feature | GitHub.com | VS Code | Visual Studio | JetBrains | Eclipse |
|---------|------------|---------|---------------|-----------|---------|
| Copilot Chat | ✅ | ✅ | ✅ | ✅ | ✅ |
| Code completions | Limited | Limited | Limited | Limited | Limited |
| Code review | ✅ | ❌ | ❌ | ❌ | ❌ |
| Coding agent | ✅ | ❌ | ❌ | ❌ | ❌ |

### Path-Specific Instructions (NAME.instructions.md)

| Feature | GitHub.com | VS Code | Visual Studio | JetBrains | Eclipse |
|---------|------------|---------|---------------|-----------|---------|
| Copilot Chat | ❌ | ✅ | ❌ | ❌ | ❌ |
| Code review | ✅ | ❌ | ❌ | ❌ | ❌ |
| Coding agent | ✅ | ✅ | ❌ | ❌ | ❌ |

### Personal Instructions

| Feature | GitHub.com | VS Code | Visual Studio | JetBrains | Eclipse |
|---------|------------|---------|---------------|-----------|---------|
| Copilot Chat | ✅ | ❌ | ❌ | ❌ | ❌ |
| Code review | ✅ | ❌ | ❌ | ❌ | ❌ |
| Coding agent | ✅ | ❌ | ❌ | ❌ | ❌ |

### Organization Instructions

| Feature | GitHub.com | VS Code | Visual Studio | JetBrains | Eclipse |
|---------|------------|---------|---------------|-----------|---------|
| Copilot Chat | ✅ | ❌ | ❌ | ❌ | ❌ |
| Code review | ✅ | ❌ | ❌ | ❌ | ❌ |
| Coding agent | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## Enabling and Disabling Instructions

### Copilot Chat (VS Code)

**Enabled by default**, but can be disabled:

1. Settings (Cmd+, / Ctrl+,)
2. Search: `instruction file`
3. Toggle: Code Generation: Use Instruction Files

**Applies to:** Your own use of Copilot Chat (does not affect others)

### Copilot Code Review (GitHub.com)

**Enabled by default**, but can be disabled per repository:

1. Repository Settings → Copilot → Code review
2. Toggle: "Use custom instructions when reviewing pull requests"

**Applies to:** All code reviews in this repository (affects all users)

---

## Creating Effective Instructions

### Content Guidelines

**Include:**
- Natural language instructions (Markdown format)
- Specific commands with exact syntax
- Order of operations (step-by-step)
- Error workarounds discovered
- Environment setup requirements
- Validation steps

**Whitespace:** Ignored (can write as paragraph, one per line, or separated by blank lines)

### What to Document

#### High-Level Details
- What repository does (purpose, domain)
- Type of project (web app, library, CLI tool)
- Languages, frameworks, runtimes
- Size of codebase

#### Build Instructions
- Bootstrap steps (setup, dependencies)
- Build commands (compile, bundle)
- Test commands (unit, integration, e2e)
- Run commands (dev server, production)
- Lint commands (code quality, formatting)
- Validation pipelines (CI/CD, pre-commit hooks)

**For each command:**
- Document exact syntax
- Note preconditions and postconditions
- Record timing (if slow or timeout issues)
- Document errors encountered and workarounds
- Use directive language ("always run npm install before building")

#### Project Layout
- Major architectural elements
- Relative paths to main files
- Configuration file locations (lint, test, build)
- Directory structure (where to find models, controllers, tests)
- Dependencies not obvious from file structure
- Key source files (main entry point, configuration)

#### Checks and Validation
- Pre-commit checks
- GitHub workflows
- CI/CD pipelines
- Custom validation steps

### Length Guidelines

**Repository-wide instructions:**
- **Recommended:** 2 pages maximum
- **Goal:** Reduce searching and exploration time
- **Balance:** Comprehensive but concise

**Path-specific instructions:**
- **Recommended:** 1 page per file
- **Focus:** Specific guidance for matching files
- **Avoid:** Duplicating repository-wide content

### Anti-Patterns to Avoid

❌ **Task-specific instructions**
```markdown
For ticket #123, implement user authentication using JWT.
```

✅ **General guidance**
```markdown
For authentication, use JWT tokens with 1-hour expiration.
Store tokens in httpOnly cookies, not localStorage.
```

❌ **Vague commands**
```markdown
Run the tests.
```

✅ **Specific commands**
```markdown
Run all tests:
```bash
bin/rails test
```

Run system tests only:
```bash
bin/rails test:system
```
```

❌ **Conflicting with other scopes**
```markdown
# Personal: Always use TypeScript
# Repository: Always use JavaScript
```

---

## Generating Instructions with Copilot Coding Agent

**Copilot can generate repository-wide instructions for you:**

### Using Copilot Coding Agent

1. Navigate to [github.com/copilot/agents](https://github.com/copilot/agents)
2. Select repository from dropdown
3. Use this prompt (or customize):

```markdown
Your task is to "onboard" this repository to Copilot coding agent by adding a .github/copilot-instructions.md file in the repository that contains information describing how a coding agent seeing it for the first time can work most efficiently.

You will do this task only one time per repository and doing a good job can SIGNIFICANTLY improve the quality of the agent's work, so take your time, think carefully, and search thoroughly before writing the instructions.

<Goals>
- Reduce the likelihood of a coding agent pull request getting rejected by the user due to generating code that fails the continuous integration build, fails a validation pipeline, or having misbehavior.
- Minimize bash command and build failures.
- Allow the agent to complete its task more quickly by minimizing the need for exploration using grep, find, str_replace_editor, and code search tools.
</Goals>

<Limitations>
- Instructions must be no longer than 2 pages.
- Instructions must not be task specific.
</Limitations>

<WhatToAdd>
Add high level details about the codebase:
- Summary of what repository does
- Size of repo, project type, languages, frameworks, target runtimes

Add information about how to build and validate:
- For each of bootstrap, build, test, run, lint: document sequence of steps
- Validate each command works correctly
- Document preconditions and postconditions
- Try cleaning and running commands in different orders
- Document errors observed and workarounds
- Document environment setup steps required
- Document time required for slow commands
- Use directive language ("always run npm install before building")

List key facts about layout and architecture:
- Major architectural elements with relative paths
- Location of configuration files (linting, compilation, testing)
- Checks run prior to check-in (GitHub workflows, CI builds, validation)
- Steps to replicate checks locally
- Validation steps for confidence in changes
- Dependencies not obvious from layout
- List of files in repo root
- Contents of README
- Contents of key source files
- List of next-level directories
</WhatToAdd>

<StepsToFollow>
- Perform comprehensive inventory of codebase
- Search for and view: README, CONTRIBUTING, documentation
- Search for build steps and workarounds (HACK, TODO comments)
- All scripts (build, repo setup, environment setup)
- All build and actions pipelines
- All project files
- All configuration and linting files
- For each file: ask "does agent need this to implement, build, test, validate, or demo?"
- If yes: document in detail with command order and workarounds
- Document steps agent can use to reduce exploration time
- Instruct agent to trust instructions and only search if incomplete or incorrect
</StepsToFollow>
```

4. Click Send
5. Copilot creates draft PR with instructions
6. Review and merge when ready

**Tip:** First time creating PR in repository, Copilot leaves comment with link to auto-generate instructions

---

## File Naming Conventions

### Repository-Wide

```
.github/copilot-instructions.md
```

**Required:**
- Exact filename (case-sensitive)
- `.md` extension
- Located in `.github/` directory

### Path-Specific

```
.github/instructions/NAME.instructions.md
```

**Required:**
- Located in `.github/instructions/` directory
- Ends with `.instructions.md`
- `NAME` indicates purpose (e.g., `models`, `controllers`, `react-components`)

**Examples:**
```
.github/instructions/models.instructions.md
.github/instructions/viewcomponents.instructions.md
.github/instructions/system-tests.instructions.md
```

### Agent Instructions

```
AGENTS.md
CLAUDE.md  (root only)
GEMINI.md  (root only)
```

**Location:** Anywhere in repository (nearest in tree wins for `AGENTS.md`)

---

## Validation Checklist

Before deploying custom instructions:

### File Structure
- [ ] Correct filename (case-sensitive)
- [ ] Correct location (`.github/` or `.github/instructions/`)
- [ ] Markdown format

### Path-Specific Instructions
- [ ] YAML frontmatter with `---` delimiters
- [ ] `applyTo` field with glob pattern
- [ ] `excludeAgent` field (if applicable)
- [ ] Glob pattern tested and valid

### Content Quality
- [ ] Natural language (clear, specific)
- [ ] Specific commands with exact syntax
- [ ] Build and test steps documented
- [ ] Project layout described
- [ ] Key file locations noted
- [ ] Error workarounds included
- [ ] Not task-specific
- [ ] No conflicts with other scopes

### Testing
- [ ] Instructions appear in References list
- [ ] Copilot behavior matches expectations
- [ ] Commands execute successfully
- [ ] No regressions in response quality

---

## Common Mistakes

### ❌ Wrong Filename

```
# WRONG - Won't be detected
.github/instructions.md
.github/copilot.md
copilot-instructions.md (not in .github/)
```

```
# CORRECT
.github/copilot-instructions.md
```

### ❌ Wrong Path-Specific Location

```
# WRONG - Must be in instructions folder
.github/models.instructions.md
```

```
# CORRECT
.github/instructions/models.instructions.md
```

### ❌ Missing Frontmatter for Path-Specific

```markdown
# WRONG - No applyTo field

# Model Guidelines
...
```

```markdown
# CORRECT
---
applyTo: "app/models/**/*.rb"
---

# Model Guidelines
...
```

### ❌ Invalid Glob Pattern

```markdown
---
applyTo: "models/*.rb"  # Only matches top-level models/
---
```

```markdown
---
applyTo: "**/models/**/*.rb"  # Matches models/ at any depth
---
```

### ❌ Task-Specific Instructions

```markdown
# WRONG - Too specific to one task
Implement user authentication for login page using JWT.
```

```markdown
# CORRECT - General guidance
For authentication features:
- Use JWT tokens with 1-hour expiration
- Store in httpOnly cookies
- Include refresh token flow
```

---

## Examples

### Example: Repository-Wide Instructions

```markdown
# Tala App - Copilot Instructions

## Overview

Tala is a Rails 8.1 application for document management with AI-powered RAG capabilities.

## Tech Stack

- **Backend:** Rails 8.1.1, PostgreSQL 16, Solid Queue
- **Frontend:** Hotwire (Turbo + Stimulus), ViewComponent, shadcn-rails
- **Testing:** Minitest, Capybara, Playwright
- **AI/RAG:** OpenAI API, PGVector (via Neighbor gem)

## Key Commands

### Setup
```bash
bin/setup
```

### Development
```bash
bin/dev  # Runs Rails, Vite, and background jobs via Foreman
```

### Testing
```bash
bin/rails test           # All tests
bin/rails test:system    # System tests only
```

### Database
```bash
bin/rails db:migrate
bin/rails db:seed
```

## Project Structure

- `app/models/` - ActiveRecord models with validations
- `app/controllers/` - Rails controllers (API and HTML)
- `app/components/` - ViewComponents (UI building blocks)
- `app/frontend/controllers/` - Stimulus controllers
- `test/` - Minitest tests (unit, integration, system)

## Coding Standards

- Use ViewComponents for reusable UI (not partials)
- Stimulus controllers for JavaScript interactivity
- Write tests before implementation (TDD)
- System tests verify full user workflows
- No inline styles (use Tailwind classes)

## Common Gotchas

- ViewComponents in modals may need portal containers
- Stimulus controllers must contain their targets (watch for DOM moves)
- Tailwind v4 config in `app/assets/stylesheets/application.css`
```

### Example: Path-Specific Instructions

```markdown
---
applyTo: "app/components/**/*.rb"
---

# ViewComponent Guidelines

For all ViewComponents:

1. **Structure:**
   - Component class in `app/components/`
   - Template in same directory (`.html.erb`)
   - Optional preview in `test/components/previews/`

2. **Naming:**
   - Class: `Module::ComponentComponent`
   - File: `module/component_component.rb`
   - Template: `module/component_component.html.erb`

3. **Best Practices:**
   - Use slots for flexible content areas
   - Pass data via initializer, not instance vars
   - Leverage shadcn-rails components for UI
   - Include Stimulus controller via `data-controller`
   - Test with component tests, not integration tests

4. **Example:**
```ruby
class Documents::CardComponent < ApplicationComponent
  def initialize(document:, show_actions: true)
    @document = document
    @show_actions = show_actions
  end
end
```
```

---

## Comparison: GitHub vs VS Code

| Feature | GitHub Spec | VS Code Spec | Notes |
|---------|-------------|--------------|-------|
| Repository-wide (.md) | ✅ | ✅ | Compatible |
| Path-specific (.instructions.md) | ✅ | ✅ | Compatible |
| `applyTo` glob | ✅ | ✅ | Compatible |
| `excludeAgent` | ✅ | ✅ | Compatible |
| Personal instructions | ✅ | ❌ | GitHub.com only |
| Organization instructions | ✅ | ❌ | GitHub.com only |
| VS Code settings integration | ❌ | ✅ | VS Code only |
| Workspace vs user scope | ❌ | ✅ | VS Code only |

**For maximum compatibility:**
- Use repository-wide and path-specific instructions
- Both work across GitHub.com and VS Code
- Avoid platform-specific features if targeting multiple platforms

**For GitHub.com-specific features:**
- Personal instructions (user preferences)
- Organization instructions (org-wide standards)

**For VS Code-specific features:**
- See `vscode-custom-instructions-spec.instructions.md`

---

## References

- **GitHub Copilot Custom Instructions:** https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/
- **Add Repository Instructions:** https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions
- **Add Personal Instructions:** https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-personal-instructions
- **Add Organization Instructions:** https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-organization-instructions
- **Tutorial: Your First Custom Instructions:** https://docs.github.com/en/copilot/tutorials/customization-library/custom-instructions/your-first-custom-instructions
- **About Customizing Responses:** https://docs.github.com/en/copilot/concepts/prompting/response-customization
- **Awesome GitHub Copilot Customizations:** https://github.com/github/awesome-copilot

---

**Last Updated:** 2026-01-06 (based on GitHub docs as of this date)
