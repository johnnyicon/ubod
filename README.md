# Ubod - Universal AI Agent Kernel

**Ubod** (Filipino: kernel, seed) is a universal setup kernel for AI coding agents across multiple tools. It provides a reusable, template-driven architecture for deploying custom AI agent configurations to GitHub Copilot, Claude Code, Anti-Gravity, and other AI tools.

## Philosophy

Ubod solves the problem of **configuration fragmentation** across different AI coding tools. Instead of manually setting up agents, instructions, and prompts for each tool independently, Ubod:

1. **Captures methodology once** - Define discovery practices, verification checklists, and implementation patterns in tool-agnostic formats
2. **Generates tool-specific configurations** - Use templates and LLM-driven customization to automatically generate tool-specific implementations
3. **Maintains consistency** - Ensure all tools follow the same core principles while respecting tool-specific capabilities
4. **Scales to new projects** - Add new infrastructure tooling (Ubod is the first; others will follow)

## Key Concepts

### Two-Prompt System

Ubod uses a two-phase setup workflow:

**Prompt 1: Universal Kernel Setup**
- Scan your monorepo structure
- Identify apps, frameworks, patterns
- Generate universal discovery, verification, and testing methodologies
- Create shared instruction library
- Output: Foundation for all AI tools

**Prompt 2: App-Specific Customization**
- For each app in your monorepo
- Generate app-specific agents with domain expertise
- Create app-specific prompts and instructions
- Define testing and verification procedures
- Output: Complete setup for that application

### Template-Driven Generation

Ubod uses template files with `{{PLACEHOLDER}}` variables that LLMs fill in based on your monorepo's actual structure:

```
Universal Kernel Template (80% reusable)
↓
Fill with {{MONOREPO_APPS}}, {{FRAMEWORK_STACKS}}, {{TESTING_APPROACH}}
↓
Generate → Universal Instructions, Shared Agents, Methodology Docs

App-Specific Template (fill per-app)
↓
Fill with {{APP_NAME}}, {{FRAMEWORK}}, {{SPECIFIC_PATTERNS}}
↓
Generate → App-Specific Agents, Custom Instructions, Domain-Specific Prompts
```

### Multi-Tool Architecture

Ubod is extensible across multiple AI coding tools:

```
ubod/
├── docs/                      # Shared philosophy & guides
├── templates/                 # Template library (tool-agnostic)
│   ├── instructions/          # Instruction templates
│   ├── agents/                # Agent definition templates
│   ├── prompts/               # Prompt templates
│   └── config/                # Configuration templates
├── prompts/                   # LLM prompts for generation
│   ├── 01-setup-universal-kernel.prompt.md
│   └── 02-setup-app-specific.prompt.md
└── tools/                     # Tool-specific implementations
    ├── github-copilot/        # Copilot-specific patterns
    ├── claude-code/           # Claude Code-specific patterns
    └── anti-gravity/          # Anti-Gravity patterns (extensible)
```

## Quick Start

### Prerequisites

- Your monorepo (e.g., bathala-kaluluwa)
- Access to an LLM (Claude, ChatGPT, etc.)
- 30 minutes for first-time setup

### Setup Process

#### Phase 1: Generate Universal Kernel (15 minutes)

1. Copy the content from `prompts/01-setup-universal-kernel.prompt.md`
2. Paste into your LLM (Claude recommended for best results)
3. Provide your monorepo structure (the prompt will ask)
4. LLM generates:
   - Universal instruction library
   - Shared methodology documents
   - Discovery, verification, and testing frameworks
5. Save outputs to your monorepo's `.github/instructions/` folder

**Example output structure after Phase 1:**
```
.github/
├── instructions/
│   ├── discovery-methodology.instructions.md
│   ├── universal-verification-checklist.md
│   ├── task-completion-verification.md
│   └── ... (universal patterns)
```

#### Phase 2: Generate App-Specific Setup (15 minutes per app)

