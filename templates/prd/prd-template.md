---
title: {{Feature Name}}
app: {{tala|nextjs-chat|rails-inertia}}
status: {{active|archived|deferred}}
priority: {{P0|P1|P2|P3}}
created_date: YYYY-MM-DD
target_date: YYYY-MM-DD
archived_date: null  # Set when archived
deferred_issues: []  # GitHub issue numbers
tags: [{{mvp}}, {{rag}}, {{ui}}, ...]
---

# PRD_XX — [Feature Name]

**Purpose:** One sentence on the specific capability or gap this PRD will close. Focus on user value and the operational reason this must exist now.

**Date:** <YYYY-MM-DD>
**Owner:** <Name>
**Final Reviewer:** <Reviewer>
**Status:** DRAFT

---

## ⚠️ BEFORE WRITING THIS PRD: Complete Discovery Phase

**STOP!** Do not write any spec sections until you complete the Discovery Phase checklist below.

See "Discovery Phase (REQUIRED)" section at the end of this template.

---

## Problem Statement
- What user problem are we solving? What breaks today?
- Why now? Tie to business risk, compliance, or timeline.
- Who is impacted (roles, orgs, environments)?

## Goals (In Scope)
- Bullet the outcomes this PRD must achieve.
- Keep each item testable and observable.

## Non-Goals (Out of Scope)
- Explicitly list what we will not do in this PRD.
- Push staging-only work to DEFERRED_FEATURES if required.

## Success Metrics
- Primary metric and target (e.g., task completion rate, latency, accuracy).
- Guardrails (e.g., error rate, P95 latency, accessibility score).

## Current State & Constraints
**INSTRUCTIONS:** Document findings from Discovery Phase here.

- **Existing Models:** List exact model names found (not assumed)
- **Existing Services:** List exact service class names and signatures found
- **Existing Patterns:** Link to similar features in codebase
- **Schema State:** Current relevant tables/columns from schema
- **Framework Patterns:** UI/component patterns found
- **Prior PRDs/Decisions:** Links to binding decisions

## Dependencies
- Upstream: migrations, services, feature flags, third-party providers.
- Downstream: clients, SDKs, docs, support.

## Assumptions
- Environment, data, users, or tooling this plan relies on.

## Risks & Mitigations
- Technical or product risks with concrete mitigations or fallbacks.

---

## Deliverables (What to build)

**INSTRUCTIONS:** For each deliverable, provide EXACT code snippets (not descriptions). Use findings from Discovery Phase.

### Data & Schema
**Required:**
- Exact migration code (column additions, indexes, etc.)
- Exact enum values (if applicable)
- Exact constraints (null, default, foreign keys, unique)
- 2-3 sample rows showing valid data

**Example Format:**
```
# Example migration pseudocode
add_column :table_name, :column_name, :type, default: "value", null: false
add_index :table_name, [:col1, :col2], unique: true
```

### Backend / Services
**Required:**
- Exact route definitions with HTTP methods
- Exact request parameter names and types
- Exact validation order (list in execution order)
- Exact error messages (word-for-word strings)
- Exact HTTP status codes for each scenario
- Exact service/job class signatures with method names
- Exact retry/timeout configuration values

### Frontend / UX
**Required:**
- Exact route paths and controller/handler mappings
- Exact component class names and structure
- Exact UI states (loading/empty/error/success) with copy
- Exact ARIA labels, roles, keyboard shortcuts
- Exact responsive breakpoints (mobile/tablet/desktop)

**Remote Actions (Critical):**
When adding UI elements that trigger remote actions, specify BOTH:
1. **Frontend:** Exact button/link code with action type
2. **Backend:** Exact handler response (format, status codes, update mechanism)
3. **Response Verification:** Test matrix showing request → response → UI update cycle works end-to-end

**Checklist for remote actions:**
- [ ] UI element added that triggers remote action
- [ ] Handler written with matching response
- [ ] Response format matches request type
- [ ] UI update verified (not just "record deleted" but "list updated")
- [ ] Test covers full cycle (request, response, DOM update)
- [ ] Error case covered (what if action fails? User sees feedback)

