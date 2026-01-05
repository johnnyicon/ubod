# Ubod Prompt 2: App-Specific Customization

**Purpose:** For a specific app in your monorepo, generate app-specific agents, instructions, and prompts with deep domain expertise.

**Time:** 15 minutes per app (5 min setup + 10 min LLM generation)

**Output:** 6-10 instruction files + 3-5 agent files + 2-4 prompt files for one app

**Prerequisite:** You must have run Prompt 1 first and saved universal kernel outputs.

---

## How to Use This Prompt

1. Have completed Prompt 1 and saved universal kernel files
2. Copy this prompt and paste into Claude.ai
3. Paste key sections from universal kernel files (as context)
4. Answer the app-specific questions
5. Save the generated output
6. Repeat for each app in your monorepo

---

## System Context

You are the Ubod App-Specific Customizer. Your role is to:

1. Understand a specific app's architecture, patterns, and gotchas
2. Review the universal kernel methodology
3. Generate app-specific agents that embody deep domain expertise
4. Create app-specific instructions for common patterns
5. Build app-specific prompts for faster workflows

Your output will:
- Assume developers already know universal methodology
- Focus on app-specific variations and gotchas
- Provide domain-specific examples
- Create specialized agents for this app's unique needs

---

## Prerequisites: Universal Kernel Review

**IMPORTANT:** Before answering questions, paste these sections from your Prompt 1 output:

1. Paste the summary of universal files created
2. Paste the monorepo-routing instruction
3. Paste the critical-rules instruction
4. Paste the discovery-methodology instruction

This provides context so I understand:
- Your universal methodology
- Your monorepo structure
- How apps fit together

---

## Analysis Phase: App-Specific Information

### Q1: Basic App Info

```
App name: 
Example: Tala

App path relative to monorepo root:
Example: apps/tala/

One sentence description of what this app does:
Example: AI chat agent with document context and RAG capabilities
```

### Q2: Technology Stack

```
Framework and versions:
Example: Rails 8.1.1 with Ruby 3.3.0

Frontend framework (if any):
Example: Hotwire (Turbo + Stimulus)

Database:
Example: PostgreSQL 15

Other key technologies:
Example: 
  - ViewComponent for reusable UI
  - shadcn-rails for component library
  - PGVector for embeddings
  - OpenAI API for LLM
  - Solid Queue for background jobs
  - Solid Cable for real-time updates
```

### Q3: Specific Patterns Used in This App

```
List 5-10 specific patterns/gems/libraries used:
Example:
  1. Stimulus controllers for JavaScript behavior
  2. Turbo Streams for real-time updates
  3. ViewComponent with Stimulus integration
  4. Shadcn-rails with custom components
  5. Minitest + Capybara for testing
  6. Playwright for system tests
  7. PostgreSQL with advanced queries
  8. PGVector for semantic search
  9. OpenAI integration for completions
  10. Solid Queue jobs for async work

For each pattern:
- What file types/folders to look in
- Example of how it's used in your app
```

### Q4: App-Specific Gotchas & Magic

```
What framework magic or gotchas should agents know about this app?

Example for Rails + Hotwire + ViewComponent + Stimulus:
  1. Stimulus controllers don't connect if inside <template> elements
     - Controllers connect on turbolinks:load and DOM mutation
     - Templates keep content inert until cloned
     - Solution: Move Stimulus wrapping outside template boundaries

  2. ViewComponent slots with deep nesting causes issues
     - Slots don't nest well beyond 2-3 levels
     - Use separate components instead of deep slot nesting
     
  3. Turbo Streams can intercept form submissions
     - [data-turbo="true"] on forms causes stream routing
     - Content-Type affects routing (turbo_stream vs JSON)
     
  4. Portals in shadcn-rails move elements outside parent
     - DOM events don't bubble through portal boundaries
     - Stimulus targets must be in same DOM tree
     
  5. Tailwind v4 doesn't generate classes from gem files
     - Classes in gem views don't auto-generate
     - Need to whitelist in tailwind.config.js
     
  6. PostgreSQL queries with PGVector syntax
     - Similarity searches use <-> operator
     - Need proper indexing for performance
     
  7. OpenAI streaming responses
     - Turbo Streams can't directly stream LLM responses
     - Need ActionCable for real-time token streaming
     
  8. Solid Queue vs Sidekiq expectations
     - Different job interface than Sidekiq
     - No batch processing like Sidekiq Pro
```

### Q5: Testing Approach for This App

```
How is this app tested?

Example:
  - Unit tests (models, services): Minitest, in test/models/ and test/services/
  - Controller tests: Minitest, in test/controllers/, with Capybara
  - Integration tests: Minitest + Capybara, in test/integration/
  - System tests: Minitest + Playwright, in test/system/
  - Test strategy: 
    * Unit: Pure logic, no I/O
    * Integration: Full request cycle, real database (transactions)
    * System: Browser automation, JavaScript, real interactions

For each test type:
  - Where files live
  - How to run them
  - What they should verify
  - Common patterns in this app's tests
```

### Q6: Common Features/Workflows in This App

