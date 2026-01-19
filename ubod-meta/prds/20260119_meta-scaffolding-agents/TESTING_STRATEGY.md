# Testing Strategy

**PRD:** ubod Meta-Scaffolding Agents  
**Date:** 2026-01-19

---

## Test Pyramid

```
        /\
       /  \
      / E2E \        5-8 tests per agent
     /------\
    /  Integ  \      8-12 tests per agent
   /----------\
  /    Unit     \    15-20 tests per agent
 /--------------\
```

**Total Test Count:** 85-120 tests (across 3 agents)

---

## Per-PRD Test Plans

### PRD-01: Instruction Writer Agent (30-40 tests)

#### Unit Tests (15-20 tests)

**Spec Parser Module:**
- ✅ Reads spec file successfully
- ✅ Extracts required frontmatter fields
- ✅ Extracts optional frontmatter fields with defaults
- ✅ Handles missing spec file gracefully
- ✅ Parses section structure correctly

**Question Generator Module:**
- ✅ Generates questions for required fields
- ✅ Skips questions for auto-filled fields
- ✅ Validates glob patterns
- ✅ Suggests corrections for invalid patterns

**Artifact Generator Module:**
- ✅ Generates valid YAML frontmatter
- ✅ Populates sections from user input
- ✅ Formats code examples as blocks
- ✅ Handles missing optional sections

**Validator Module:**
- ✅ Detects missing required fields
- ✅ Validates glob pattern syntax
- ✅ Checks section structure vs spec
- ✅ Reports multiple violations

#### Integration Tests (8-12 tests)

**End-to-End Workflows:**
- ✅ Simple instruction (minimal fields)
- ✅ Complex instruction (all optional fields)
- ✅ With code examples
- ✅ With multiple applyTo patterns
- ✅ Invalid input → error → correction → success
- ✅ Iterative refinement (change field after generation)

**Platform Variants:**
- ✅ VS Code spec
- ✅ GitHub Copilot spec (if supported)

#### Validation Tests (5-8 tests)

**Against Real Artifacts:**
- ✅ Regenerate `tala-design-system.instructions.md`
- ✅ Regenerate `discovery-methodology.instructions.md`
- ✅ Regenerate `universal-critical-rules.instructions.md`
- ✅ Compare generated vs original (90%+ match)

---

### PRD-02: Prompt Writer Agent (28-38 tests)

#### Unit Tests (12-18 tests)

**Spec Parser:** (Same as PRD-01, shared module)

**Step Collector Module:**
- ✅ Collects steps iteratively
- ✅ Allows multi-line step descriptions
- ✅ Numbers steps sequentially
- ✅ Handles substeps

**Success Criteria Formatter:**
- ✅ Formats as checklist (- [ ] format)
- ✅ Preserves user wording
- ✅ Handles multi-line criteria

**Tag Suggester:**
- ✅ Extracts keywords from workflow name
- ✅ Suggests relevant tags
- ✅ Allows custom tags

**Time Estimator:**
- ✅ Estimates based on step count
- ✅ Allows manual override
- ✅ Provides range (25-30 minutes)

#### Integration Tests (8-12 tests)

**End-to-End Workflows:**
- ✅ Simple workflow (3 steps)
- ✅ Complex workflow (8+ steps with substeps)
- ✅ With prerequisites
- ✅ Without optional fields
- ✅ Iterative step editing

#### Validation Tests (5-8 tests)

**Against Real Prompts:**
- ✅ Regenerate `create-prd.prompt.md`
- ✅ Regenerate `implement-phase.prompt.md`
- ✅ Compare generated vs original

---

### PRD-03: Agent Writer Agent (30-42 tests)

#### Unit Tests (15-22 tests)

**Mode Selector Module:**
- ✅ Presents mode options (CREATE/UPDATE/AUDIT)
- ✅ Handles multi-select
- ✅ Validates mode names

**Workflow Generator Module:**
- ✅ Generates per-mode workflows
- ✅ Maintains consistent structure
- ✅ Handles variable step counts per mode

**Boundary Formatter:**
- ✅ Formats always_do with ✅ emoji
- ✅ Formats never_do with ❌ emoji
- ✅ Maintains list structure

**Instruction Linker:**
- ✅ Finds related .instructions.md files
- ✅ Suggests based on domain keywords
- ✅ Allows manual selection

#### Integration Tests (8-12 tests)

**End-to-End Workflows:**
- ✅ Single-mode agent
- ✅ Multi-mode agent (CREATE + UPDATE)
- ✅ With instruction dependencies
- ✅ With examples section
- ✅ With COMMANDS section

#### Validation Tests (5-8 tests)

**Against Real Agents:**
- ✅ Regenerate `prd-writer.agent.md`
- ✅ Regenerate `tala-design-system.agent.md` (if exists)
- ✅ Compare generated vs original

---

## Shared Test Utilities

### Reusable Fixtures