### Integrations / Ops
**Required:**
- Exact feature flag names (default state: OFF)
- Exact ENV var names and example values
- Exact secret handling (masked in logs, encrypted at rest)
- Exact log messages for key events
- Exact metric names and dimensions
- Exact alert conditions and thresholds

### Telemetry & Observability
**Required:** Specify EXACT telemetry for production monitoring:

**Logs:**
- Event name (e.g., `document.upload.started`)
- Log level (info/warn/error)
- Structured fields (e.g., `{user_id, file_size, mime_type}`)
- Secrets to mask (e.g., API keys, tokens)

**Metrics:**
- Metric name (e.g., `document.upload.duration_ms`)
- Metric type (counter/gauge/histogram)
- Dimensions (e.g., `{org_id, status, file_type}`)
- Measurement location (e.g., which service/method)

**Alerts:**
- Alert name
- Condition (e.g., `error_rate > 5% over 5 minutes`)
- Severity (page/warn/info)
- Runbook link (where to troubleshoot)

### Data Migration & Backfill
**Required (if schema changes):** Specify EXACT migration/backfill plan:

**Migration:**
- Migration file name
- Exact DDL statements
- Reversibility (down migration)
- Estimated duration (for large tables)

**Backfill (if needed):**
- Backfill script location
- Batch size and rate limiting
- Dry-run command (test without writing)
- Production command (actual backfill)
- Progress tracking (how to monitor)
- Rollback/cleanup steps

### Documentation
- Decision doc entries (list decisions to document with rationale)
- README/operational runbooks (sections to add/update)
- Release notes (user-facing changes)

---

## Acceptance Criteria (Prescriptive - No Ambiguity)

**INSTRUCTIONS:** Write testable criteria with EXACT expected behavior. No generic statements.

### Validation Rules
**Required:** List ALL validations in EXACT execution order with:
- Exact validation logic
- Exact error message (word-for-word)
- Exact response status code

### Sample Payloads & Responses
**Required:** Provide EXACT examples for:
- Success case (with all fields)
- Each error case (with exact error message)

### Telemetry Verification
**Required:** Specify EXACT telemetry expectations:
- [ ] Logs emitted with correct level and structured fields
- [ ] Metrics incremented with correct dimensions
- [ ] Alerts configured with correct thresholds
- [ ] Secrets masked in logs (API keys, tokens, passwords)
- [ ] Performance measured at specified locations

### Feature Flags & Secrets
**Required:** Specify EXACT flag/secret behavior:
- [ ] Feature flag defaults to OFF (safe default)
- [ ] Feature flag can be toggled without deploy
- [ ] Secrets never logged in plaintext
- [ ] Secrets encrypted at rest
- [ ] Missing secrets fail gracefully with clear error

### Accessibility Requirements
**Required:** Specify EXACT requirements:
- Keyboard navigation (Tab order, Enter/Esc behavior)
- Focus management (where focus goes on open/close)
- ARIA labels (exact aria-label text)
- Screen reader announcements (aria-live regions)
- Color contrast (WCAG level)
- Responsive breakpoints (exact pixel values)

### Cross-Browser Support
**Required:** List minimum browser versions

### Performance Targets
**Required:** Specify EXACT targets with measurement method:
- Page load (P95 latency, how measured)
- Action latency (e.g., button click to response)
- Batch operations (e.g., max items, max time)

---

## Test Plan (Comprehensive)

**INSTRUCTIONS:** Write EXACT test cases for each layer. Use [ ] checkboxes.

### Unit Tests
**Required:** For each model/service/job, list:
- Happy path test cases
- Edge cases (empty, null, special characters, UTF-8, large values)
- Error cases (invalid input, missing data)

### Integration Tests
**Required:** For each endpoint/integration point, list:
- Request → Response test cases
- Database interaction test cases
- Queue/job enqueue test cases
- Error handling test cases

