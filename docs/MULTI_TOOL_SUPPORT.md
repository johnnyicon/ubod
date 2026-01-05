# Ubod Multi-Tool Support

Ubod is designed to work with multiple AI coding tools. This document explains tool-specific capabilities, differences, and best practices.

## Supported Tools

### Tier 1: Full Support (✅ Production Ready)

#### GitHub Copilot (VS Code & JetBrains)
- **Status:** Full support, heavily tested
- **Load mechanism:** Via `.vscode/settings.json` or IDE settings
- **Capability:** Custom instructions via `contextualActions.instructions`
- **Best for:** Copilot Chat, inline completions, slash commands
- **Folder:** `ubod/github-copilot/`

#### Claude Code (Claude.ai)
- **Status:** Full support, production ready
- **Load mechanism:** Copy-paste into Claude.ai custom instructions
- **Capability:** Full reasoning with custom methodology
- **Best for:** Deep analysis, research, complex implementation tasks
- **Folder:** `ubod/claude-code/`

### Tier 2: Experimental (🚀 Early Access)

#### Anti-Gravity (v0/Cursor equivalent)
- **Status:** Placeholder for future integration
- **Expected support:** Q1 2026
- **Folder:** `ubod/anti-gravity/`

### Tier 3: Extensible (📋 Future)

Add any tool by creating a new folder with:
- Tool-specific README
- Configuration examples
- Customization guide
- Prompt templates

---

## GitHub Copilot Configuration

### What Copilot Supports

Copilot loads instructions from:

1. **Repository instructions** - `.github/instructions/*.md`
2. **Workspace settings** - `.vscode/settings.json`
3. **Custom instructions** - In VS Code Copilot Chat settings
4. **Context providers** - Reference files via `@` symbol

### Setup in 2 Steps

**Step 1:** Create `.vscode/settings.json` in your monorepo root:

```json
{
  "github.copilot.advanced": {
    "debug.overrideChatModel2": "gpt-4",
    "debug.useCommandLineTool": false
  },
  "copilot.contextualActions.instructions": [
    ".github/instructions/*.instructions.md"
  ]
}
```

**Step 2:** For app-specific instructions, override at app level:

```json
// apps/tala/.vscode/settings.json
{
  "copilot.contextualActions.instructions": [
    "../../.github/instructions/*.instructions.md",
    ".copilot/instructions/*.instructions.md"
  ]
}
```

### Best Practices for Copilot

1. **Use @symbols to reference context**
   ```
   @discovery-methodology How should I approach adding chat history?
   ```

2. **Use slash commands for tasks**
   ```
   /explain This Stimulus controller - what does it do?
   /test Write tests for this feature
   ```

3. **Reference agents explicitly**
   - Use the agent notation in chat
   - Ask Copilot to act as the "Tala Discovery Planner"

4. **Provide context through files**
   - Open relevant files in editor
   - Copilot will see them as context
   - Ask questions about what you're looking at

### Copilot Limitations

- ❌ Cannot automatically load agents (must reference manually)
- ❌ Limited to files Copilot can see in editor
- ❌ Slash commands vary by VS Code version
- ❌ Some complex reasoning tasks better in Claude

**Workaround:** Use Claude for research, copy results to Copilot for implementation.

---

## Claude Code (Claude.ai) Configuration

### What Claude Code Supports

Claude.ai can accept:

1. **Custom instructions** - Via system message
2. **Context via paste** - Copy agent/instruction content directly
3. **File uploads** - For large files (images, code)
4. **Multi-turn conversations** - Stateful, maintains context

### Setup in 2 Steps

**Step 1:** Go to Claude.ai and set custom instructions:

1. Click your profile → Settings
2. Go to "Custom instructions"
3. Add system prompt with universal instructions

**Step 2:** For each task, include relevant agent/instruction:

```markdown
You are the Tala Discovery Planner agent. Your role is to guide systematic exploration before implementation.

[Paste content from: apps/tala/.copilot/agents/tala-discovery-planner.agent.md]

Now, please help me approach [task] systematically.
```

### Best Practices for Claude Code

1. **Paste agent definition at start of conversation**
   - Sets the context for Claude's responses
   - Ensures Claude understands your methodology

2. **Include relevant instruction files**
   - Copy instruction markdown directly
   - Claude processes markdown naturally

3. **Provide code examples**
   - Paste actual code from your monorepo
   - Claude will follow your patterns

4. **Multi-turn conversations**
   - Keep conversation open for follow-ups
   - Claude remembers agent role across messages

5. **Use for research and planning**
   - Claude's strength is deep analysis
   - Best for discovery and verification phases
   - Export results, use in Copilot for implementation

### Claude Code Strengths

✅ **Best for:**
- Deep analysis and research
- Complex problem-solving
- Generating comprehensive documentation
- Understanding framework patterns
- Planning multi-step implementations

✅ **Why it excels:**
- Longer context window (100k tokens)
- Better at reasoning about tradeoffs
- Can maintain complex conversations
- Excellent at documentation generation

### Claude Code Limitations

- 🔄 Manual copy-paste (not automatic like Copilot)
- 💾 Requires saving conversation outputs yourself
- 🔌 No IDE integration yet (use browser or API)

**Workaround:** Use Claude for research, then use Copilot for coding.

---

## Recommended Workflow: Copilot + Claude

Most teams work best using **both tools together**:

### Discovery Phase → Claude
1. Ask Claude to discover patterns in your codebase
2. Ask for verification checklist
3. Copy results to documentation

```markdown
[Paste: tala-discovery-planner.agent.md + discovery-methodology.instructions.md]

Now, help me discover how to approach adding chat history persistence to Tala.
```