1. Copy the content from `prompts/02-setup-app-specific.prompt.md`
2. Paste into your LLM with the Universal Kernel output
3. For each app in your monorepo, provide:
   - App name and path
   - Framework stack (Rails, Next.js, etc.)
   - Specific domain (chat, documents, etc.)
4. LLM generates:
   - App-specific agents with deep domain expertise
   - App-specific instructions for common patterns
   - App-specific prompts for faster workflows
5. Save outputs to your app's `.copilot/` or tool-specific folder

**Example output structure after Phase 2:**
```
apps/tala/.copilot/
├── instructions/
│   ├── tala-critical-gotchas.instructions.md
│   ├── tala-architecture.md
│   ├── tala-testing.md
│   └── ...
├── agents/
│   ├── tala-discovery-planner.agent.md
│   ├── tala-implementer.agent.md
│   └── ...
```

## How Ubod Works

### 1. Template Extraction

Ubod's templates are pre-built, tool-agnostic patterns that have worked well:

- **Instruction templates** - Universal patterns for discovery, verification, testing
- **Agent templates** - Patterns for specialized agents (discovery, implementation, verification)
- **Prompt templates** - Reusable prompt structures for common tasks
- **Config templates** - VS Code settings, tool configurations, etc.

### 2. LLM-Driven Customization

When you run Prompt 1 and Prompt 2, the LLM:

1. **Reads your actual monorepo** - Examines folder structures, file patterns, existing frameworks
2. **Fills in templates** - Replaces `{{PLACEHOLDERS}}` with your actual values
3. **Generates outputs** - Creates tool-specific files ready to use
4. **Maintains consistency** - Uses the same methodology across all generated files

### 3. Tool-Specific Adaptation

Each tool folder under `tools/` contains:

