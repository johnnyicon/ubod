---
applyTo: "**/*"
---

# Task Complexity Signals

**Purpose:** Help orchestrator (auto mode) and user understand task complexity for model selection

**Last Updated:** 2025-01-02

---

## How This File is Used

**This file is for POST-SPAWN self-assessment, NOT pre-spawn model selection.**

The orchestrator chooses models BEFORE spawning, so this file can't influence initial selection. Instead, it serves three purposes:

1. **AI Self-Assessment** - When stuck (looping, wrong diagnosis), I consult this file to recognize I'm outmatched and recommend escalation
2. **Escalation Recommendations** - I use these signals to suggest which model characteristics would better handle the task
3. **User Manual Override** - You can ask "What model would be better?" and I'll analyze complexity dimensions to answer

**Example Usage:**
- **AI gets stuck** → Reads this file → "I've tried 3 approaches without progress. Given the complexity signals (multi-layer + framework magic), I recommend trying a more capable model."
- **User asks** → "What model should I use?" → AI analyzes task against complexity dimensions → Provides recommendation with reasoning

---

## For the Orchestrator (Auto Mode)

**This guidance helps you choose the right model from the full ecosystem of 19+ available models.**

**Available Free Models:**
- GPT 4.1, GPT 4o, GPT 5 mini
- Grok code fast one
- Raptor mini preview

**Available Premium Models:**
- Claude: Haiku 4.5, Sonnet 4, Sonnet 4.5, Opus 4.5
- Gemini: 2.5 Pro, 3 Flash Preview, 3 Pro Preview
- GPT: 5, 5 Codex Preview, 5.1, 5.1 Codex, 5.1 Codex Max, 5.1 Codex Mini Preview, 5.2

**These are complexity signals, NOT prescriptive rules.** Use your intelligence to map task characteristics → best model choice from the full suite. Don't limit yourself - consider ALL 19+ models based on:
- Task complexity dimensions (defined below)
- Cost/speed trade-offs
- Model-specific strengths (coding, reasoning, multimodal, etc.)
- Context length requirements
- Streaming vs batch needs

---

## Complexity Dimensions

**Use these dimensions to understand task characteristics. The orchestrator will map these to appropriate model selection.**

### 1. Framework Convention Depth

**Surface Level (Simple patterns):**
- Straightforward CRUD with established patterns
- Single file change
- Clear API usage (documented, no magic)
- No implicit framework behavior

**Medium Depth (Some conventions):**
- Multiple file changes (controller + model + routes)
- Framework conventions need verification (routing, associations)
- Some magic, but well-documented

**Deep Level (Heavy framework magic):**
- Deep framework magic (portals, lifecycle hooks, implicit behavior)
- Multiple interacting conventions (routing + testing + multi-tenancy)
- Architectural decisions needed
- Novel patterns (not seen in codebase before)

---

### 2. Cross-System Integration

**Single Layer:**
- Just controller OR just model
- No background jobs, no real-time updates
- Synchronous, direct code path

**Multi-Layer (2-3 systems):**
- Controller + model + job
- Simple integrations (background job, real-time updates)
- Well-established patterns

**Complex Integration (4+ systems):**
- Routes + controller + model + job + tests + UI components
- Multiple integration points (real-time streams + JS controllers + portals)
- Asynchronous flows with edge cases
- Multi-tenancy + authorization + real-time updates

---

### 3. Diagnosis vs Implementation

**Implementation (Clear spec):**
- Root cause known (user provides exact error, line number)
- Clear implementation task
- "Write tests for X" with examples

**Investigation (Some uncertainty):**
- Need to check logs, read source
- Some uncertainty about approach
- "Fix bug where X happens sometimes"

**Deep Diagnosis (Unknown root cause):**
- Symptoms only, no clear pattern
- Looping behavior (tried 3+ approaches, all failed)
- "Tests pass but feature broken" (diagnosis mismatch)
- Need to question fundamental assumptions

---

### 4. Multi-Tenancy & Authorization

**No Multi-Tenancy:**
- Single-org context
- No authorization edge cases

**Standard Multi-Tenancy:**
- Org-scoping through `current_organization`
- Clear authorization boundaries
- Established patterns in codebase

**Complex Multi-Tenancy:**
- Nested resources across org boundaries
- Authorization through associations (verify via joins)
- Cross-org prevention + audit concerns
- Novel multi-tenancy patterns

---

### 5. Testing Strategy

**Unit Tests:**
- Model validations, service methods
- Clear assertions, happy path
- No test setup complexity

**Integration Tests:**
- Controller actions, full request cycle
- Some test setup (fixtures, factories, stubbing)
- Mix of happy path and error cases

**System/E2E Tests:**
- Browser, JavaScript, real-time updates
- Complex test isolation (multi-tenancy, stubbing controller methods)
- Edge cases (portals, async behavior, race conditions)
- Test debugging (why do tests pass but feature fails?)