```
fixtures/
├── specs/
│   ├── instruction-spec.md
│   ├── prompt-spec.md
│   └── agent-spec.md
├── inputs/
│   ├── simple-instruction.json
│   ├── complex-prompt.json
│   └── multi-mode-agent.json
└── expected/
    ├── simple-instruction.md
    ├── complex-prompt.md
    └── multi-mode-agent.md
```

### Assertion Helpers

```ruby
# Validate frontmatter
assert_valid_yaml(frontmatter)
assert_required_fields_present(frontmatter, [:applyTo])
assert_valid_glob_pattern(frontmatter[:applyTo])

# Validate structure
assert_sections_present(content, ["Purpose", "Rules"])
assert_checklist_format(success_criteria)
assert_emoji_boundaries(boundaries)
```

---

## Test Coverage Targets

| Module | Target | Rationale |
|--------|--------|-----------|
| Spec Parser | 95% | Critical path, reused by all agents |
| Question Generator | 85% | User-facing, high value |
| Artifact Generator | 90% | Core functionality |
| Validator | 95% | Catches errors, high impact |
| Overall | 85% | Balance coverage vs speed |

---

## Regression Testing

### Baseline Creation

**Step 1:** Generate baseline outputs
```bash
# For each agent, run with known inputs
@ubod-instruction-writer < fixtures/inputs/simple-instruction.json > baseline/simple-instruction.md
@ubod-prompt-writer < fixtures/inputs/complex-prompt.json > baseline/complex-prompt.md
@ubod-agent-writer < fixtures/inputs/multi-mode-agent.json > baseline/multi-mode-agent.md
```

**Step 2:** Version baselines
```bash
git add baseline/
git commit -m "test: baseline outputs for regression testing"
```

### Regression Detection

**On spec changes:**
```bash
# Regenerate outputs
make regenerate-baselines

# Compare
git diff baseline/

# If differences:
#  - Expected → Update baselines
#  - Unexpected → Fix agent
```

---

## Performance Testing

### Time Targets

| Operation | Target | Threshold |
|-----------|--------|-----------|
| Spec parsing | <100ms | <500ms |
| Question generation | <50ms | <200ms |
| Artifact generation | <200ms | <1s |
| Validation | <100ms | <500ms |
| **Total workflow** | **<5s** | **<10s** |

### Load Testing

Not critical (agents run locally, single-user), but verify:
- ✅ No memory leaks on repeated invocations
- ✅ File handles properly closed

---

## Test Execution

### CI/CD Integration

```yaml
# .github/workflows/test-ubod-agents.yml
name: Test ubod Meta-Agents

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run unit tests
        run: make test-unit
      - name: Run integration tests
        run: make test-integration
      - name: Run validation tests
        run: make test-validation
      - name: Check coverage
        run: make coverage-report
```

### Local Development

```bash
# Run all tests
make test

# Run specific suite
make test-unit
make test-integration
make test-validation

# Run specific agent tests
make test-instruction-writer
make test-prompt-writer
make test-agent-writer

# Watch mode (rerun on file changes)
make test-watch
```

---

## Test Maintenance

### When to Update Tests

**Spec changes:**
- Update fixtures with new required fields
- Update expected outputs
- Add tests for new validations

**Agent improvements:**
- Add tests for new features
- Update baselines if output format changes
- Deprecate tests for removed features

### Test Review Process

**Monthly:**
- Review flaky tests (pass/fail inconsistently)
- Check coverage gaps
- Remove obsolete tests

---

## Success Criteria

### Before Declaring PRD Complete

- ✅ All unit tests passing (100%)
- ✅ All integration tests passing (100%)
- ✅ Validation tests 90%+ matching original artifacts
- ✅ Coverage target met (85%+)
- ✅ No regressions vs baseline
- ✅ Performance targets met (<10s total workflow)

---

## Test Examples

### Example: Spec Parser Unit Test

```ruby
describe "SpecParser" do
  it "extracts required frontmatter fields" do
    spec = SpecParser.new("fixtures/instruction-spec.md")
    required = spec.required_fields
    
    assert_includes required, :applyTo
    assert_equal 1, required.length
  end
  
  it "extracts optional fields with defaults" do
    spec = SpecParser.new("fixtures/instruction-spec.md")
    optional = spec.optional_fields
    
    assert_equal "medium", optional[:priority][:default]
    assert_equal "1.0.0", optional[:version][:default]
  end
end
```

### Example: Integration Test

```ruby
describe "InstructionWriter end-to-end" do
  it "generates valid instruction from inputs" do
    inputs = {
      domain: "Test Domain",
      applyTo: "test/**/*",
      rules: ["Rule 1", "Rule 2"],
      priority: "high"
    }
    
    agent = InstructionWriter.new
    output = agent.generate(inputs)
    
    assert_valid_yaml(output.frontmatter)
    assert_includes output.content, "# Test Domain Instructions"
    assert_includes output.content, "- Rule 1"
  end
end
```

---

**Testing approach validated. Ready for implementation.**
