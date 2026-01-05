---
applyTo: "**/*"
---

# Stuck Detection (Debugging Context)

**Purpose:** Detect when you're stuck and need to change approach or escalate

---

## 🟡 You're STUCK If:

**Framework-agnostic stuck detection rules:**

### 1. Same Error After 3 Different Approaches

- ❌ Tried 3 DIFFERENT solutions
- ❌ Same error message each time
- ❌ No progress toward resolution

**Action:** STOP → Re-diagnose the problem → Check assumptions

### 2. Same Approach Tried 2+ Times

- ❌ Tried same solution twice (variations don't count)
- ❌ Expecting different results

**Action:** STOP → Try completely different approach

### 3. Tests Pass But User Says Bug Still Exists

- ❌ Tests are green
- ❌ User reports bug still happening
- ❌ Wrong diagnosis!

**Action:** STOP → Re-diagnose → Verify actual behavior in browser/CLI

### 4. Using Workarounds Instead of Solutions

- ❌ Infinite loops
- ❌ Random delays (`sleep`, `setTimeout`)
- ❌ Disabling features to "fix" bugs
- ❌ Commenting out code that "should work"

**Action:** STOP → These are red flags, not solutions

---

## When You're Stuck: Action Plan

### Step 1: STOP

**Don't continue down the same path.**

- Acknowledge you're stuck
- Don't try the same thing again
- Don't make random changes hoping something works

### Step 2: Re-Diagnose

**Go back to discovery:**

1. **Read error logs again** (full stack trace)
   - See: `debugging/error-analysis.instructions.md` for systematic error analysis
   ```
   run_in_terminal("tail -n 100 log/development.log")
   ```

2. **Verify your understanding** of the problem
   - See: `debugging/assumptions.instructions.md` for assumption verification protocol
   - Is the problem what you think it is?
   - Are you solving the right issue?
   - Did you verify the bug exists?

3. **Search for similar issues** (check if same bug exists elsewhere)
   - See: `debugging/patterns.instructions.md` for pattern matching protocol
   ```
   semantic_search("similar error message")
   grep_search("error pattern", isRegexp=true)
   ```

4. **Check git history** for related changes
   ```
   run_in_terminal("git log --oneline --grep='related feature'")
   ```

5. **Verify actual runtime behavior** (if tests pass but bug persists)
   - See: `debugging/runtime-verification.instructions.md` for browser/CLI verification

### Step 3: Ask for Help

**If still stuck after re-diagnosis:**

**Tell the user:**

```markdown
🟡 STUCK DETECTION TRIGGERED

I've tried [number] different approaches:
1. [Approach 1] - Result: [same error/no progress]
2. [Approach 2] - Result: [same error/no progress]
3. [Approach 3] - Result: [same error/no progress]

Current diagnosis:
- Error: [exact error message]
- What I think is happening: [diagnosis]
- What I've verified: [evidence]
- What I'm unsure about: [gaps in understanding]

I need help with:
- [ ] Verifying my diagnosis is correct
- [ ] Understanding [specific concept/pattern]
- [ ] Choosing between [approach A] and [approach B]

Would you like me to:
1. Try a completely different approach?
2. Escalate to a different AI model?
3. Provide more context about [specific area]?
```

---

## Escalation Guide

### When to Escalate

**Escalate to user when:**

- Stuck after 3 different approaches
- Tests pass but bug persists
- Using workarounds instead of solutions
- Unsure about diagnosis
- Need domain knowledge or business logic clarification

### When to Try Different Approach

**Try different approach when:**

- Same approach tried twice
- Solution feels like a hack
- Breaking other functionality
- Going in circles

### When to Ask Questions

**Ask user questions when:**

- Requirements are ambiguous
- Multiple valid approaches exist
- Need business logic clarification
- Unsure about edge case handling

---

## Prevention: Avoid Getting Stuck

### 1. Thorough Discovery

- Search for similar implementations FIRST
- Read source code BEFORE coding
- Verify assumptions BEFORE implementing (see: `debugging/assumptions.instructions.md`)

### 2. Verify Diagnosis

- Confirm bug exists by reading code
- Check error logs for exact error (see: `debugging/error-analysis.instructions.md`)
- Verify understanding matches reality

### 3. Small Iterations

- Make small changes
- Test after each change (see: `debugging/incremental.instructions.md`)
- Verify progress incrementally

### 4. Ask Early

- Ask questions when unsure
- Clarify requirements before coding
- Verify approach before implementing

### 5. Check for Patterns

- After fixing one bug, search for similar bugs elsewhere
- Use pattern matching to find all instances (see: `debugging/patterns.instructions.md`)
- Fix all occurrences, not just one

---

## Red Flags (Stop Immediately)

**If you find yourself doing any of these, STOP:**

- ❌ "Let me try one more random thing"
- ❌ "Maybe if I just restart the server..."
- ❌ "I'll add a delay and see if that helps"
- ❌ "Let me comment out this code that should work"
- ❌ "I'll disable this feature for now"
- ❌ "The tests pass so it must be working"

**These are signs you're stuck and need to change approach.**

---

## Success Criteria

**You're NOT stuck if:**

- ✅ Making measurable progress
- ✅ Each attempt gets closer to solution
- ✅ Understanding the problem better with each iteration
- ✅ Tests pass AND actual behavior works
- ✅ Solution is clean, not a workaround

---

## Debugging Protocol Cross-References

When stuck, use these protocols in order:

1. **Error Analysis** (`debugging/error-analysis.instructions.md`)
   - Systematically analyze the error message
   - Extract expected vs actual values

2. **Assumption Verification** (`debugging/assumptions.instructions.md`)
   - List all assumptions
   - Verify each against source code

3. **Pattern Matching** (`debugging/patterns.instructions.md`)
   - Search for same bug elsewhere
   - Fix all instances, not just one

4. **Incremental Verification** (`debugging/incremental.instructions.md`)
   - Test each fix separately
   - Don't batch multiple changes

5. **Runtime Verification** (`debugging/runtime-verification.instructions.md`)
   - Verify actual behavior in browser
   - Don't trust tests alone

---

**Remember:** Getting stuck is normal. Recognizing it early and changing approach is the key to success.

---

✅ **STUCK DETECTION COMPLETE** - Approach changed or help requested
