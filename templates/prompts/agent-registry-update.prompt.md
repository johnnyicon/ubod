---
name: agent-registry-update
description: "Generate/update agents-registry.yaml by scanning agent files and extracting metadata for intelligent routing"
tags: [agents, registry, orchestration, routing, maintenance, discovery]
estimatedTime: 5 minutes
---

# Agent Registry Update

Generate and maintain `agents-registry.yaml` by scanning agent files and extracting routing metadata. Enables orchestrators to discover and route to specialist agents programmatically using semantic matching.

**Purpose:** Machine-readable registry for agent discovery and intelligent routing decisions

**Output:** `.github/agents/agents-registry.yaml`

---

## Configuration

**Before first use, configure these settings:**

1. **App Prefix** - Your agent naming convention (e.g., `myapp-`, `tala-`, `acme-`)
2. **Exclude Patterns** - Internal agents to skip (e.g., `test-*`, `internal-*`)
3. **Registry Path** - Default: `.github/agents/agents-registry.yaml`

**Example:**
```yaml
# In this prompt, replace:
APP_PREFIX="myapp"  # Your app name
EXCLUDE_PATTERNS="test-|internal-|orchestration-designer"
```

---

## Step 1: Determine Mode

**Two operational modes:**

1. **INITIALIZE** - Create registry from scratch (first-time setup)
   - Scan all agent files in `.github/agents/`
   - Extract frontmatter metadata
   - Infer domains/keywords from descriptions
   - Generate complete registry file

2. **REFRESH** - Rescan all agents and regenerate registry (manual maintenance)
   - Scan all agent files
   - Detect new agents, removed agents, updated descriptions
   - Regenerate entire registry
   - Report changes detected

**User specifies mode via:**
- `/agent-registry-update` → INITIALIZE (if no registry) or REFRESH (if registry exists)
- `/agent-registry-update refresh` → REFRESH (force regeneration)

---

## Step 2: Scan Agent Files

**Find all agent files:**

```bash
find .github/agents -name "*.agent.md" -type f | sort
```

**Filter by app prefix (if configured):**
```bash
# If APP_PREFIX is set (e.g., "myapp")
find .github/agents -name "${APP_PREFIX}-*.agent.md" -type f | sort
```

**Exclude internal agents:**
```bash
# Apply EXCLUDE_PATTERNS (e.g., "test-|internal-")
grep -v -E "EXCLUDE_PATTERNS"
```

**Discovery logic:**
```
Read directory: .github/agents/
Filter: *.agent.md (or {APP_PREFIX}-*.agent.md if set)
Exclude: Patterns in EXCLUDE_PATTERNS
Sort: Alphabetically
```

---

## Step 3: Extract Metadata from Each Agent

**For each agent file:**

1. **Read frontmatter** (YAML between `---` delimiters):
   ```yaml
   ---
   name: Agent Name
   description: What this agent does and when to use it
   tools: ["read", "search", "edit", "create_file"]
   infer: true
   handoffs: [...]
   ---
   ```

2. **Extract required fields:**
   - `name` → Agent display name
   - `description` → Full description (used for routing decisions)
   - `tools` → List of tools agent uses (optional metadata)

3. **Infer routing metadata from description:**
   
   **Domains** (primary capabilities - customize for your app):
   - **prd/design** → Keywords: prd, design, specification, requirements, feature design
   - **discovery** → Keywords: discover, find, search, patterns, examples, existing
   - **ui/ux** → Keywords: ui, ux, design system, component, viewcomponent, frontend
   - **implementation** → Keywords: implement, build, code, create, develop, feature
   - **testing** → Keywords: test, verify, qa, integration, validation
   - **verification** → Keywords: verify, validate, check, audit, review correctness
   - **documentation** → Keywords: document, docs, readme, guide, update documentation
   - **architecture** → Keywords: architecture, system design, technical design, api design
   - **security** → Keywords: security, auth, permissions, vulnerabilities, audit
   - **performance** → Keywords: performance, optimization, profiling, benchmarks

   **Keywords** (for semantic matching):
   - Extract significant nouns/verbs from description
   - Convert to lowercase
   - Include both domain terms and task-specific terms
   - Examples: prd, feature, design, discover, patterns, implement, test, verify, document

4. **Determine complexity** (from description hints or workflow length):
   - `simple` → Quick tasks, single-step, < 5 min (file reads, quick checks)
   - `multi-step` → Workflow with phases, 10-30 min (implementation, testing)
   - `comprehensive` → Deep analysis, 20+ min (architecture, discovery, planning)

**Metadata structure:**
```yaml
agent-name:
  file: agent-name.agent.md
  name: Human-Readable Agent Name
  description: "Full description from frontmatter..."
  domains: [domain1, domain2, domain3]
  keywords: [keyword1, keyword2, keyword3, ...]
  complexity: simple|multi-step|comprehensive
  tools: [agent, read, search, edit, create_file, execute]
```

---

## Step 4: Categorize Agents by Primary Domain

