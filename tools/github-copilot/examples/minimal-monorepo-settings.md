# Minimal monorepo Copilot settings

Create `.vscode/settings.json` at your monorepo root:

```json
{
  "copilot.contextualActions.instructions": [
    ".github/instructions/*.instructions.md"
  ]
}
```

For app-specific instructions, add an app-level `.vscode/settings.json` (example: `apps/tala/.vscode/settings.json`) that includes both universal + app-specific globs.
