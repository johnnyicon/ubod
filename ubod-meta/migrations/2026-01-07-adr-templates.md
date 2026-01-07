# Migration: ADR Writer Agent and Schema Templates

**Date:** 2026-01-07

**Version:** Ubod 1.7.0 (unreleased)

**Type:** New Feature (Non-Breaking)

---

## Summary

Added ADR (Architecture Decision Record) Writer agent and schema templates to ubod framework. This enables systematic post-implementation documentation of architectural decisions, improving LLM coding capabilities by preserving context and rationale.

**Why This Matters:**
- **Prevents LLM assumption loops** - Documents "we tried X, rejected it because Y"
- **Captures constraints** - "Why not use gem Z?" → "Not in Gemfile, not worth adding"
- **Preserves rationale** - "Why HNSW over IVFFlat?" → "Dynamic data, 15x faster"
- **Builds institutional memory** - New LLM sessions read ADRs, avoid repeating mistakes

---

## What Changed

### New Files in Ubod

| File | Purpose | Size |
|------|---------|------|
| `templates/agents/adr-writer.agent.md` | Universal ADR Writer agent | 241 lines |
| `templates/docs/ADR_SCHEMA.md` | Canonical MADR-style template | 394 lines |
| `templates/docs/ADR_SCHEMA.json` | JSON Schema for validation | 168 lines |
| `templates/docs/ADR_EXAMPLE.md` | Complete example ADR | 181 lines |
| `templates/docs/README.md` | Documentation for templates | 142 lines |

### Updated Files

- `CHANGELOG.md` - Documented new ADR templates in [Unreleased] section

---

## Who Needs This Migration

**Required for:**
- ✅ All consuming repos that want systematic ADR documentation
- ✅ Projects where LLM agents need context about past decisions
- ✅ Teams building institutional memory

**Optional for:**
- ⚠️ Small projects with obvious architectural decisions
- ⚠️ Prototypes/spikes (not long-term codebases)

**Recommended:** All production applications benefit from ADR documentation

---

## Migration Steps

### Step 1: Pull Latest Ubod

```bash
cd projects/ubod
git pull origin main
# Should show commit: "feat(ubod): add ADR Writer agent and schema templates"
```

**Verify new files exist:**
```bash
ls -la templates/agents/adr-writer.agent.md
ls -la templates/docs/ADR_SCHEMA.md
ls -la templates/docs/ADR_SCHEMA.json
ls -la templates/docs/ADR_EXAMPLE.md
```

---

### Step 2: Deploy ADR Writer Agent

**For monorepo:**
```bash
# Copy universal agent to .github/agents/
cp projects/ubod/templates/agents/adr-writer.agent.md \
   .github/agents/adr-writer.agent.md

# Optionally customize for your primary app
# Replace {{APP_NAME}} with your app name (e.g., "Tala")
sed -i '' 's/{{APP_NAME}}/YourAppName/g' .github/agents/adr-writer.agent.md
```

**For single-app:**
```bash
# Same as above
cp projects/ubod/templates/agents/adr-writer.agent.md \
   .github/agents/adr-writer.agent.md

# Customize {{APP_NAME}} placeholders
sed -i '' 's/{{APP_NAME}}/YourAppName/g' .github/agents/adr-writer.agent.md
```

---

### Step 3: Deploy ADR Schema Documentation

**For monorepo (app-specific ADRs):**
```bash
# Example: Tala app
mkdir -p apps/tala/docs/ADR

cp projects/ubod/templates/docs/ADR_SCHEMA.md \
   apps/tala/docs/ADR/ADR_SCHEMA.md

cp projects/ubod/templates/docs/ADR_SCHEMA.json \
   apps/tala/docs/ADR/ADR_SCHEMA.json

# Optional: Copy example ADR
cp projects/ubod/templates/docs/ADR_EXAMPLE.md \
   apps/tala/docs/ADR/ADR_EXAMPLE.md
```

**For single-app:**
```bash
mkdir -p docs/ADR

cp projects/ubod/templates/docs/ADR_SCHEMA.md \
   docs/ADR/ADR_SCHEMA.md

cp projects/ubod/templates/docs/ADR_SCHEMA.json \
   docs/ADR/ADR_SCHEMA.json

# Optional: Copy example ADR
cp projects/ubod/templates/docs/ADR_EXAMPLE.md \
   docs/ADR/ADR_EXAMPLE.md
```

---

### Step 4: (Optional) Create App-Specific ADR Guidance

**For app-specific patterns:**

Create `apps/{app}/.copilot/instructions/{app}-adr-guidance.instructions.md`:

```markdown
---
applyTo: "apps/{app}/**/*"
---

# {App} ADR Guidance

**Purpose:** When to create ADRs for {App}

## When to Create ADR

**CREATE ADR WHEN:**

✅ **Architecture-level decisions** (affects multiple components)
- [Your app-specific examples]

✅ **Non-obvious trade-offs** (future "why did we do this?" questions)
- [Your app-specific examples]

✅ **Reversible but costly decisions** (hard to change later)
- [Your app-specific examples]

**SKIP ADR FOR:**

❌ **Implementation details** (how, not why)
❌ **Obvious choices** (industry standard)
❌ **Temporary experiments**

## How to Create ADR

**After implementation is complete:**

1. Invoke ADR Writer agent: `@adr-writer`
2. Answer questions about context, options, trade-offs
3. Review generated ADR draft
4. Approve and commit

**Location:** `apps/{app}/docs/ADR/YYYY-MM-DD-title.md`

## Existing ADR Examples

See `apps/{app}/docs/ADR/` for examples (if any exist)

---

**Remember:** ADRs improve LLM coding by documenting "why", not just "what".
```

