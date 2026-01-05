# Ubod LLM Prompts

This folder contains the two core prompts that drive Ubod generation.

## The Two-Prompt System

Ubod uses a two-phase approach to generate AI agent configurations:

### Prompt 1: Universal Kernel Setup

**File:** `01-setup-universal-kernel.prompt.md`

**Purpose:** Scan your entire monorepo and generate universal methodology that works across all apps

**Input needed:**
- Monorepo name and structure
- All apps and their frameworks
- Testing approach
- Framework-specific gotchas
- Development workflow

**Output:**
- 8-12 universal instruction files
- 3-4 agent templates
- Implementation guide

**Time:** ~15 minutes

**When to run:** First time setup, or when monorepo structure changes fundamentally

### Prompt 2: App-Specific Customization

**File:** `02-setup-app-specific.prompt.md`

**Purpose:** For each app, generate app-specific agents and instructions with deep domain expertise

**Input needed:**
- Universal kernel files (from Prompt 1)
- App name, path, framework
- Specific patterns used in this app
- App-specific gotchas and magic
- Testing approach for this app
- Common workflows in this app

**Output:**
- 6-10 app-specific instruction files
- 3-5 specialized agents for this app
- 2-4 app-specific prompt templates

**Time:** ~15 minutes per app

**When to run:** After Prompt 1, once per app, then whenever app changes significantly

---

## How to Use These Prompts

### Step 1: Get Prompt 1

1. Open `01-setup-universal-kernel.prompt.md`
2. Copy entire content
3. Go to Claude.ai (or your LLM)
4. Paste into new conversation

### Step 2: Answer Interactive Questions

The prompt will ask you about:
- Your monorepo structure
- Your apps and frameworks
- Your testing approach
- Framework magic and gotchas
- Development workflow
- Authorization patterns
- Real-time features

Provide detailed answers with examples.

### Step 3: Save Output

The LLM will generate:
- Multiple instruction files (copy each one)
- Agent templates (copy each one)
- Implementation guide (follow instructions)

Save to your monorepo's `.github/instructions/` and `.github/agents/`

### Step 4: Run Prompt 2 Per App

Repeat for each app:
1. Copy `02-setup-app-specific.prompt.md`
2. Paste into LLM (same or new conversation)
3. Paste universal kernel files as context
4. Answer app-specific questions
5. Save output to `apps/{app-name}/.copilot/`

---

## Best Practices

### For Prompt 1 (Universal Kernel)

- ✅ **Provide code examples** - Copy actual code to show patterns
- ✅ **Be specific about gotchas** - Describe with examples, not generically
- ✅ **List all apps** - Don't miss any
- ✅ **Describe your methodology** - How do you actually work?
- ❌ **Don't be too brief** - More context = better output

### For Prompt 2 (App-Specific)

- ✅ **Include Prompt 1 context** - Paste key sections from Prompt 1 output
- ✅ **Provide actual code** - Copy real examples from this app
- ✅ **Describe workflows** - What do developers actually do in this app?
- ✅ **List patterns** - Name specific gems/libraries used
- ❌ **Don't skip the universal context** - Prompt 2 needs to reference Prompt 1

---

## Customizing the Prompts

The prompts are templates too. You can customize them:

1. **Adjust tone** - Make more formal/casual
2. **Add questions** - Ask about topics specific to your stack
3. **Change output format** - Request different file structures
4. **Add constraints** - "Keep outputs concise" or "Comprehensive"

Just edit the prompt and re-run if you want different results.

---

## Troubleshooting

### LLM Output is Generic

**Cause:** Not enough specific information provided  
**Solution:** Include more code examples, specific gotchas, actual patterns

### Output Doesn't Match Your Stack

**Cause:** Framework information was unclear  
**Solution:** Re-run with clearer framework details and code examples

### Some Files Missing

**Cause:** LLM might have stopped partway through  
**Solution:** Re-run the prompt, or ask LLM to "continue" generating

### Files Too Long/Short

**Cause:** LLM verbosity varies  
**Solution:** Add "Please be concise" or "Please be comprehensive" to prompt

---

## Next Steps

Ready to start?

1. **Open** `01-setup-universal-kernel.prompt.md`
2. **Copy** the entire content
3. **Go to** Claude.ai
4. **Paste** and follow interactive questions
5. **Save** outputs to `.github/instructions/`
6. **Commit** to Git
7. **Repeat** with Prompt 2 for each app

---

See [SETUP_GUIDE.md](../docs/SETUP_GUIDE.md) for detailed step-by-step instructions.

**Last Updated:** January 5, 2026