---

## Red Flags: Consider More Capable Model

**If you see ANY of these, consider moving to more capable models:**

🚨 **Looping behavior** - same approach tried 3+ times without progress
🚨 **Tests pass but broken** - user reports bug still exists despite green tests
🚨 **Framework magic** - portals, lifecycle hooks, implicit conventions
🚨 **Multi-layer changes** - touching 4+ files across different layers
🚨 **Unknown root cause** - symptoms only, no clear diagnosis
🚨 **Novel pattern** - nothing similar exists in codebase
🚨 **Complex authorization** - org boundaries + associations + edge cases
🚨 **Missing documentation** - gem/API with no examples, need to read source

---

## For the User (Manual Override Triggers)

**Watch for these signals to manually switch models:**

### Switch to More Capable Model if:

- 🔴 **Looping behavior** - AI tries same approach 3+ times
- 🔴 **Wrong diagnosis** - AI fixes wrong thing repeatedly
- 🔴 **Tests pass, bug persists** - mismatch between tests and reality
- 🔴 **Random solutions** - "let me try adding a delay", "let me restart", "maybe if I..."
- 🔴 **Workarounds not solutions** - commenting out code, disabling features

### Trust Current Model if:

- 🟢 **Making progress** - each attempt gets closer to solution
- 🟢 **Clear understanding** - AI explains reasoning, shows evidence
- 🟢 **Following patterns** - AI references similar code, shows discovery
- 🟢 **Asking good questions** - clarifying requirements, not guessing

---

## Examples from Recent Sessions

### Example 1: Complex API Implementation

**Task:** Implement 3 API endpoints with tests

**Complexity Signals:**
-  Multi-layer (routes + controller + tests + model)
- 🚨 Framework conventions (routing DSL, resource naming)
- 🚨 Multi-tenancy (org-scoping in tests)
- 🚨 Missing library/dependency → need native alternative
- 🚨 Database schema mismatch (foreign key naming)

**Why Initial Model Failed:**
- Missed routing convention (resource name must match controller filename)
- Didn't check dependency file before using missing library
- Didn't verify foreign_key in schema

**Why Stronger Model Succeeded:**
- Deep framework understanding
- Verified dependencies before using
- Diagnosed ALL issues simultaneously (routes + tests + model + pagination)

**Lesson:** Multi-layer + framework conventions + multi-tenancy = needs stronger reasoning

---

### Example 2: Simple Validation Task

**Task:** Add validation to upload form

**Complexity Signals:**
- ✅ Single file (controller or model)
- ✅ Established pattern (validations exist)
- ✅ Clear spec (validate file size, type)
- ✅ No framework magic

**Why Lighter Model Would Work:**
- Straightforward validation logic
- Clear pattern to follow
- No cross-system integration
- Well-documented validation API

**Lesson:** Single file + established pattern + clear spec = many models can handle

---

## Key Insight: Complexity is Multi-Dimensional

**A task can be:**
- Simple implementation BUT complex diagnosis (needs stronger model)
- Complex implementation BUT clear pattern (lighter model OK)
- Simple logic BUT deep framework magic (needs framework expert model)

**Don't reduce to binary choices.**

**The orchestrator should:**
- Consider ALL 19+ available models
- Balance complexity against cost/speed/context
- Use model-specific strengths (coding-focused, reasoning-focused, multimodal, etc.)
- Preserve ability to choose best tool for the job

**The user should:**
- Trust orchestrator's initial selection (it has full model knowledge)
- Watch for red flags (looping, wrong diagnosis, workarounds)
- Override if red flags appear (try different model)
- Learn complexity signals over time (builds intuition)

---

## Meta-Lesson: Trust the Orchestrator

**The orchestrator has access to:**
- Full model ecosystem (19+ models)
- Model capabilities, strengths, costs
- Task context and requirements
- Historical performance data

**These signals help the orchestrator make informed choices, but don't constrain it to specific models.**

**For users:** Watch behavior, not model names. If you see looping/wrong diagnosis, suggest switching models. But let the orchestrator choose which one.

---

## App-Specific Extensions

**This file provides universal complexity dimensions. For stack-specific complexity signals, create:**

`[app]/.copilot/instructions/[app]-complexity-signals.instructions.md`

**That file should define:**
- Framework-specific complexity indicators (e.g., "React Server Components are Deep Level")
- Your stack's "framework magic" examples with specific patterns
- Real examples from your codebase that illustrate complexity levels
- Integration points specific to your architecture

**Use the generator prompt to create this file:**
`ubod/templates/prompts/generate-complexity-matrix.prompt.md`

---

**Remember:** These are signals to inform model selection, NOT rules to limit it. The orchestrator should use its full intelligence to choose from ALL available models.
