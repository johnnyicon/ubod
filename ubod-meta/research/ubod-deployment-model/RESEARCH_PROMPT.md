# Research Prompt: Ubod Deployment Model (Copy vs Reference)

**Date:** 2026-01-10
**Status:** Needs Research
**Researcher:** [Your choice of LLM]

---

## Context

**Ubod (Universal Bootstrap for On-Demand)** is an AI agent kernel framework deployed as a Git submodule.

**Current deployment model:**
- Ubod lives at `projects/ubod/` (Git submodule)
- Templates in `projects/ubod/templates/` get **copied** to consuming repo:
  - Prompts: `projects/ubod/prompts/` → `.github/prompts/`
  - Instructions: `projects/ubod/templates/instructions/` → `.github/instructions/`
  - Agents: `projects/ubod/templates/agents/` → `.github/agents/`
  
**Problem:**
- Every ubod update requires running `ubod-upgrade.sh` to re-copy files
- Creates friction for framework improvements
- Risk of consuming repos getting out of sync

**Question:**
Can we use **symlinks** or **direct submodule references** instead of copying?

---

## Consuming Repo Structure

```
monorepo/
├── .github/
│   ├── copilot-instructions.md (references instructions/)
│   ├── prompts/ (copied from ubod)
│   ├── instructions/ (copied from ubod)
│   └── agents/ (copied from ubod)
├── .vscode/
│   └── settings.json (configures prompt locations)
├── projects/
│   └── ubod/ (Git submodule)
│       ├── prompts/
│       ├── templates/
│       │   ├── instructions/
│       │   ├── agents/
│       │   └── prompts/
│       └── ubod-meta/
└── apps/
    └── tala/ (Rails app)
```

---

## VS Code Settings (Current)

```json
{
  "github.copilot.chat.promptFilesLocations": {
    ".github/prompts/**/*.prompt.md": true,
    "projects/ubod/prompts/**/*.prompt.md": true
  }
}
```

**Note:** This ALREADY references `projects/ubod/prompts/` directly! No copy needed for prompts!

---

## Research Questions

### 1. Symlinks

**Question:** Does GitHub Copilot (in VS Code) follow symlinks when:
- Reading `.github/instructions/*.instructions.md`
- Reading `.github/prompts/*.prompt.md`
- Reading `.github/agents/*.agent.md`

**Test scenario:**
```bash
# Create symlink
ln -s ../../projects/ubod/templates/instructions/universal .github/instructions/universal

# Does Copilot load these instructions?
```

**Considerations:**
- Cross-platform (macOS/Linux/Windows)
- Git clone behavior (does git clone preserve symlinks?)
- Repository portability (what if ubod submodule is missing?)

---

### 2. Direct Submodule References

**Question:** Can we configure GitHub Copilot to load instructions directly from submodule paths?

**Current behavior:**
- Prompts: ✅ WORKS via `github.copilot.chat.promptFilesLocations`
- Instructions: ❓ UNKNOWN - can we reference `projects/ubod/templates/instructions/**/*.instructions.md`?
- Agents: ❓ UNKNOWN - can we reference `projects/ubod/templates/agents/**/*.agent.md`?

**Test needed:**
Does `copilot-instructions.md` support submodule paths in `<instruction>` blocks?

```markdown
<instruction>
<file>projects/ubod/templates/instructions/discovery-methodology.instructions.md</file>
<applyTo>**/*</applyTo>
</instruction>
```

---

### 3. Hybrid Approach

**Question:** Should we use different strategies for different file types?

**Possible hybrid:**
- **Prompts:** Direct reference (already works via `promptFilesLocations`)
- **Instructions:** Symlink or direct reference (needs testing)
- **Agents:** Copy (if they need customization)
- **Templates:** Copy (explicitly meant to be customized)

---

### 4. Trade-Offs Analysis

Compare 3 options:

| Aspect | Copy (Current) | Symlinks | Direct Reference |
|--------|----------------|----------|------------------|
| **Setup complexity** | ??? | ??? | ??? |
| **Update friction** | ??? | ??? | ??? |
| **Cross-platform** | ??? | ??? | ??? |
| **Offline support** | ??? | ??? | ??? |
| **Customization** | ??? | ??? | ??? |
| **Version control** | ??? | ??? | ??? |
| **Portability** | ??? | ??? | ??? |

---

## Specific Tests Needed

### Test 1: Symlink Instructions
```bash
# In consumer repo
mkdir -p .github/instructions
ln -s ../../projects/ubod/templates/instructions/universal .github/instructions/universal

# Does Copilot load universal-critical-rules.instructions.md?
# Test by asking Copilot to reference a rule from that file
```

### Test 2: Direct Instruction Reference
```bash
# In .github/copilot-instructions.md
<instruction>
<file>projects/ubod/templates/instructions/discovery-methodology.instructions.md</file>
<applyTo>**/*</applyTo>
</instruction>

# Does Copilot load this?
```

### Test 3: Prompt Location Already Works
```bash
# We already reference projects/ubod/prompts/ in settings.json
# Verify: Can we invoke /ubod-checkin directly without copying?
```

---

## Success Criteria

**For symlinks:**
- ✅ Copilot loads instructions from symlinked paths
- ✅ Works on macOS, Linux, Windows
- ✅ Git clone preserves symlinks (or documents workaround)
- ✅ Graceful degradation if ubod submodule missing

**For direct reference:**
- ✅ Copilot loads instructions from `projects/ubod/templates/instructions/`
- ✅ No need to copy or symlink
- ✅ Works across all Copilot-enabled editors

**For hybrid:**
- ✅ Clear mental model (what gets copied vs referenced)
- ✅ Documented in ubod README
- ✅ Simplified deployment script

---

## Recommended Approach

Based on your findings, recommend:

1. **What should be copied?** (and why)
2. **What should be symlinked?** (and why)
3. **What should be directly referenced?** (and why)
4. **What deployment script changes are needed?**
5. **What documentation is needed?**

---

## Deliverables

1. **Test results** - Does symlink/direct reference work?
2. **Trade-off analysis** - Copy vs Symlink vs Direct Reference
3. **Recommendation** - Preferred deployment model with reasoning
4. **Migration plan** - How to transition from current copy model
5. **Documentation** - Update ubod README and deployment scripts

---

## Note on Current State

**We just discovered:** Prompts ALREADY use direct reference!

```json
"github.copilot.chat.promptFilesLocations": {
  "projects/ubod/prompts/**/*.prompt.md": true
}
```

This means:
- ✅ No need to copy prompts to `.github/prompts/`
- ✅ Ubod prompt updates immediately available
- ✅ Proof that direct reference model CAN work

**Question:** Can we do the same for instructions and agents?

---

## Research Tips

- Test in actual VS Code environment (not just docs)
- Check GitHub Copilot extension logs
- Test across different file types (instructions, agents, prompts)
- Consider edge cases (missing submodule, different branches)
- Look for official GitHub Copilot documentation on path resolution

---

**Output format:** Analysis document with test results, trade-off matrix, and clear recommendation.
