# GitHub Copilot Customization Guide

Ubod is designed to be **Copilot-first**: keep the universal instruction library in `.github/instructions/`, then add app-specific instructions per app.

## Recommended Structure

- Universal (always loaded): `.github/instructions/*.instructions.md`
- App-specific (loaded per app): `apps/<app>/.copilot/instructions/*.instructions.md`

## Typical Setup

1. Root workspace settings (monorepo root):
   - Load only the universal instruction library.

2. App-level workspace settings (inside each app):
   - Load universal + app-specific instructions.

## Notes

- Prefer **smaller, focused** instruction files over a single huge file.
- For UI bugs, include a runtime verification checklist so you don’t stop at “tests pass”.
- If Copilot responses feel generic, explicitly reference an instruction file in chat (e.g. `@discovery-methodology`).