### System Tests (End-to-End)
**Required:**
- [ ] Happy path: User flow from start to finish
- [ ] Unhappy paths: Each error scenario with expected UI behavior

### Accessibility Tests
**Required:**
- [ ] Keyboard navigation: Tab reaches all elements, Enter/Esc work
- [ ] Screen reader: ARIA labels present, announcements work
- [ ] Focus management: Focus trapped in modals, returns on close

### Browser Verification Tests
**Required:** Test in actual browsers (not just headless):
- [ ] Focus management: Focus moves correctly on open/close
- [ ] Component placement: Modals/dialogs render in correct DOM location
- [ ] Cross-browser: Test in major browsers
- [ ] Responsive: Test at mobile, tablet, desktop breakpoints
- [ ] Keyboard shortcuts: All shortcuts work as specified

**Why:** Headless tests miss focus/portal bugs that only appear in real browsers.

### Telemetry Tests
**Required:** Verify observability in tests:
- [ ] Logs: Assert log messages emitted with correct fields
- [ ] Metrics: Assert metrics incremented with correct dimensions
- [ ] Secrets: Assert secrets masked in log output
- [ ] Alerts: Verify alert conditions trigger correctly

### Performance Tests
**Required:**
- [ ] Metric 1: Target value, measurement method
- [ ] Metric 2: Target value, measurement method

