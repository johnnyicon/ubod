# Migrate Copilot Instructions for Ubod

## Task

Automatically update `.github/copilot-instructions.md` to include Ubod framework references.

## Instructions

1. **Read the current copilot-instructions.md file**
   ```
   read_file(".github/copilot-instructions.md")
   ```

2. **Add Ubod references in the correct sections** (use multi_replace_string_in_file for efficiency):

   **A. After "## 📂 Repository Structure" section**, add:
   ```markdown
   **Framework:**
   - **`projects/ubod/`** - Universal AI agent kernel (git submodule)
   ```

   **B. After "## 🎯 Workflow Prompts" section**, add:
   ```markdown
   ## 🔧 Ubod Maintenance

   Use these prompts to maintain the Ubod framework itself:
   - **`/ubod-bootstrap-app-context`** - Set up Ubod context for a new app
   - **`/ubod-create-instruction`** - Create a new instruction file
   - **`/ubod-update-instruction`** - Update existing instruction file
   - **`/ubod-generate-complexity-matrix`** - Generate complexity matrix for task routing
   ```

   **C. In "## 🔧 Always-On Instructions" section**, add to the Ubod-related instructions:
   ```markdown
   **Ubod Framework:**
   - `projects/ubod/ubod-meta/instructions/ubod-model-recommendations.instructions.md`
   ```

   **D. Add new "## 🤖 Available Agents" section** (before "## 📖 Additional Resources" if not exists):
   ```markdown
   ## 🤖 Available Agents

   Use `@agent-name` to invoke specialized agents:
   - **@ubod-maintainer** - Maintain Ubod framework (create/update instructions, prompts)
   ```

3. **Verify changes**
   - Ensure all 4 additions were successful
   - Check file syntax is valid markdown
   - Confirm no duplicate sections created

4. **Report completion**
   ```markdown
   ✅ Updated .github/copilot-instructions.md with Ubod references:
   - Added Framework reference in Repository Structure
   - Added Ubod Maintenance prompts section
   - Added Ubod Framework to Always-On Instructions
   - Added Available Agents section with @ubod-maintainer

   Ready to commit:
   git add .github/copilot-instructions.md
   git commit -m "docs: Add Ubod framework references to copilot-instructions.md"
   ```

## Success Criteria

- [ ] All 4 sections added to copilot-instructions.md
- [ ] No duplicate content
- [ ] Valid markdown syntax
- [ ] File structure preserved
- [ ] Ready to commit