**Group agents into categories for easy browsing:**

```yaml
categories:
  planning:
    description: "Discovery, planning, and requirements"
    agents:
      - discovery-agent
      - prd-agent
  
  design:
    description: "UI/UX design and design system"
    agents:
      - ui-designer
      - design-system
  
  implementation:
    description: "Feature development and coding"
    agents:
      - implementer
  
  verification:
    description: "Testing, verification, and quality assurance"
    agents:
      - verifier
      - tester
  
  documentation:
    description: "Documentation maintenance and review"
    agents:
      - docs-updater
      - docs-reviewer
```

**Categorization rules:**
- Primary domain = first domain in `domains` list
- Agents can appear in multiple categories if multi-domain
- Categories match common workflows (discovery → design → implement → verify → document)
- Customize categories to match your team's workflow

---

## Step 5: Generate Routing Patterns

**Create semantic routing hints for common request patterns:**

```yaml
routing:
  default_behavior: semantic_match  # semantic_match | ask_if_ambiguous | show_menu
  fallback: handle_directly         # handle_directly | error | ask
  
  # Routing patterns for common user requests
  patterns:
    - keywords: [prd, feature, design, specification, requirements]
      suggest: prd-enricher
      confidence: high
      note: "Feature design and requirements"
    
    - keywords: [discover, find, search, patterns, examples, existing]
      suggest: discovery-planner
      confidence: high
      note: "Codebase exploration and pattern discovery"
    
    - keywords: [implement, build, code, create, develop]
      suggest: implementer
      confidence: high
      note: "Feature implementation"
    
    - keywords: [test, verify, validate, qa, check]
      suggest: verifier
      confidence: high
      note: "Testing and verification"
    
    - keywords: [document, docs, readme, guide, update-docs]
      suggest: docs-updater
      confidence: medium
      note: "Documentation updates"
```

**Confidence levels guide orchestrators:**
- **high** - Strong signal match, auto-route without asking
- **medium** - Partial match, ask user for confirmation
- **low** - Weak match, show as option but don't suggest strongly

---

## Step 6: Generate Registry Content

**Registry structure:**

```yaml
# Agent Registry
# Auto-generated by /agent-registry-update prompt
# Last Updated: {current_datetime}

version: "1.0"

# ======================================
# {APP_NAME} Agents
# ======================================

agents:
  
  agent-name:
    file: agent-name.agent.md
    name: Human-Readable Name
    description: "What this agent does..."
    domains: [domain1, domain2]
    keywords: [keyword1, keyword2, ...]
    complexity: simple|multi-step|comprehensive
    tools: [read, search, edit, create_file, agent, execute]
  
  # ... more agents

# ======================================
# Agent Categories (for organization)
# ======================================

categories:
  category-name:
    description: "What this category covers"
    agents:
      - agent-1
      - agent-2

# ======================================
# Routing Configuration (for orchestrators)
# ======================================

routing:
  default_behavior: semantic_match
  fallback: handle_directly
  
  patterns:
    - keywords: [...]
      suggest: agent-name
      confidence: high|medium|low
      note: "Why this routing pattern exists"

# ======================================
# Statistics
# ======================================

stats:
  total_agents: N
  by_complexity:
    simple: N
    multi-step: N
    comprehensive: N
  by_category:
    category1: N
    category2: N
  last_updated: "YYYY-MM-DD"
  generated_by: "/agent-registry-update prompt"
```

---

## Step 7: Write Registry File

**File location:** `.github/agents/agents-registry.yaml`

**Before writing:**
1. Show preview of generated YAML
2. Report changes detected (if REFRESH mode):
   ```
   Changes detected:
   - Added: new-agent.agent.md (domain: implementation)
   - Removed: old-agent.agent.md
   - Updated: existing-agent.agent.md (description changed)
   ```
3. Ask for confirmation: "Generate registry? (Y/n)"

**After writing:**
```
✅ **AGENT REGISTRY UPDATED**

File: .github/agents/agents-registry.yaml
Total agents: N
Categories: N
New routing patterns: N

Next steps:
- Orchestrators will auto-load this registry for routing decisions
- Run this prompt after creating/updating/removing agents
- Orchestrators use `domains` and `keywords` for semantic matching
```

---

## Step 8: Validation

**Validate generated YAML:**

1. **Syntax check:** Valid YAML structure (no parse errors)
2. **Required fields:** All agents have `file`, `name`, `description`, `domains`, `keywords`
3. **File existence:** All referenced `.agent.md` files exist
4. **No duplicates:** Each agent appears only once
5. **Category references:** All category agent lists reference valid agents
6. **Routing references:** All routing patterns reference valid agents

**If validation fails:**
- Report errors with specific line numbers
- Do not write file
- Provide actionable fix suggestions

---

## Usage Examples