---

### Step 5: Test ADR Writer Agent

**Invoke the agent:**
```
@adr-writer
```

**Expected behavior:**
- Agent asks about decision context
- Asks for options considered
- Asks for trade-offs
- Generates ADR draft
- Saves to correct location

**If agent doesn't appear:**
1. Check `.github/agents/adr-writer.agent.md` exists
2. Reload VS Code window (Cmd+Shift+P → "Reload Window")
3. Check VS Code Copilot extension version (needs agents support)

---

### Step 6: Create Your First ADR (Optional)

**If you have a recent architectural decision:**

1. Invoke `@adr-writer`
2. Answer the guided questions
3. Review generated ADR
4. Commit with message: `docs: Add ADR for [decision title]`

**Example decisions worth documenting:**
- Technology stack choices (Rails vs Next.js, PostgreSQL vs MongoDB)
- Architecture patterns (monorepo vs polyrepo, monolithic vs microservices)
- Performance optimizations (HNSW vs IVFFlat indexing)
- Framework integrations (RubyLLM vs OpenAI gem)

---

## Verification

### Verify Templates Deployed

```bash
# Agent exists
test -f .github/agents/adr-writer.agent.md && echo "✓ Agent deployed"

# Schema exists (adjust path for your structure)
test -f apps/tala/docs/ADR/ADR_SCHEMA.md && echo "✓ Schema deployed"
test -f docs/ADR/ADR_SCHEMA.md && echo "✓ Schema deployed"  # Single-app
```

### Verify Agent Works

```bash
# Open VS Code
# Type "@adr" in chat
# Agent should appear in suggestions: "@adr-writer"
# If not, reload window (Cmd+Shift+P → "Reload Window")
```

### Verify JSON Schema Validates

```bash
# Install ajv-cli if not already installed
npm install -g ajv-cli

# Validate an example ADR (adjust paths)
ajv validate \
  -s apps/tala/docs/ADR/ADR_SCHEMA.json \
  -d apps/tala/docs/ADR/2026-01-07-example.md.json

# Note: ADRs are markdown, need manual validation or conversion
```

---

## Rollback

**If you need to revert:**

```bash
# Remove agent
rm .github/agents/adr-writer.agent.md

# Remove schema docs
rm -rf apps/tala/docs/ADR/ADR_SCHEMA.*  # Adjust path
rm -rf docs/ADR/ADR_SCHEMA.*            # Single-app

# Remove ADR guidance (if created)
rm apps/tala/.copilot/instructions/tala-adr-guidance.instructions.md

# ADRs created remain (they're documentation, safe to keep)
```

**Note:** Rollback doesn't remove ADRs themselves (they're valuable documentation)

---

## Breaking Changes

**None.** This is a purely additive feature.

- No changes to existing agents, prompts, or instructions
- No changes to upgrade script behavior
- No changes to ubod configuration

---

## Next Steps After Migration

1. **Document next architectural decision:**
   - After next feature implementation, use `@adr-writer`
   - Build muscle memory for ADR creation

2. **Review existing decisions:**
   - Consider documenting recent major decisions retroactively
   - Focus on non-obvious choices that future LLMs should know

3. **Customize threshold criteria:**
   - Define what deserves ADRs in your app-specific guidance
   - Share patterns with team

4. **Integrate into workflow:**
   - Add ADR creation to PR checklist for architectural changes
   - Link ADRs from PRDs (bidirectional traceability)

---

## FAQ

**Q: Should I create ADRs for all past decisions?**
A: No. Focus on recent non-obvious decisions. Going back >6 months is rarely worth it.

**Q: Can I customize the ADR template?**
A: Yes. Copy `ADR_SCHEMA.md` and modify sections. Keep MADR core structure.

**Q: Should ADRs be in each app folder or root docs/?**
A: **Monorepo:** App-specific ADRs in `apps/{app}/docs/ADR/`, cross-app ADRs in `docs/ADR/`
A: **Single-app:** All in `docs/ADR/`

**Q: Do I need the JSON schema?**
A: Optional. Useful for CI/CD validation, but markdown ADRs are human-readable priority.

**Q: What if I'm not sure a decision deserves an ADR?**
A: Ask: "Will future me (or LLM) wonder why we did this?" If yes, create ADR.

---

## Related Files

- **Ubod CHANGELOG:** `projects/ubod/CHANGELOG.md` → [Unreleased] section
- **Agent Template:** `projects/ubod/templates/agents/adr-writer.agent.md`
- **Schema Docs:** `projects/ubod/templates/docs/ADR_SCHEMA.md`
- **Example ADR:** `projects/ubod/templates/docs/ADR_EXAMPLE.md`

---

## Commit Message Template

```
chore: Deploy ADR Writer agent and schema templates

Deploy ADR (Architecture Decision Record) support from ubod v1.7.0:
- Add ADR Writer agent to .github/agents/
- Add ADR schema documentation to {{APP_PATH}}/docs/ADR/
- Add app-specific ADR guidance instructions

This enables systematic post-implementation documentation of
architectural decisions, improving LLM coding capabilities by
preserving context and rationale.

Migration: projects/ubod/ubod-meta/migrations/2026-01-07-adr-templates.md
```

---

**Migration complete!** Your repo now supports systematic ADR creation. Use `@adr-writer` after your next architectural decision.
