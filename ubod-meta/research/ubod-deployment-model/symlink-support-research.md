# Research Prompt: GitHub Copilot Symlink Support

**Date:** 2026-01-10
**Purpose:** Determine if GitHub Copilot supports symlinks for instructions and agents

---

## Research Question

Does GitHub Copilot in VS Code follow symlinks when loading:
1. **Instructions** (`.github/instructions/*.instructions.md`)
2. **Agents** (`.github/agents/*.agent.md`)

---

## What We Know

### ✅ Prompts: Symlinks WORK
- Tested: Created symlink `.github/prompts/test-symlink.prompt.md` → `projects/ubod/prompts/test-symlink.prompt.md`
- Result: `/test-symlink` appeared in Copilot and could be invoked
- Mechanism: Loaded via `github.copilot.chat.promptFilesLocations` in `.vscode/settings.json`

### ❌ Instructions: Symlinks FAILED (Initial Test)
- Tested: Created symlink `.github/instructions/test-symlink.instructions.md` → `projects/ubod/templates/instructions/test-symlink.instructions.md`
- Result: Instruction rules did NOT apply (not loaded)
- Mechanism: Unknown - likely NOT using settings.json

### ❓ Agents: Unknown
- Not yet tested

---

## Search Queries

Please search for the following information:

### Query 1: GitHub Copilot Instructions Symlinks
```
"GitHub Copilot" instructions symlinks
"GitHub Copilot" "copilot-instructions.md" symlink
"VS Code" "Copilot" instructions follow symlinks
site:github.com/microsoft/vscode-copilot symlink
```

### Query 2: GitHub Copilot Agents Symlinks
```
"GitHub Copilot" agents symlinks
"GitHub Copilot" ".agent.md" symlink
"VS Code" "Copilot agents" follow symlinks
```

### Query 3: Official Documentation
```
"GitHub Copilot" documentation instructions configuration
"GitHub Copilot" workspace configuration
"copilot-instructions.md" documentation
site:docs.github.com copilot instructions
```

### Query 4: Community Reports
```
site:stackoverflow.com "GitHub Copilot" instructions symlink
site:reddit.com/r/vscode "Copilot" symlink
site:github.com/orgs/community/discussions "Copilot" symlink
```

---

## Specific Questions

1. **Does Copilot follow symlinks for instructions?**
   - Any official documentation?
   - Any community reports?
   - Any workarounds?

2. **Does Copilot follow symlinks for agents?**
   - Same as above

3. **Can we configure instruction paths in settings.json?**
   - Similar to `github.copilot.chat.promptFilesLocations`
   - Any hidden/undocumented settings?

4. **Can we use direct submodule references in copilot-instructions.md?**
   - Instead of: `.github/instructions/file.md`
   - Try: `projects/ubod/templates/instructions/file.md`

5. **What's the official loading mechanism?**
   - How does Copilot discover instruction files?
   - Is it hardcoded to `.github/instructions/`?
   - Can we change the search path?

---

## Constraints

- **Platform:** VS Code on macOS (but want cross-platform solution)
- **Version:** Latest GitHub Copilot extension (as of Jan 2026)
- **Requirement:** Must work for monorepo with Git submodules

---

## Decision Criteria

**If symlinks DON'T work for instructions/agents:**
- Use **copy model** for consistency (all files copied)
- Keep prompts direct reference (since it already works)
- Document why different approaches for different types

**If symlinks DO work (but we missed something):**
- Use **symlink model** for everything
- Update deployment scripts
- Document symlink setup

**If neither works:**
- Stick with current **copy model**
- Accept update friction as necessary cost
- Maybe explore VS Code extension to automate sync

---

## Expected Output

Please provide:

1. **Summary:** Do symlinks work for instructions/agents?
2. **Evidence:** Links to documentation, issues, or discussions
3. **Workarounds:** If symlinks don't work, are there alternatives?
4. **Recommendation:** What deployment model should ubod use?

---

## Notes

- We already confirmed prompts work via settings.json
- We're trying to avoid copying files for every ubod update
- Consistency matters: prefer one approach for all file types
- Cross-platform compatibility is important (Windows/Mac/Linux)
