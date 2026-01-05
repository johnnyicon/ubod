# Claude Code Integration

This folder contains Claude Code-specific guidance, examples, and customization tools for Ubod.

## What's Inside

- `README.md` - This file
- `examples/` - Example conversations showing Ubod in action
- `customization-guide.md` - How to adapt Ubod for Claude's capabilities
- `system-prompt-template.md` - Template for Claude custom instructions

## Quick Start

### 1. Open Claude.ai

Go to [claude.ai](https://claude.ai)

### 2. Go to Custom Instructions

Click your profile → Settings → Custom instructions

### 3. Paste Your Instructions

Copy content from `.github/instructions/` files and paste into custom instructions section

### 4. Start a Conversation

Begin by asking: "Act as the {{agent-name}} agent. Help me..."

### 5. Provide Context

Paste relevant instruction files directly in the conversation

## Claude's Strengths

✅ **Best at:**
- Deep analysis and reasoning
- Complex problem-solving
- Research and exploration
- Comprehensive documentation
- Multi-turn conversations
- Understanding implicit requirements

## Claude's Limitations

❌ **Not ideal for:**
- Quick inline code suggestions
- IDE integration (browser-based only)
- Real-time code completion
- Immediate access to context

**Workaround:** Use Claude for research, use Copilot for implementation.

## Common Patterns

### Pattern 1: Agent Assignment

Start conversation with:
```markdown
You are the {{APP_NAME}} Discovery Planner agent.

[Paste agent definition]

Now help me approach [task] systematically.
```

### Pattern 2: Include Instructions

When relevant, paste instructions directly:
```markdown
[Paste instruction file]

Given this methodology, how should I approach [task]?
```

### Pattern 3: Multi-Turn Analysis

Keep conversation open for refinement:
```
Claude, I've read your analysis. Can you explain the gotcha about portals more?
```

### Pattern 4: Export Results

Copy Claude's responses to:
- Shared documentation
- Copilot custom instructions
- Team wiki

## Setup

### System Prompt Template

You can set up Claude with custom instructions:

1. Go to Settings → Custom instructions
2. Paste template from `system-prompt-template.md`
3. Fill in {{PLACEHOLDERS}} with your monorepo info
4. Save

Alternatively, paste agent/instruction files directly in each conversation.

## Best Practices

1. **Paste agent definitions early** - Sets context for whole conversation
2. **Reference actual code** - Show Claude your real patterns
3. **Ask about gotchas** - Claude is great at identifying edge cases
4. **Export to documentation** - Share good responses with team
5. **Use for proof-of-concept** - Claude helps verify approaches work

## Conversation Structure

### Phase 1: Briefing
```
You are the [Agent Name] agent.
[Paste agent definition]

I need help with: [task]
```

### Phase 2: Research
```
[Paste relevant instruction files]

Given these patterns, what's the best approach?
```

### Phase 3: Planning
```
Can you outline the steps I should follow?
What edge cases should I consider?
```

### Phase 4: Verification
```
I've implemented this. Did I follow the patterns correctly?
What did I miss?
```

## Troubleshooting

### Claude forgetting context

**Problem:** Claude stops referencing instruction files  
**Solution:**
- Include agent/instruction in every message if multi-turn
- Or start fresh conversation for new context

### Responses too verbose

**Problem:** Claude writes too much  
**Solution:**
- Say "Please be concise" in your prompt
- Ask for specific format: "3-step list"

### Responses too brief

**Problem:** Claude doesn't explain enough  
**Solution:**
- Ask for "comprehensive explanation"
- Ask "Why?" questions to deepen analysis

### Can't upload large files

**Problem:** File too big for Claude  
**Solution:**
- Excerpt relevant sections instead
- Paste code snippets, not entire files

## Next Steps

1. Read `customization-guide.md`
2. Try an example conversation
3. Save good responses to team docs
4. Iterate your prompts

---

**See also:**
- [Multi-Tool Support Guide](../../docs/MULTI_TOOL_SUPPORT.md)
- [Setup Guide](../../docs/SETUP_GUIDE.md)
- [PHILOSOPHY.md](../../docs/PHILOSOPHY.md) - Why Ubod works this way

**Last Updated:** January 5, 2026