- **README.md** - Tool-specific setup instructions
- **examples/** - Minimal working examples
- **customization-guide.md** - How to adapt Ubod for that tool

Some tools may also include templates (for example, a `settings-template.json`).

## Template Variables Reference

### Universal Kernel (Prompt 1)

```
{{MONOREPO_APPS}}                    # List of apps with their frameworks
{{MONOREPO_STRUCTURE}}               # Folder hierarchy
{{FRAMEWORK_STACKS}}                 # Rails, Next.js, etc.
{{TESTING_APPROACH}}                 # Minitest, Jest, etc.
{{SOURCE_CONTROL_SETUP}}             # Git worktrees, submodules, etc.
{{AUTHORIZATION_PATTERN}}            # Multi-tenancy, org-scoping, etc.
{{DEVELOPMENT_WORKFLOW}}             # How developers work in this repo
{{COMMON_PATTERNS}}                  # Recurring implementation patterns
{{FRAMEWORK_SPECIFIC_GOTCHAS}}       # Framework magic and edge cases
```

### App-Specific (Prompt 2)

```
{{APP_NAME}}                         # e.g., "Tala", "Next.js Chat"
{{APP_FRAMEWORK}}                    # e.g., "Rails 8.1.1 + Hotwire"
{{APP_DOMAIN}}                       # e.g., "Chat AI Agent"
{{APP_PATTERNS}}                     # ViewComponent, Stimulus, etc.
{{APP_TESTING_PATTERNS}}             # System tests, integration tests
{{APP_SPECIFIC_GOTCHAS}}             # App-specific edge cases
{{APP_VERIFICATION_CHECKLIST}}       # How to verify things work
{{APP_AGENTS_NEEDED}}                # What specialized agents help most
```

## Folder Structure

```
ubod/
├── README.md                              # This file
├── LICENSE                                # MIT License
├── .gitignore                             # Standard ignores
│
├── docs/                                  # Documentation
│   ├── PHILOSOPHY.md                      # Core principles
│   ├── SETUP_GUIDE.md                     # Step-by-step setup
│   ├── MULTI_TOOL_SUPPORT.md              # Tool-specific guidance
│
├── templates/                             # Template library
│   ├── instructions/                      # Instruction templates
│   │   ├── universal/                     # Universal patterns
│   │   │   ├── discovery-methodology.md
│   │   │   ├── verification-checklist.md
│   │   │   ├── testing-strategy.md
│   │   │   └── ...
│   │   └── app-specific/                  # Per-app patterns
│   │       ├── critical-gotchas.md
│   │       ├── architecture-guide.md
│   │       └── ...
│   ├── agents/                            # Agent definition templates
│   │   ├── discovery-planner.agent.md
│   │   ├── implementer.agent.md
│   │   ├── verifier.agent.md
│   │   └── ...
│   ├── prompts/                           # Prompt templates
│   │   ├── analysis-task.prompt.md
│   │   ├── implementation-task.prompt.md
│   │   └── ...
│   └── config/                            # Configuration templates
│       ├── ubod-config-template.json
│       └── ...
│
├── prompts/                               # LLM prompts for generation
│   ├── 01-setup-universal-kernel.prompt.md
│   ├── 02-setup-app-specific.prompt.md
│   └── README.md
│
├── scripts/                               # Validation & utility scripts
│   ├── validate-setup.sh                  # Verify setup completeness
│   ├── README.md
│   └── ...
│
└── tools/                                 # Tool-specific modules
   ├── github-copilot/
   ├── claude-code/
   └── anti-gravity/
```

## What's Included

### Core Documentation
- **PHILOSOPHY.md** - Core principles and vision
- **SETUP_GUIDE.md** - Step-by-step implementation walkthrough
- **MULTI_TOOL_SUPPORT.md** - Tool-specific guidance and differences

### Template Library
- 10+ universal instruction templates (discovery, verification, testing, patterns)
- 4 agent templates (discovery planner, implementer, verifier, custom)
- 5+ prompt templates for common tasks
- Configuration templates for multiple tools

### LLM Prompts
- **Prompt 1** - Universal kernel generation (50-100 lines of guided instructions)
- **Prompt 2** - App-specific customization (40-80 lines of guided instructions)

### Tool-Specific Modules
- **GitHub Copilot** - Settings examples, capability verification
- **Claude Code** - Configuration guides, best practices
- **Anti-Gravity** - Placeholder for future tool support

### Validation Scripts
- `validate-setup.sh` - Verify all required files exist
- Template validation - Check for required placeholders
- Cross-tool consistency checks

## Design Principles

1. **Tool-Agnostic First** - Templates work across tools; tool-specific variations come later
2. **Template-Driven** - Use `{{PLACEHOLDERS}}` to keep templates reusable
3. **LLM-Powered** - Let LLMs fill in templates based on actual monorepo structure
4. **Methodology > Configuration** - Focus on HOW to work, not just WHAT to configure
5. **Extensible** - Easy to add new tools (anti-gravity/, custom-tool/, etc.)
6. **Copy-Paste Friendly** - Prompts designed to work with any LLM via copy-paste

## Next Steps

1. **Read PHILOSOPHY.md** - Understand core vision and principles
2. **Read SETUP_GUIDE.md** - Learn the exact steps to set up
3. **Run Prompt 1** - Generate universal kernel for your monorepo
4. **Run Prompt 2** - Generate app-specific customizations
5. **Validate** - Run `scripts/validate-setup.sh` to verify completeness
6. **Iterate** - Customize templates as you learn what works best for your team

## Using Ubod as a Submodule

If Ubod is included as a submodule (for example, at `projects/ubod/`), make sure you clone and initialize submodules:

```bash
git clone --recurse-submodules <your-monorepo-repo-url>

# If you already cloned:
git submodule update --init --recursive
```

## Contributing

Ubod is designed to evolve. If you:

- Create a new instruction template that works well
- Discover a pattern that should be shared
- Add support for a new tool

Please contribute back so others can benefit.

## License

MIT - Use freely, modify as needed, share improvements

## Questions?

See [docs/SETUP_GUIDE.md](docs/SETUP_GUIDE.md) for setup details or create an issue.

---

**Last Updated:** January 5, 2026  
**Status:** Version 1.0 - Ready for production use  
**Maintained By:** Bathala Kaluluwa Team
