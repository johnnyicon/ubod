---
description: "Update existing copilot-instructions.md to follow Ubod navigation index pattern"
---

# Migrate/Update Copilot Instructions

> **Template Reference:**
> - The canonical template for copilot-instructions.md is at:
>   `projects/ubod/templates/copilot-instructions.template.md`
> - If you do not have this file, download it from:
>   https://github.com/johnnyicon/ubod/blob/main/templates/copilot-instructions.template.md
> - This prompt will never overwrite your existing file—copy the template manually if you want to start fresh.

## Purpose

This prompt helps you **update existing** `.github/copilot-instructions.md` files to follow the Ubod navigation index pattern.

**When to use:**
- You already have a copilot-instructions.md file from before Ubod
- Your file is verbose/documentation-heavy (not a navigation index)
- You've updated Ubod and need to sync the navigation file  
- Your monorepo structure changed (new apps added, etc.)

**For fresh Ubod deployments:** Use `templates/copilot-instructions.template.md` instead (see Phase 3 of UBOD_SETUP_GUIDE.md)

---

## Task

Transform existing copilot-instructions.md to follow Ubod's navigation index pattern.

## Instructions

### Step 1: Analyze the Current File

Read `.github/copilot-instructions.md` and determine:

**Is it already a navigation index?**
- ✅ Uses emoji section headers (🚨, 📂, 🎯, 🔧)
- ✅ Short and concise (under 200 lines)
- ✅ References files by path (doesn't duplicate content)
- ✅ Lists prompts/agents/instructions

**OR is it verbose documentation?**
- ❌ No emoji headers, just markdown headings
- ❌ Long and detailed (200+ lines)
- ❌ Duplicates instruction content inline
- ❌ Explains implementation details

### Step 2A: If Already a Navigation Index (Just Add Ubod Sections)

Use `multi_replace_string_in_file` to add these sections:

1. **After "## 📂 Repository Structure"**, add:
   ```markdown
   **Framework:**
   - **`projects/ubod/`** - Universal AI agent kernel (git submodule)
   ```

2. **After "## 🎯 Workflow Prompts"**, add:
   ```markdown
   
   ## 🔧 Ubod Maintenance
   
   Use these prompts to maintain the Ubod framework itself:
   
   - **`/ubod-bootstrap-app-context`** - Set up Ubod context for a new app
   - **`/ubod-create-instruction`** - Create a new instruction file
   - **`/ubod-update-instruction`** - Update existing instruction file
   - **`/ubod-generate-complexity-matrix`** - Generate complexity matrix for task routing
   - **`/ubod-migrate-copilot-instructions`** - Update this file when monorepo changes
   
   **Location:** `.github/prompts/ubod/*.prompt.md`
   ```

3. **Find "## 🔧 Always-On Instructions"**, add under "Universal (all files):"
   ```markdown
   
   **Ubod Framework:**
   - `.github/instructions/ubod/ubod-model-recommendations.instructions.md` - Model selection guidance
   ```

4. **Add new "## 🤖 Available Agents" section** (after "## 📚 Deep Guidance", before "## 🏗️ Tech Stack"):
   ```markdown
   
   ## 🤖 Available Agents
   
   Use `@agent-name` to invoke specialized agents:
   
   - **@ubod-maintainer** - Maintain Ubod framework (create/update instructions, prompts)
   
   [Add your custom agents here]
   
   **Location:** `.github/agents/*.agent.md` (root level only, no subfolders)
   ```

Report completion and stop.

---

### Step 2B: If Verbose Documentation (Needs Restructure)

**Don't blindly add sections!** Instead, provide this message to the user:

```markdown
⚠️ **Migration Requires Manual Restructure**

Your current `.github/copilot-instructions.md` is verbose documentation (XXX lines), not a navigation index.

**Ubod expects a concise navigation index (120-150 lines) that:**
- Uses emoji section headers (🚨, 📂, 🎯, 🔧)
- References files by path (doesn't duplicate content)
- Lists available prompts/agents/instructions
- Provides high-level overview only

**Recommended approach:**

1. **Extract valuable content** from current file:
   - Tech stack summary
   - Critical workflows/commands
   - Common pitfalls
   - Key file references

2. **Create separate documentation files** for detailed content:
   - `docs/DEVELOPMENT_GUIDE.md` - Development workflows
   - `docs/ARCHITECTURE_PATTERNS.md` - Architecture patterns
   - `docs/COMMON_PITFALLS.md` - Common mistakes
   - Keep current copilot-instructions.md as backup

3. **Use Ubod template** for new copilot-instructions.md:
   ```bash
   # Backup existing file
   mv .github/copilot-instructions.md .github/copilot-instructions.md.backup
   
   # Copy template
   cp projects/ubod/templates/copilot-instructions.template.md .github/copilot-instructions.md
   
   # Edit template placeholders with your monorepo details
   ```

4. **Migrate key references** from backup to new file:
   - App list → "## 📂 Repository Structure"
   - Custom prompts → "## 🎯 Workflow Prompts"
   - Tech stack → "## 🏗️ Tech Stack Summary"
   - Documentation links → "## 📖 Additional Resources"

**Why this matters:** A navigation index helps AI discover resources without overwhelming context. Detailed docs belong in separate files that can be referenced as needed.

**Need help?** I can guide you through the restructure step-by-step, or you can do it manually using the template.
```

Then **STOP** and wait for user decision. Don't automatically restructure.

---

### Step 3: Verify Changes

**If Step 2A (simple additions):**
- [ ] All 4 Ubod sections added successfully
- [ ] No duplicate content created
- [ ] File structure preserved
- [ ] Valid markdown syntax

**If Step 2B (restructure needed):**
- [ ] User acknowledged restructure is needed
- [ ] Provided clear migration path
- [ ] Waiting for user decision on approach

---

## Success Criteria

**For navigation index files (Step 2A):**
- ✅ Added Ubod sections without disrupting existing structure
- ✅ File remains concise (under 200 lines)
- ✅ All references are valid paths

**For verbose documentation (Step 2B):**
- ✅ Identified file needs restructure
- ✅ Provided clear migration guidance
- ✅ User can choose automated or manual approach
- ✅ Doesn't blindly add sections to inappropriate structure

---

## Report Template

```markdown
✅ **Migration Analysis Complete**

**Current File Structure:** [Navigation Index / Verbose Documentation]
**File Size:** [XXX lines]
**Action Taken:** [Added Ubod sections / Recommended restructure]

[If Step 2A]
✅ Updated .github/copilot-instructions.md with Ubod references:
- Added Framework reference in Repository Structure
- Added Ubod Maintenance prompts section
- Added Ubod Framework to Always-On Instructions
- Added Available Agents section with @ubod-maintainer

Ready to commit:
```bash
git add .github/copilot-instructions.md
git commit -m "docs: Add Ubod framework references to copilot-instructions.md"
```

[If Step 2B]
⚠️ **Restructure recommended** - see guidance above.
Would you like me to:
1. Guide you through manual restructure (recommended)
2. Attempt automated restructure (may lose nuance)
3. Create detailed migration checklist
```