### Implementation Phase → Copilot
1. Open files in VS Code
2. Ask Copilot to implement while referencing instructions
3. Copilot automatically loads context from `.vscode/settings.json`

```
@discovery-methodology I want to implement the chat history feature.
Show me the step-by-step approach.
```

### Verification Phase → Both
1. Use Copilot to write tests (`/test` slash command)
2. Use Claude to verify edge cases
3. Run actual tests locally

---

## Tool Comparison Matrix

| Capability | Copilot | Claude | Notes |
|---|---|---|---|
| **Auto-load instructions** | ✅ Yes | ❌ Manual | Copilot loads via VS Code settings |
| **Multi-turn context** | ✅ Excellent | ✅ Excellent | Both maintain conversation context |
| **Code completion** | ✅ Best-in-class | ⚠️ Limited | Copilot designed for IDE completions |
| **Complex reasoning** | ✅ Good | ✅ Excellent | Claude better for analysis |
| **IDE integration** | ✅ Built-in | ❌ Browser only | Copilot deeply integrated |
| **Documentation** | ⚠️ Moderate | ✅ Excellent | Claude writes better docs |
| **Context window** | ~32k tokens | 100k+ tokens | Claude handles larger context |
| **Research phase** | ⚠️ Limited | ✅ Excellent | Use Claude for discovery |
| **Implementation** | ✅ Excellent | ⚠️ Limited | Use Copilot for coding |
| **Verification** | ✅ Good | ✅ Excellent | Use both for completeness |

---

## Setting Up Each Tool

### For GitHub Copilot Users

1. **Create `.vscode/settings.json`** with instruction paths
2. **Create `.copilot/instructions/` folder** for app-specific files
3. **Use @file syntax** to reference instructions in questions

```
@discovery-methodology How should I approach X?
```

**Key benefit:** Instructions auto-load, minimal setup required.

### For Claude Code Users

1. **Keep instructions nearby** in documentation
2. **Copy agent definition** at start of conversation
3. **Paste instructions** when relevant

```markdown
[Paste agent definition here]

Now help me with [task]...
```

**Key benefit:** Better reasoning, deeper analysis, good for research.

### For Both Tools

1. **Store everything in repo** (`.github/` and `apps/*/copilot/`)
2. **Version control your instructions** (commit changes to Git)
3. **Iterate based on usage** (refine instructions over time)

---

## Anti-Gravity & Future Tools

The `ubod/anti-gravity/` folder is a placeholder for future tool support.

When adding a new tool:

1. **Create new folder** - `ubod/{tool-name}/`
2. **Add README** explaining setup
3. **Add examples** of working configurations
4. **Add customization guide** for that tool
5. **Update this document** with tool specifics

---

## FAQ: Multi-Tool Questions

### Q: Should I use Copilot or Claude?

**A:** Ideally both:
- **Copilot** for IDE integration and implementation
- **Claude** for research, analysis, and planning

Use Copilot as your daily driver, switch to Claude when facing complex problems.

### Q: Do I need to set up all tools?

**A:** No. Start with one:
1. **If you use VS Code** - Start with Copilot
2. **If you want best reasoning** - Start with Claude
3. **For full team benefit** - Set up both

### Q: Can instructions work across all tools?

**A:** Partially:
- **Methodology** (discovery, verification) - Works everywhere
- **Specific gotchas** - Tool and framework specific
- **Templates** - Need tool-specific formatting

Ubod's universal templates handle methodology; tool folders handle specifics.

### Q: What if I add a new tool?

**A:** Create new folder in `ubod/`:
1. Copy and adapt templates
2. Create tool-specific configuration examples
3. Test with that tool
4. Document in this file
5. Share improvements back

### Q: Can I use Ubod offline?

**A:** Yes:
1. Copy instructions to your repo
2. Use local LLM (Ollama, LM Studio, etc.)
3. Run Prompt 1/2 offline
4. Save results to repo

No API calls required for core functionality.

---

## Tool-Specific Folders

### `ubod/github-copilot/`

Contains:
- `README.md` - Copilot-specific setup guide
- `examples/` - Working configuration examples
- `settings-template.json` - Settings file template
- `customization-guide.md` - How to extend for your use case

### `ubod/claude-code/`

Contains:
- `README.md` - Claude Code setup guide
- `examples/` - Example conversations
- `system-prompt-template.md` - Custom instruction template
- `customization-guide.md` - How to extend

### `ubod/anti-gravity/`

Placeholder for future:
- Tool hasn't been released yet
- Will follow same structure when ready
- Can be adapted for similar tools

---

## Extending to New Tools

When a new AI tool becomes available:

1. **Study its capabilities** - What can it load/accept?
2. **Create new folder** - `ubod/{tool-name}/`
3. **Write setup guide** - How to configure
4. **Create examples** - Working configurations
5. **Document in this file** - Add tool comparison
6. **Test with real workflows** - Does it work?
7. **Share back** - Contribute improvements

---

## Best Practices Summary

✅ **Do:**
- Use Copilot for coding (it's best at this)
- Use Claude for analysis (it's best at this)
- Keep instructions in repo (version controlled)
- Test instructions with actual tasks
- Iterate based on usage feedback

❌ **Don't:**
- Expect one tool to do everything best
- Assume all instructions work everywhere
- Skip tool-specific customization
- Forget to commit instruction updates
- Use outdated instructions

---

**Next steps:**
1. Pick your primary tool (Copilot or Claude)
2. See [SETUP_GUIDE.md](SETUP_GUIDE.md) for implementation
3. Check tool-specific folder for detailed guidance

---

**Last Updated:** January 5, 2026  
**Status:** Ready for production (Copilot, Claude), placeholder ready (Anti-Gravity)