### Data Migration Tests (if applicable)
**Required:** Verify backfill/migration safety:
- [ ] Dry-run: Script runs without errors in dry-run mode
- [ ] Idempotency: Running twice produces same result
- [ ] Rollback: Rollback script restores original state
- [ ] Progress: Progress tracking works
- [ ] Rate limiting: Respects rate limits (doesn't overload DB)

---

## Rollout Plan (Staged)

**INSTRUCTIONS:** Define EXACT rollout stages with monitoring.

### Environments & Stages
**Required:** For each stage, specify:
- Environment (dev/staging/production)
- Feature flag state (on/off/percentage)
- Duration (hours/days)
- Success criteria (metrics to check)
- Go/no-go decision criteria

### Monitoring & Alerts
**Required:**
- Metrics to track (exact names, dimensions)
- Alert conditions (exact thresholds, time windows)
- Alert destinations (page/warn/info)

### Rollback Plan
**Required:**
- Rollback trigger conditions (exact thresholds)
- Rollback steps (exact commands/actions)
- Data cleanup steps (if needed)

## Deferred / Future Work
- Items explicitly deferred to later; link to DEFERRED_FEATURES entries.

## Open Questions
- List unknowns blocking completion; assign owners.

---

## Framework-Specific Gotchas (Check Before Implementing)

**INSTRUCTIONS:** Review your tech stack's pattern library and add gotchas specific to this feature.

### Common Gotchas to Check
<!-- Customize for your stack. Examples: -->
- [ ] **UI Components + Portals:** If using modal/dialog/sheet components, is controller scope correct?
- [ ] **Real-time Updates:** Using correct module paths for broadcasts?
- [ ] **File Attachments:** Calling reload after attaching files in tests?
- [ ] **Template Elements:** Avoiding dynamic behavior inside template tags?
- [ ] **Nested Components:** No duplicate IDs in nested structures?

**Reference:** Check your app's pattern library for framework-specific details.

---

## Two-Stage Specification Workflow

**Context:** This workflow produces 95%+ complete specs before implementation.

### Stage 0: Discovery Phase (REQUIRED)
**Time:** 30-45 minutes
**Output:** Completed "Current State & Constraints" section

**See "Discovery Phase (REQUIRED)" section below for full checklist.**

### Stage 1: Draft Specification
**Time:** 2-4 hours
**Output:** 80%+ complete spec with exact code snippets

**Requirements:**
- EXACT error strings (not "appropriate error message")
- EXACT validation order (not "validate inputs")
- EXACT payload/response examples (not "return JSON")
- EXACT code snippets for all components
- NO implementation decisions left

### Stage 2: Enhance Specification
**Time:** 1-2 hours
**Output:** 95%+ complete spec ready for implementation

**Focus:**
- Edge cases (empty, null, special chars, UTF-8, large values)
- Integration points (real-time updates, file storage, jobs)
- Framework gotchas (component scope, nesting, lifecycle)
- Accessibility (ARIA, keyboard, screen reader)
- Test coverage gaps (negative paths, error handling)
- Telemetry/alerting (metrics, logs, alerts)

### Stage 3: Implement
**Rules:**
- NO new decisions during implementation
- If spec is ambiguous → ask for clarification (don't guess)
- If spec is wrong → update spec first, then implement
- Follow spec exactly (copy-paste code snippets)

### Stage 4: Verify
**Checklist:**
- [ ] All tests pass
- [ ] All acceptance criteria met
- [ ] Browser verification complete (not just "tests pass")
- [ ] All metrics tracked
- [ ] All accessibility requirements met

---

## Implementation Phases

**INSTRUCTIONS:** Break work into phases with clear deliverables.

**Example structure:**
- Phase 1: Schema + migrations
- Phase 2: Backend services/jobs
- Phase 3: Frontend components
- Phase 4: Integration + tests
- Phase 5: Rollout

---

## Deferred Features (P2/P3)

**INSTRUCTIONS:** When archiving this PRD, extract deferred items to GitHub Issues.

**Format for each deferred item:**

### [Feature Name] (P2/P3)

**Why deferred:** [Brief reason]

**Description:**
[What it does]

**Acceptance criteria:**
- [ ] Criterion 1
- [ ] Criterion 2

**GitHub Issue:** [Add link when created: #123]

**Template for GitHub Issue:**
```
Title: [Feature Name] (P2/P3 from {{PRD_NAME}})

## Context
Originally scoped in: {{path/to/prd}}
Priority: P2 (or P3)
Deferred because: [reason from above]

## Description
[Copy from above]

## Acceptance Criteria
[Copy from above]

## Links
- PRD: [Link to GitHub view of this file]
- Related Issues: [Any dependencies]
```

---

## Discovery Phase (REQUIRED)

**⚠️ COMPLETE THIS BEFORE WRITING ANY SPEC SECTIONS ABOVE**

### Codebase Discovery (15-20 min)

**Search for similar features/patterns:**
- [ ] Find similar features in codebase (search by functionality)
- [ ] Check models directory for relevant model names (don't assume names)
- [ ] Check schema for existing tables/columns
- [ ] Check services directory for existing service patterns
- [ ] Check controllers/handlers for existing patterns
- [ ] Check tests for existing test patterns
- [ ] Check jobs for existing background job patterns

**Search for existing observability patterns:**
- [ ] Search for existing feature flags
- [ ] Search for existing metrics patterns
- [ ] Search for existing log patterns
- [ ] Search for existing alerts
- [ ] Note naming conventions (don't invent new names unnecessarily)

**Document findings in "Current State & Constraints" section.**

### Framework Discovery (10-15 min)

**Check framework patterns (customize for your stack):**
- [ ] Check component registration patterns
- [ ] Search for similar UI components
- [ ] Search for existing real-time update usage
- [ ] Check component library integration
- [ ] Check file upload configuration (if applicable)

**Reference:** Your app's pattern library

### Integration Discovery (10-15 min)

**Check integration patterns:**
- [ ] Search for existing background job patterns
- [ ] Search for real-time broadcasting patterns
- [ ] Search for modal/dialog/portal component usage
- [ ] Search for existing validation patterns
- [ ] Check routing for similar route patterns

### Output

**Document ALL findings in "Current State & Constraints" section with:**
- Exact model names found (not assumed)
- Exact service class names and method signatures
- Links to similar features (file paths)
- Exact patterns to follow (code snippets)
- Exact schema state (table/column names)

**Why This Matters:** Discovery prevents reinventing patterns and speeds up implementation significantly.
