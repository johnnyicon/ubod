# Claude Code Customization Guide

Claude works best when you explicitly provide:

- The relevant instruction files (paste the content)
- The relevant agent definition (if you use agent roles)
- Concrete code snippets and folder structure

## Suggested Flow

1. Paste the universal methodology instructions (discovery + verification).
2. Paste the app-specific gotchas for the app you’re working in.
3. Ask for a discovery report first, then say “proceed” to implement.

## Keeping It Consistent With Copilot

Treat `.github/instructions/` as the source of truth.
- Claude: paste from those files.
- Copilot: load them via `.vscode/settings.json`.
