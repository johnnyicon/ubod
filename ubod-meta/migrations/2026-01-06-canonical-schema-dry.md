# Migration: Canonical Schema (DRY Refactoring)

**Date:** 2026-01-06  
**Version:** Unreleased (targeting 1.5.0)  
**Type:** Infrastructure improvement (non-breaking for agents)  
**Impact:** Framework maintainers and documentation readers

---

## Summary

**Problem:** Agent schema was defined in multiple places:
- `vscode-custom-agent-spec.instructions.md`
- `github-custom-agent-spec.instructions.md`
- Agent templates
- Migration files

**Solution:** Created canonical schema as single source of truth:
- `ubod-meta/schemas/agent-schema.md` - Human-readable canonical definition
- `ubod-meta/schemas/agent-schema.json` - JSON Schema for validation
- Spec files now reference canonical schema instead of duplicating

**Impact:**
- ✅ Schema changes update in ONE place
- ✅ Consistent structure across all documentation
- ✅ Easier to maintain and evolve
- ⚠️ Spec files now shorter, require reading canonical schema for full details

---

## What Changed

### New Files

```bash
ubod-meta/schemas/
  ├── agent-schema.md       # Canonical schema definition
  └── agent-schema.json     # JSON Schema for validation
```

### Updated Files

**Spec files now reference canonical schema:**
- `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md`
- `ubod-meta/instructions/github-custom-agent-spec.instructions.md`

**Agent templates include schema reference:**
- `templates/agents/agent-template.md`
- `templates/agents/discovery-planner.agent.md`
- (Other templates updated similarly)

### What Didn't Change

**No changes to existing agents:**
- All `.agent.md` files remain valid
- No frontmatter changes
- No body section changes
- Agent behavior unchanged

**This is purely a documentation refactoring.**

---

## Migration Steps

### For Framework Maintainers

**If updating agent schema in the future:**

1. **Update canonical schema:**
   ```bash
   vim ubod-meta/schemas/agent-schema.md
   ```

2. **Update JSON Schema if structural:**
   ```bash
   vim ubod-meta/schemas/agent-schema.json
   ```

3. **Verify spec references still accurate:**
   ```bash
   # Check VS Code spec
   grep -n "agent-schema.md" ubod-meta/instructions/vscode-custom-agent-spec.instructions.md
   
   # Check GitHub spec
   grep -n "agent-schema.md" ubod-meta/instructions/github-custom-agent-spec.instructions.md
   ```

4. **Update CHANGELOG with schema changes**

5. **Create migration if breaking**

### For Documentation Readers

**When learning agent structure:**

1. Start with canonical schema:
   ```bash
   cat ubod-meta/schemas/agent-schema.md
   ```

2. Check platform-specific features:
   - VS Code: `vscode-custom-agent-spec.instructions.md` (handoffs, model)
   - GitHub: `github-custom-agent-spec.instructions.md` (mcp-servers, metadata)

### For Agent Authors

**No action required.**

Your existing agents are compliant. Future agents should reference the canonical schema for structure questions.

---

## Verification

**Check canonical schema exists:**
```bash
ls -lh ubod-meta/schemas/
# Expected: agent-schema.md, agent-schema.json
```

**Check spec files reference canonical schema:**
```bash
grep -l "agent-schema.md" ubod-meta/instructions/*-agent-spec.instructions.md
# Expected: 2 matches (vscode and github specs)
```

**Check templates reference canonical schema:**
```bash
grep -l "SCHEMA REFERENCE" templates/agents/*.md
# Expected: At least agent-template.md, discovery-planner.agent.md
```

**Verify existing agents still parse:**
```bash
# Example: Check ubod-maintainer frontmatter
head -n 10 ubod-meta/agents/ubod-maintainer.agent.md | grep "^---"
# Expected: Two --- lines (frontmatter delimiters)
```

---

## Rollback Plan

**If canonical schema causes issues:**

1. **Revert spec files** to include full schema inline (from git history)
2. **Remove canonical schema files:**
   ```bash
   rm -rf ubod-meta/schemas/
   ```
3. **Revert CHANGELOG entry**

**Note:** Rollback is low-risk since agents themselves didn't change.

---

## Benefits

### Before (DRY Violation)

**To update tool aliases:**
1. Edit `vscode-custom-agent-spec.instructions.md` (tool section)
2. Edit `github-custom-agent-spec.instructions.md` (tool section)
3. Edit agent templates (comments)
4. Edit migration files (references)
5. Pray you didn't miss anywhere

### After (DRY Applied)

**To update tool aliases:**
1. Edit `ubod-meta/schemas/agent-schema.md` (tool aliases section)
2. Done. All references point to canonical source.

---

## Related Documentation

- **Canonical Schema:** `ubod-meta/schemas/agent-schema.md`
- **JSON Schema:** `ubod-meta/schemas/agent-schema.json`
- **VS Code Spec:** `ubod-meta/instructions/vscode-custom-agent-spec.instructions.md`
- **GitHub Spec:** `ubod-meta/instructions/github-custom-agent-spec.instructions.md`
- **CHANGELOG:** Version [Unreleased] for this change

---

## Questions?

**Q: Do I need to update my existing agents?**  
A: No. This is a documentation-only change.

**Q: Where do I learn agent structure now?**  
A: Read `ubod-meta/schemas/agent-schema.md` first, then platform-specific specs for features.

**Q: What if spec files and canonical schema conflict?**  
A: Canonical schema is authoritative. Report conflict as bug.

**Q: Can I still read spec files only?**  
A: Yes, but they now reference canonical schema for complete structure. You'll need both.

---

**Remember:** Schema evolution now has a clear process: Update canonical → Update JSON Schema → Update references → Create migration if breaking.