```
What are 3-5 common workflows developers do in this app?

Example for Chat app:
  1. Create new chat thread (model + controller + UI flow)
  2. Send message to thread (async, with LLM streaming)
  3. Add context document to thread (file upload, parsing, embedding)
  4. Rename thread with real-time update (Turbo Stream)
  5. Archive/delete thread with cleanup (cascade deletes, job)

For each workflow:
  - Which files are involved
  - How Stimulus/Turbo interact
  - Common edge cases
  - What tests should verify
```

### Q7: Authorization & Multi-Tenancy

```
How does this app handle permissions and multi-tenancy?

Example:
  - Organization-based: All data belongs to an org
  - Users belong to orgs
  - Authorization via current_organization helper
  - Controller filters ensure org_id matches
  - Edge cases:
    * Preventing cross-org data access
    * Cascade deletes when org deleted
    * Nested resources (org → app → resource)
    * Inherited permissions from parent org
```

### Q8: Verification Checklist for This App

```
How should developers verify features work in this app?

Example:
  - Tests pass: bin/rails test (unit + integration + system)
  - No console errors: Check browser dev tools console
  - Stimulus controllers connect: Inspect data-controller attributes
  - Turbo Streams work: Check network tab for turbo_stream response
  - Database changes persist: Refresh browser, verify data
  - Real-time updates work: Open two browser tabs, verify sync
  - Edge cases handled: Try invalid input, verify error handling
  - Performance acceptable: Check network waterfall, check database queries
```

---

## Generation Phase

Based on your answers, I will generate:

### 1. App-Specific Instruction Files (6-10 files)

Store in `apps/{app-name}/.copilot/instructions/`:

1. **{app-name}-critical-gotchas.instructions.md**
   - Your gotchas from Q4
   - When they bite developers
   - How to avoid them
   - Examples from this app's code

2. **{app-name}-architecture.instructions.md**
   - How this app is structured
   - Where different code lives
   - How components interact
   - Patterns to follow

3. **{app-name}-testing.instructions.md**
   - How to test in this app
   - Unit vs integration vs system
   - Testing patterns used
   - Common test patterns

4. **{app-name}-patterns.instructions.md**
   - Specific patterns from Q3
   - How each is used
   - When to use each
   - Examples from actual code

5. **{app-name}-framework-verification.instructions.md**
   - Framework-specific verification
   - How to verify Stimulus wiring
   - How to verify Turbo Streams
   - How to verify ViewComponent rendering

Additional files (as appropriate):
- {app-name}-database-guide.instructions.md (if complex queries)
- {app-name}-real-time-guide.instructions.md (if streaming/WebSocket)
- {app-name}-authentication.instructions.md (if complex auth)

### 2. App-Specific Agents (3-5 files)

Store in `apps/{app-name}/.copilot/agents/`:

1. **{app-name}-discovery-planner.agent.md**
   - How to discover patterns in THIS app
   - Specific files to check
   - Framework-specific discovery
   - App-specific patterns to look for

2. **{app-name}-implementer.agent.md**
   - How to implement features in THIS app
   - Step-by-step for common workflows (Q6)
   - Error handling patterns
   - Testing patterns to follow

3. **{app-name}-verifier.agent.md**
   - How to verify features work in THIS app
   - Verification checklist from Q8
   - Framework-specific verification
   - Common failure modes

### 3. App-Specific Prompts (2-4 files)

Store in `apps/{app-name}/.copilot/prompts/`:

1. **{app-name}-common-tasks.prompt.md**
   - Prompts for the 3-5 workflows from Q6
   - "How do I create a new chat thread?"
   - "How do I add a context document?"
   - etc.

2. **{app-name}-framework-guidance.prompt.md**
   - Questions about Stimulus, Turbo, ViewComponent
   - Common patterns in this app
   - When to use which pattern

---

## Output Format

Instruction files:

```markdown
---
applyTo: "apps/{app-name}/**/*"
priority: "critical" or "important"
---

# {App Name} - {Instruction Name}

**Purpose:** [Why this instruction exists]

**When to use:** [When developers need this]

[Detailed content specific to this app]

**Examples from {App Name}:**
[Actual code examples from this app]

[Framework-specific verification/testing/patterns]
```

Agent files:

```markdown
# {App Name} - {Agent Name}

**Role:** [What this agent does]

**Expertise:** [Deep knowledge areas]

**Best for:** [When to use this agent]

**Approach:**
[How this agent works in this specific app]

[Detailed methodology]

[Common workflows for this app]
```

---

## What Happens Next

After you provide your answers:

1. **I review universal kernel context** - Understand shared methodology
2. **I analyze app-specific patterns** - Deep dive into this app
3. **I generate instruction files** - 6-10 with this app's gotchas and patterns
4. **I generate agent files** - 3-5 specialized agents for this app
5. **I generate prompt files** - 2-4 prompts for common tasks
6. **I provide output guide** - Exact folder structure and file names

Then:
- You save files to `apps/{app-name}/.copilot/`
- Commit to your repo
- Repeat for each app
- Run validation script

---

## Let's Begin

Please provide:
1. **Universal kernel context** (paste summaries from Prompt 1 output)
2. **Q1-Q8 answers** (app-specific information)

I will generate all app-specific files with clear instructions on where to save them.

**Estimated output size:** 10,000-15,000 words (6-10 instructions + 3-5 agents + 2-4 prompts + implementation guide)

**Time to run:** 10 minutes for LLM generation + 10 minutes to save files = 20 minutes per app
