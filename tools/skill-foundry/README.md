# Skill-Foundry - Reusable Skills Authoring Tool

**Part of:** [Ubod](../../README.md) - Universal AI Coding Kernel

**Purpose:** Create portable, reusable skills for AI coding

---

## What is Skill-Foundry?

**Skill-Foundry is a tool (not a skill itself)** that provides infrastructure for creating portable Agent Skills that work across:
- VS Code Custom Skills (invoke via `@workspace /skill name`)
- Claude Code (copy skill content directly into chat)
- Any future skill-supporting tool

### What's Included

```
tools/skill-foundry/
├── skill-foundry/             # The meta-skill (for creating skills)
│   ├── SKILL.md               # Main skill definition
│   ├── scripts/               # Scaffold and validation scripts
│   ├── references/            # Best practices and guides
│   └── templates/             # Skill templates
├── examples/                  # Example skills
│   └── hello-world/           # Minimal working example
├── README.md                  # This file
└── INSTALL.md                 # Installation guide
```

---

## What is a Skill?

A **skill** is a self-contained bundle of:
- Capabilities definition (what the skill does)
- Reference documentation (how to use it)
- Scripts (automation, validation)
- Templates (for generating new instances)

### Skill vs. Tool vs. Meta-Skill

This can be confusing, so let's clarify:

| Term | What It Is | Example |
|------|------------|---------|
| **Tool** | Infrastructure for creating skills | skill-foundry (this directory) |
| **Meta-Skill** | A skill that creates other skills | `skill-foundry/SKILL.md` |
| **Custom Skill** | A skill you create | `my-api-tests/SKILL.md` |

**Flow:**
1. Install skill-foundry TOOL (this directory)
2. Use META-SKILL to create skills (`@workspace /skill skill-foundry`)
3. Use CUSTOM SKILLS you created (`@workspace /skill my-api-tests`)

---

## Installation

### Option 1: Via Ubod (Recommended)

```bash
cd your-workspace
git submodule add https://github.com/johnnyicon/ubod.git projects/ubod
./projects/ubod/scripts/install.sh --with-skill-foundry
```

This installs:
- skill-foundry meta-skill to `.github/skills/skill-foundry/`
- Validation and scaffolding scripts
- Reference documentation
- Example skills

### Option 2: Standalone

```bash
cd your-workspace/.github/skills
cp -r path/to/ubod/tools/skill-foundry/skill-foundry .
```

See [INSTALL.md](INSTALL.md) for detailed installation options.

---

## Creating a New Skill

### Option 1: Via VS Code Custom Skills (Recommended)

```
@workspace /skill skill-foundry
```

Then follow the conversational flow. The skill-foundry meta-skill will guide you through:
1. What does your skill do?
2. When should it be used?
3. What commands does it provide?
4. What are the boundaries?

### Option 2: Via Command-Line

```bash
cd .github/skills/skill-foundry
python scripts/scaffold.py my-skill \
  --description "Does X when Y"
```

### Option 3: Manual

1. Read [QUICK_START.md](skill-foundry/references/QUICK_START.md)
2. Copy `examples/hello-world/SKILL.md` as a template
3. Fill in frontmatter (name, description)
4. Write body sections
5. Validate: `python scripts/validate.py my-skill/SKILL.md`

---

## Quick Reference

### Essential Reading

- [QUICK_START.md](skill-foundry/references/QUICK_START.md) - Create your first skill in 5 minutes
- [BEST_PRACTICES.md](skill-foundry/references/BEST_PRACTICES.md) - Distilled from Anthropic docs
- [SKILL_ANATOMY.md](skill-foundry/references/SKILL_ANATOMY.md) - Structure and progressive disclosure
- [PORTABILITY.md](skill-foundry/references/PORTABILITY.md) - Cross-platform compatibility

### Example Skills

- [hello-world](examples/hello-world/) - Minimal working example
- [discovery-methodology](../../../.github/skills/discovery-methodology/) - Real-world example (if available)

### Scripts

```bash
# Validate a skill
python .github/skills/skill-foundry/scripts/validate.py path/to/skill/SKILL.md

# Scaffold a new skill
python .github/skills/skill-foundry/scripts/scaffold.py my-skill "Description"

# Validate all skills in workspace
./projects/ubod/scripts/validate-all.sh  # (if Ubod is installed)
```

---

## Key Concepts

### Progressive Disclosure

Skills load in three levels:

1. **Level 1 (Discovery)** - Only `name` and `description` (always loaded)
2. **Level 2 (Activation)** - Full `SKILL.md` body (loaded when relevant)
3. **Level 3 (Deep Dive)** - `references/`, `scripts/` (loaded on-demand)

**Design implication:** Keep SKILL.md lean, move details to `references/`.

### Portability

To work across VS Code and Claude Code:
- Use only standard frontmatter: `name`, `description`, `license`, `requirements`, `metadata`
- Agent-specific hints go in `metadata` namespace
- Relative paths only

See [PORTABILITY.md](skill-foundry/references/PORTABILITY.md) for details.

### Token Efficiency

| Content | Token Cost |
|---------|------------|
| Skill metadata (name, description) | Always |
| SKILL.md body | Only when skill is used |
| Reference files | Only when read |
| Script code | Never (only output) |

**Scripts are maximally efficient** - their code never enters context, only their output does.

---

## Workflow

### 1. Create

```
@workspace /skill skill-foundry
"I need a skill for running API tests with pytest"
```

### 2. Test

```
@workspace /skill api-tests
"Test the /users endpoint"
```

### 3. Refine

Based on how Claude uses the skill:
- Add examples if it misunderstands
- Clarify boundaries if it does wrong things
- Add commands if it asks how to do things

### 4. Share (Optional)

Skills are just directories with markdown files. Share by:
- Committing to your repo
- Creating a git submodule
- Publishing as a package
- Copying to other projects

---

## Why Skill-Foundry?

### Before Skill-Foundry

You'd write agent instructions, prompts, or CLAUDE.md files, but:
- No standard structure
- Hard to share across tools
- Hard to maintain as complexity grows
- No validation or scaffolding

### With Skill-Foundry

- **Standard structure** - Follows Agent Skills spec
- **Cross-tool portability** - Works in VS Code and Claude Code
- **Progressive disclosure** - Efficient token usage
- **Validation** - Catch errors before deployment
- **Scaffolding** - Generate structure quickly
- **Best practices** - Distilled from Anthropic and GitHub

---

## Source Attribution

Skill-Foundry distills best practices from:

- [Anthropic Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Agent Skills Standard](https://agentskills.io)
- [VS Code Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [GitHub's 2500+ Agents Analysis](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)

---

## Support & Contribution

**Part of Ubod:** This tool is maintained as part of the Ubod universal AI coding kernel.

- **Issues:** Report in Ubod repository
- **Documentation:** See Ubod docs for integration guidance
- **Updates:** Pull Ubod submodule for latest version

---

## License

MIT (same as Ubod)
