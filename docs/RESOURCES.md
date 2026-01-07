# Ubod Resources

External references and inspiration for Ubod's design and implementation.

---

## Agent Design & Best Practices

### Awesome Copilot (Community Curated)
**Source:** [awesome-copilot on GitHub](https://github.com/jmatthiesen/awesome-copilot)  
**Date Referenced:** January 7, 2026  
**Key Insights:**
- Community-curated collection of GitHub Copilot resources
- Examples of agent files, prompts, and custom instructions from real projects
- Links to official documentation, blog posts, and tutorials
- Categories: Agents, Extensions, Prompts, Workspaces, Learning Resources
- Active curation of best practices and patterns

**What We Adopted:**
- Reference for discovering community patterns and examples
- Validation that our agent structure aligns with community standards
- Source for learning about new Copilot features and capabilities

**What We Didn't Adopt:**
- Specific agent implementations (we create our own universal templates)
- VS Code-only patterns (we prioritize cross-tool compatibility)

**Ubod Usage:**
- Consulted when updating agent schemas and best practices
- Referenced in RESOURCES.md to track external influences on framework design

---

### How to Write a Great agents.md (GitHub, 2025)
**Source:** [GitHub Blog](https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/)  
**Date Referenced:** January 5, 2026  
**Key Insights:**
- Analysis of 2,500+ repositories with agent files
- Best practices for agent metadata structure
- Importance of executable commands early in agent files
- Three-tier boundary system (✅ Always / ⚠️ Ask first / 🚫 Never)
- Code examples more effective than explanations
- Six core areas: commands, testing, structure, style, git workflow, boundaries

**What We Adopted:**
- COMMANDS section in agent templates (executable commands with flags)
- BOUNDARIES section with emoji markers (✅⚠️🚫)
- Visual formatting for clarity

**What We Didn't Adopt (and why):**
- Self-contained agents - Ubod's distributed architecture (instructions + thin agents) is more maintainable for monorepos
- Embedding project knowledge in agents - We generate `ARCHITECTURE.md` instead
- Duplicating rules across agents - Instructions via `applyTo` scope provide depth without duplication

---

## GitHub Copilot & VS Code Configuration

### Custom Agents Configuration (GitHub Docs)
**Source:** [GitHub Copilot Custom Agents Reference](https://docs.github.com/en/copilot/reference/custom-agents-configuration)  
**Date Referenced:** January 6, 2026  
**Key Topics:**
- YAML frontmatter properties (description, name, target, tools, infer, mcp-servers)
- Tool aliases (execute, read, edit, search, agent, web, todo)
- MCP server configuration (organization/enterprise level)
- Processing rules and versioning (Git commit SHA-based)
- Cross-product compatibility (VS Code, GitHub.com, Visual Studio)

**What We Adopted:**
- Official tool aliases specification (`read`, `edit`, `search`, `execute`)
- Tool priority and MCP server processing order
- Cross-product compatibility awareness (ignored properties for compatibility)
- Versioning via Git commit SHA

**Ubod Implementation:**
- Created `ubod-meta/instructions/github-custom-agent-spec.instructions.md`
- Updated all agent templates to match official spec
- Migration guide: `ubod-meta/migrations/2026-01-06-vscode-agent-schema-fix.md`

---

#### 1.2. GitHub Copilot Custom Instructions (Cross-Product)

**Source:** [GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/)
**Date Referenced:** 2026-01-06

**Key Topics Covered:**
- Three instruction scopes (Personal, Repository, Organization)
- Repository-wide instructions (`.github/copilot-instructions.md`)
- Path-specific instructions (`.github/instructions/*.instructions.md`)
- Agent instructions (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`)
- Instruction priority and combination (Personal > Repository > Organization)
- Feature support matrix (GitHub.com, VS Code, Visual Studio, JetBrains, Eclipse)
- Glob patterns for `applyTo` field
- `excludeAgent` property for selective application

**What We Adopted:**
- Path-specific instructions with `applyTo` glob patterns
- Repository-wide instructions for general context
- Glob pattern syntax (`**/*.rb`, `src/**/*.ts`, etc.)
- `excludeAgent` for agent-specific instructions
- Natural language format (Markdown)

**What We Didn't Adopt:**
- Personal instructions (not relevant for framework)
- Organization instructions (workspace-scoped framework)
- GitHub.com-only features (cross-platform compatibility goal)

**Ubod Implementation:**
- Created `ubod-meta/instructions/github-custom-instructions-spec.instructions.md`
- Documents cross-product compatible instruction format
- Comprehensive guide for repository-wide and path-specific instructions
- Examples for effective instruction authoring

---

#### 1.3. VS Code Custom Instructions (IDE-Specific Features)

**Source:** [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
**Date Referenced:** 2026-01-06

**Key Topics Covered:**
- Three file types: `.github/copilot-instructions.md`, `*.instructions.md`, `AGENTS.md`
- YAML frontmatter (description, name, applyTo)
- Glob patterns for conditional application
- Workspace vs user scopes
- Settings configuration

**What We Adopted:**
- Conditional instructions via `applyTo` glob patterns
- Workspace-scoped instructions in `.github/instructions/`
- Cross-referencing to avoid duplication
- Settings format (object, not array)

**Ubod Implementation:**
- Created `ubod-meta/instructions/vscode-custom-instructions-spec.instructions.md`
- Structured instructions organization (universal → app-specific)
- `applyTo` patterns for automatic loading
- Dual documentation strategy with GitHub spec

---

#### 1.4. GitHub Copilot Custom Prompts

**Note:** GitHub Copilot does not have separate prompt files documentation. Prompt files are primarily a VS Code feature. For cross-product compatibility, use custom instructions (`.github/copilot-instructions.md` and `.github/instructions/*.instructions.md`).

---

#### 1.5. VS Code Custom Prompts (Prompt Files)

**Source:** [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
**Date Referenced:** 2026-01-06

**Key Topics Covered:**
- YAML frontmatter (name, description, argument-hint, agent, model, tools)
- Built-in variables (`${workspaceFolder}`, `${selection}`, `${file}`)
- Input variables (`${input:variableName}`)
- Tool priority hierarchy (prompt → custom agent → default)
- Workspace vs user scopes

**What We Adopted:**
- Workspace-scoped prompts in `.github/prompts/`
- Reusable prompt library for common tasks
- Variable syntax for dynamic content
- Tool specification in frontmatter

**Ubod Implementation:**
- Created `ubod-meta/instructions/vscode-custom-prompt-spec.instructions.md` (renamed from vscode-prompt-files-spec)
- Prompt files in `ubod-meta/prompts/` for framework maintenance
- Variable usage in prompt templates
- Created `/ubod-create-prompt` and `/ubod-update-prompt` workflows
- Note: Prompts are VS Code-specific, not cross-product compatible

---

#### 1.6. VS Code Custom Agents (IDE-Specific Features)

**Source:** [VS Code Custom Agents Documentation](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
**Date Referenced:** 2026-01-06

**Key Topics Covered:**
- VS Code-specific agent properties (handoffs, model, argument-hint)
- Guided sequential workflows (handoffs between agents)
- Subagents for complex multi-step tasks
- Model selection per agent
- Organization-level agent sharing (experimental)

**What We Adopted:**
- Handoffs for multi-step workflows (planner → implementation → review)
- Model specification for agent-specific optimization
- Argument hints for better UX
- Infer property for subagent capability

**What We Didn't Adopt:**
- Organization-level sharing (not needed for workspace-scoped framework)
- VS Code-only features in cross-product agents (use GitHub spec for compatibility)

**Ubod Implementation:**
- Created `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md`
- Dual documentation strategy:
  - `github-custom-agent-spec.instructions.md` - Cross-product compatible (GitHub, VS Code, Visual Studio)
  - `vscode-custom-agent-spec.instructions.md` - VS Code-specific features (handoffs, model, etc.)
- Agent templates use handoffs for guided workflows
- Both specs auto-load when editing `.agent.md` files

---

## Monorepo Management

[Add future references here]

---

## AI-Assisted Development

[Add future references here]

---

## Contributing

When adding resources:
1. Include source URL and date referenced
2. Summarize key insights relevant to Ubod
3. Note what we adopted vs. what we didn't (with rationale)
4. Keep entries concise but informative
