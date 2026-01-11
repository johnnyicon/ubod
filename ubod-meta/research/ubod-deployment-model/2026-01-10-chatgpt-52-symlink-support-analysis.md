# ChatGPT 5.2 Analysis: GitHub Copilot Symlink Support

**Date:** 2026-01-10
**Model:** ChatGPT 5.2
**Query:** GitHub Copilot symlink support for instructions and agents

---

## 1) Summary: do symlinks work?

* **Repo-wide instructions (`.github/copilot-instructions.md`)**: **Yes, Copilot/VS Code follows the symlink** (it attempts to read the target). A **broken** symlink can break chat sending (was patched in Insiders per the issue). ([GitHub Issue #261610](https://github.com/microsoft/vscode/issues/283322/linked_closing_reference?reference_location=REPO_ISSUES_INDEX))

* **Instruction files (`.github/instructions/*.instructions.md`)**: **No official statement about symlinks**. In practice, VS Code discovers instruction files by searching configured folders (default includes `.github/instructions`). So a symlink *should* behave like a normal file **as long as it's readable and within workspace trust**, but many "it didn't apply" reports are actually **about `applyTo`/trigger conditions**, not symlinks. ([VS Code Docs: Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions?utm_source=chatgpt.com))

* **Agents (`.github/agents/*.agent.md`)**: **No official statement about symlinks**, but VS Code "detects any `.md` files in the `.github/agents` folder" as agents—so a symlink in that folder is *likely* fine on macOS/Linux (and Windows only if symlinks are supported/enabled). ([VS Code Docs: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents))

**Practical takeaway:** even if symlinks "work", they're the least portable option (Windows + repo tooling + CI environments). For **instructions**, you can avoid symlinks entirely with settings (below). For **agents**, you'll probably still want a copy/sync step if you need true cross-platform.

---

## 2) Evidence (most relevant)

### A) `.github/copilot-instructions.md` symlinks are followed

A VS Code issue reproduces a failure mode by creating a **symlink** at `.github/copilot-instructions.md` pointing to a **non-existent** target; chat "does not do anything" until the symlink is removed. That only happens if VS Code/Copilot tries to read the symlink target.

### B) How VS Code loads instruction files (and how to change paths)

VS Code supports:

* **Repo-wide**: `.github/copilot-instructions.md` (auto-applied to chat in that workspace when enabled)
* **Scoped instruction files**: `*.instructions.md` with `applyTo` globs; "used when creating or modifying files" and typically **not** for read-only prompts.
* **Configurable folders** via **`chat.instructionsFilesLocations`** (default `{ ".github/instructions": true }`)

**This is the big unlock for your monorepo/submodule setup: you can point Copilot at the submodule folder directly instead of symlinking into `.github/instructions`.**

### C) How VS Code loads agents

VS Code's custom agents doc is explicit about discovery:

* "VS Code detects any `.md` files in the `.github/agents` folder of your workspace as custom agents."
* It also supports creating agents in the **user profile** (personal) and mentions **org-level** agents (experimental).

---

## 3) Workarounds / alternatives if symlinks aren't reliable

### Workaround 1 (recommended): configure instruction folders instead of symlinking

Put your canonical instruction files wherever you want (including inside the submodule), and configure:

```jsonc
//// .vscode/settings.json
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "projects/ubod/templates/instructions": true
  }
}
```

This is an **official** mechanism. ([VS Code Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings?utm_source=chatgpt.com))

### Workaround 2: don't "chain" instructions via links inside `copilot-instructions.md`

You *can* write Markdown links, but Copilot is **not guaranteed** to "follow" them as additional context. Community guidance is basically: keep the important stuff in the instructions file itself.
(So: links are fine for humans; don't depend on them for model behavior.)

### Workaround 3: agents likely still need copy-or-symlink

There's **no documented setting** equivalent to `chat.instructionsFilesLocations` for custom agent discovery; it's explicitly tied to `.github/agents` (plus user profile / org-level).

So your options are:

* **Copy model**: sync from submodule → `.github/agents/` (portable).
* **Symlink model**: symlink files into `.github/agents/` (works well on macOS/Linux; Windows is the risk).
* **Org-level agents** (experimental): avoids copying across repos if that fits your org workflow.

---

## 4) Answers to your specific questions

### (1) Does Copilot follow symlinks for instructions?

* **For `.github/copilot-instructions.md`: yes** (and broken symlinks can break chat send).
* **For `.github/instructions/*.instructions.md`: not explicitly documented.** If your symlinked instruction "didn't apply", the most common causes are:
  * Missing/incorrect `applyTo` frontmatter (so it never auto-attaches)
  * Testing with a "read" prompt (instructions files are mainly applied on **create/modify**, not read-only)
  * Feature/bug flakiness (there are multiple reports of `.instructions.md` not being respected)

### (2) Does Copilot follow symlinks for agents?

* Not documented, but VS Code detects `.md` files in `.github/agents`. A symlink *in that folder* will usually look like a file to VS Code on macOS/Linux.
* If you need **cross-platform certainty**, prefer **copy/sync**.

### (3) Can we configure instruction paths in settings.json?

Yes: **`chat.instructionsFilesLocations`** is the official knob (supports glob patterns; relative to workspace root).

### (4) Can we use direct submodule references in `copilot-instructions.md`?

You can *write* "see `projects/ubod/...`" but Copilot is not guaranteed to load that file's contents automatically (links especially are inconsistent).
If you want those instructions reliably loaded, **put them in `*.instructions.md`** and include their folder via `chat.instructionsFilesLocations`.

### (5) What's the official loading mechanism?

* **Repo-wide instructions**: `.github/copilot-instructions.md` auto-attached when enabled.
* **Instruction files**: `*.instructions.md` found by searching folders in `chat.instructionsFilesLocations`; auto-attached based on `applyTo`, and primarily for create/modify.
* **Agents**: any `.md` in `.github/agents` becomes a custom agent (plus user profile; org-level optional).

---

## 5) Recommendation for **ubod**

Given your constraints (monorepo + submodules + cross-platform):

**Use a "settings-first" model:**

1. **Instructions**: **stop symlinking** and instead point to the submodule folder(s) using `chat.instructionsFilesLocations`. This gives you *one canonical source* without copying.
2. **Prompts**: keep doing what works, but consider aligning to the official `chat.promptFilesLocations` (same concept as instructions).
3. **Agents**: use a **copy/sync step** into `.github/agents/` (most portable). If your team is macOS/Linux-only, symlinks are probably fine; but for true Windows compatibility, copying wins. Agent discovery is explicitly tied to `.github/agents`.

---

## References

- [GitHub Issue #261610: Edge case around broken symlinks](https://github.com/microsoft/vscode/issues/283322/linked_closing_reference?reference_location=REPO_ISSUES_INDEX)
- [VS Code Docs: Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions?utm_source=chatgpt.com)
- [VS Code Docs: Custom Agents](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [VS Code Settings Reference](https://code.visualstudio.com/docs/copilot/reference/copilot-settings?utm_source=chatgpt.com)
- [Reddit: Copilot fails to follow copilot-instructions.md file](https://www.reddit.com/r/GithubCopilot/comments/1lbsa6m/copilot_fails_to_follow_copilotinstructionsmd_file/?utm_source=chatgpt.com)
- [GitHub Issue: .instructions.md Files Not Respected in VS Code Chat](https://github.com/microsoft/vscode-copilot-release/issues/12770?utm_source=chatgpt.com)