### Initialize Registry (First Time)
```
User: /agent-registry-update

Agent:
Scanning .github/agents/ for agent files...
Found 9 agents matching pattern: myapp-*.agent.md

Extracting metadata...
- myapp-prd-enricher: prd, design, architecture
- myapp-discovery: discovery, planning, patterns
- myapp-implementer: implementation, coding
- myapp-verifier: verification, testing
- myapp-docs: documentation

Categorizing agents...
- Planning: 2 agents
- Design: 1 agent
- Implementation: 1 agent
- Verification: 1 agent
- Documentation: 1 agent

[Shows preview of YAML]

Generate registry? (Y/n)
```

### Refresh After Changes
```
User: /agent-registry-update refresh

Agent:
Rescanning .github/agents/...

Changes detected:
✅ Added: myapp-security-auditor.agent.md (verification, security)
⚠️ Updated: myapp-implementer.agent.md (description enhanced)
❌ Removed: myapp-old-agent.agent.md

[Shows updated YAML preview with diff highlights]

Update registry? (Y/n)
```

---

## Integration Examples

### For Orchestrators

**Load registry at startup:**
```markdown
## WORKFLOW Phase 1: Load Registry

read_file(".github/agents/agents-registry.yaml")

Parse registry:
- Available specialists: {{agents}}
- Categories: {{categories}}
- Routing patterns: {{routing.patterns}}
```

**Match user request to specialist:**
```typescript
// Extract keywords from user request
const userKeywords = extractKeywords(userRequest);

// Find best match in registry
for (const pattern of registry.routing.patterns) {
  const matchScore = calculateMatch(userKeywords, pattern.keywords);
  
  if (matchScore > 0.9) {
    // High confidence - auto-route
    return { agent: pattern.suggest, confidence: 'high' };
  } else if (matchScore > 0.6) {
    // Medium confidence - ask user
    return { agent: pattern.suggest, confidence: 'medium' };
  }
}

// Low confidence - show options or handle directly
return { confidence: 'low', options: [...] };
```

### For Agent Writers

**After creating new agent:**
```markdown
**Next steps:**
- Run `/agent-registry-update` to add this agent to routing registry
- Update description with clear keywords for routing (prd, design, implement, etc.)
- Test orchestrator can discover and route to this agent
```

---

## Customization Guide

### Adapting for Your App

**1. Set app prefix:**
```yaml
APP_PREFIX="myapp"  # Used in filename: myapp-*.agent.md
```

**2. Define your domains:**
```yaml
# Common domains across industries:
- planning/discovery
- design/architecture  
- implementation/development
- verification/testing
- documentation
- security
- performance
- deployment
- monitoring

# Add domain-specific ones:
- data-processing (for data apps)
- ml-training (for ML apps)
- content-moderation (for social apps)
```

**3. Customize categories:**
```yaml
categories:
  # Match your team's workflow
  planning: [...]
  design: [...]
  implement: [...]
  test: [...]
  deploy: [...]
```

**4. Tune confidence thresholds:**
```yaml
# Adjust based on agent precision/recall
high_confidence: 0.90  # Auto-route
medium_confidence: 0.60  # Ask user
low_confidence: 0.40  # Show as option
```

---

## Edge Cases

### No Agents Found
```
❌ No agents found matching pattern: {APP_PREFIX}-*.agent.md

Expected location: .github/agents/
Expected pattern: myapp-*.agent.md

Cannot generate registry without agents.
```

### Invalid Frontmatter
```
⚠️ Warning: myapp-example.agent.md has invalid frontmatter
- Missing required field: description
- Skipping this agent

Continue with remaining agents? (Y/n)
```

### Registry Already Exists (INITIALIZE mode)
```
ℹ️ Registry already exists: .github/agents/agents-registry.yaml

Switch to REFRESH mode to regenerate? (Y/n)
```

### Conflicting Categories
```
⚠️ Warning: Agent appears in multiple primary categories
- myapp-hybrid-agent listed in both 'planning' and 'design'
- Using first domain as primary: planning

Continue? (Y/n)
```

---

## Maintenance

**When to run:**
- ✅ After creating new agents
- ✅ After updating agent descriptions
- ✅ After removing agents
- ✅ When routing patterns aren't working (stale keywords)
- ❌ NOT needed for code changes (only when agents change)

**Frequency:** On-demand, not automated (git hook could trigger on agent file changes)

---

## Notes

**Design Principles:**
- **DRY:** Agents describe themselves once (frontmatter), registry auto-derives
- **Single Source of Truth:** Agent files are authoritative, registry is derived
- **Low Maintenance:** Only run when agents change, not on every code edit
- **Extensible:** Add custom fields to registry without changing agent files

**Performance:** Scanning 50+ agents takes < 5 seconds

**Validation:** Always validate before writing to catch errors early

---

## See Also

- **Agent Schema:** `ubod-meta/schemas/agent-schema.md`
- **Registry Format:** `ubod-meta/schemas/agent-registry-schema.md`
- **Orchestration Guide:** `ubod-meta/docs/multi-agent-orchestration-guide.md`
- **Case Study:** `ubod-meta/docs/case-studies/tala-orchestrator.md`
