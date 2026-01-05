# Agent Templates

**Purpose:** Reusable agent definitions for consuming apps. These are generalized versions of agents that can be customized per-app.

---

## Available Agents

### Core Workflow Agents

| Agent | Purpose | Tools |
|-------|---------|-------|
| `discovery-planner.agent.md` | Evidence-first planning, maps call flows, produces implementation plan | read, search |
| `ui-ux-designer.agent.md` | UI implementation approach design, identifies pitfalls, outputs QA steps | read, search |
| `verifier.agent.md` | Runtime verification beyond "tests pass", produces QA scripts + edge cases | read, search, execute |
| `debug-stuck.agent.md` | Systematic debugging when stuck after 3+ failed attempts | read, search, execute |

### Template for Custom Agents

| File | Purpose |
|------|---------|
| `agent-template.md` | Blank template for creating new agents |

---

## Usage

### 1. Copy Agents to Your App

```bash
# From your monorepo root
mkdir -p .github/agents

# Copy the agents you need
cp projects/ubod/templates/agents/discovery-planner.agent.md .github/agents/
cp projects/ubod/templates/agents/verifier.agent.md .github/agents/
cp projects/ubod/templates/agents/ui-ux-designer.agent.md .github/agents/
cp projects/ubod/templates/agents/debug-stuck.agent.md .github/agents/
```

### 2. Customize for Your Stack

Each agent has a `CUSTOMIZATION POINTS` section. Update:

1. **Agent names** - Rename for your app (e.g., `discovery-planner` → `tala-discovery-planner`)
2. **Handoff agents** - Update agent names in handoffs
3. **Stack-specific patterns** - Add your framework's patterns and gotchas
4. **Tools** - Add/remove tools based on your tooling (e.g., Playwright MCP)

### 3. Register in VS Code Settings (optional)

If your IDE supports agent registration:

```json
{
  "github.copilot.chat.agents": [
    ".github/agents/*.agent.md"
  ]
}
```

---

## Recommended Workflow

These agents work together in a typical feature development flow:

```
┌─────────────────────────┐
│  Discovery Planner      │ ← Start here: evidence-first planning
│  (read, search)         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  UI/UX Designer         │ ← For UI work: approach + pitfalls
│  (read, search)         │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Implementer            │ ← Your app-specific implementer
│  (read, write, execute) │    (not provided - create for your app)
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│  Verifier               │ ← Runtime verification
│  (read, search, execute)│
└───────────┬─────────────┘
            │
            ▼
        ┌───┴───┐
        │ Stuck │──────────► Debug Stuck
        └───────┘              (systematic debugging)
```

---

## Creating App-Specific Agents

To create an app-specific version (e.g., Tala-specific):

1. **Copy the base agent:**
   ```bash
   cp .github/agents/discovery-planner.agent.md .github/agents/tala-discovery-planner.agent.md
   ```

2. **Update the name:**
   ```yaml
   ---
   name: Tala Discovery Planner
   ---
   ```

3. **Add app-specific details:**
   - Framework patterns (Rails, Hotwire, Stimulus, etc.)
   - Entry points to check (ViewComponents, Turbo Streams, etc.)
   - Test commands (`rails test`, etc.)
   - Common gotchas (portals, controller connections, etc.)

4. **Update handoffs:**
   - Point to your app-specific agents (e.g., `Tala Implementer`, `Tala Verifier`)

---

## Agent Design Principles

These agents follow ubod's core principles:

1. **Evidence-first** - Read actual code before proposing changes
2. **Discovery before implementation** - Plan before coding
3. **Verification beyond tests** - Check runtime behavior, not just test results
4. **Clear handoffs** - When to escalate or hand off to another agent
5. **Customization points** - Clearly marked areas for app-specific customization
