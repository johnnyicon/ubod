#!/bin/bash

# =============================================================================
# Skill Foundry Validation Script
# =============================================================================
#
# Validates skill-foundry deployment in consuming monorepo.
#
# What it checks:
#   1. Meta-skill exists and has valid structure
#   2. Agent exists and has valid structure
#   3. Scripts (if installed) are executable
#   4. References (if installed) exist
#   5. Examples (if installed) are complete
#   6. VS Code can discover meta-skill and agent
#
# Usage:
#   ./validate-all.sh
#   ./validate-all.sh --verbose
#
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Flags
VERBOSE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Validate skill-foundry deployment."
            echo ""
            echo "Options:"
            echo "  --verbose      Show detailed validation output"
            echo "  --help         Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Logging functions
log_info() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}ℹ${NC} $1"
    fi
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo ""
    echo -e "${CYAN}======================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}======================================${NC}"
}

# =============================================================================
# Environment Detection
# =============================================================================

detect_environment() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Find ubod root
    if [[ "$SCRIPT_DIR" == *"/tools/skill-foundry"* ]]; then
        UBOD_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
        MONOREPO_DIR="$(dirname "$(dirname "$UBOD_DIR")")"
    else
        log_error "Cannot detect ubod directory"
        exit 1
    fi
    
    log_info "Validating deployment in: $MONOREPO_DIR"
}

# =============================================================================
# Validation Functions
# =============================================================================

validate_meta_skill() {
    print_header "Validating Meta-Skill"
    
    local skill_file="$MONOREPO_DIR/.github/skills/skill-foundry/SKILL.md"
    
    if [ ! -f "$skill_file" ]; then
        log_error "Meta-skill not found: $skill_file"
        return 1
    fi
    
    log_success "Meta-skill exists"
    
    # Check frontmatter
    if grep -q "^---$" "$skill_file" && grep -q "^name:" "$skill_file" && grep -q "^description:" "$skill_file"; then
        log_success "Meta-skill has valid frontmatter"
    else
        log_error "Meta-skill missing required frontmatter (name, description)"
        return 1
    fi
    
    # Check key sections
    if grep -q "## When to Use" "$skill_file"; then
        log_success "Meta-skill has 'When to Use' section"
    else
        log_warning "Meta-skill missing 'When to Use' section"
    fi
    
    if grep -q "## Quick Commands" "$skill_file" || grep -q "## Commands" "$skill_file"; then
        log_success "Meta-skill has commands section"
    else
        log_warning "Meta-skill missing commands section"
    fi
    
    return 0
}

validate_agent() {
    print_header "Validating Agent"
    
    local agent_file="$MONOREPO_DIR/.github/agents/skill-foundry.agent.md"
    
    if [ ! -f "$agent_file" ]; then
        log_error "Agent not found: $agent_file"
        return 1
    fi
    
    log_success "Agent exists"
    
    # Check frontmatter
    if grep -q "^---$" "$agent_file" && grep -q "^name:" "$agent_file" && grep -q "^description:" "$agent_file" && grep -q "^tools:" "$agent_file"; then
        log_success "Agent has valid frontmatter"
    else
        log_error "Agent missing required frontmatter (name, description, tools)"
        return 1
    fi
    
    # Check schema compliance
    local errors=0
    
    if grep -q "## ROLE" "$agent_file"; then
        log_success "Agent has ROLE section"
    else
        log_error "Agent missing ROLE section"
        ((errors++))
    fi
    
    if grep -q "## COMMANDS" "$agent_file"; then
        log_success "Agent has COMMANDS section"
    else
        log_error "Agent missing COMMANDS section"
        ((errors++))
    fi
    
    if grep -q "## BOUNDARIES" "$agent_file"; then
        log_success "Agent has BOUNDARIES section"
    else
        log_error "Agent missing BOUNDARIES section"
        ((errors++))
    fi
    
    if grep -q "## SCOPE" "$agent_file"; then
        log_success "Agent has SCOPE section"
    else
        log_error "Agent missing SCOPE section"
        ((errors++))
    fi
    
    if grep -q "## WORKFLOW" "$agent_file"; then
        log_success "Agent has WORKFLOW section"
    else
        log_error "Agent missing WORKFLOW section"
        ((errors++))
    fi
    
    # Check BOUNDARIES format (should have emoji icons)
    if grep -E "^(✅|⚠️|🚫)" "$agent_file" > /dev/null; then
        log_success "Agent BOUNDARIES uses correct emoji format"
    else
        log_warning "Agent BOUNDARIES may not use correct emoji format"
    fi
    
    return $errors
}

validate_scripts() {
    print_header "Validating Scripts"
    
    local scripts_dir="$MONOREPO_DIR/.github/skills/skill-foundry/scripts"
    
    if [ ! -d "$scripts_dir" ]; then
        log_info "Scripts not installed (optional)"
        return 0
    fi
    
    log_success "Scripts directory exists"
    
    # Check validate.py
    if [ -f "$scripts_dir/validate.py" ]; then
        log_success "validate.py exists"
        
        # Try to run it (dry-run style)
        if python3 -m py_compile "$scripts_dir/validate.py" 2>/dev/null; then
            log_success "validate.py is valid Python"
        else
            log_error "validate.py has syntax errors"
            return 1
        fi
    else
        log_warning "validate.py missing"
    fi
    
    # Check scaffold.py
    if [ -f "$scripts_dir/scaffold.py" ]; then
        log_success "scaffold.py exists"
        
        if python3 -m py_compile "$scripts_dir/scaffold.py" 2>/dev/null; then
            log_success "scaffold.py is valid Python"
        else
            log_error "scaffold.py has syntax errors"
            return 1
        fi
    else
        log_warning "scaffold.py missing"
    fi
    
    return 0
}

validate_references() {
    print_header "Validating References"
    
    local refs_dir="$MONOREPO_DIR/.github/skills/skill-foundry/references"
    
    if [ ! -d "$refs_dir" ]; then
        log_info "References not installed (optional)"
        return 0
    fi
    
    log_success "References directory exists"
    
    local expected_refs=(
        "BEST_PRACTICES.md"
        "AGENT_PATTERNS.md"
        "SKILL_ANATOMY.md"
        "QUICK_START.md"
        "PORTABILITY.md"
    )
    
    local found=0
    for ref in "${expected_refs[@]}"; do
        if [ -f "$refs_dir/$ref" ]; then
            log_success "$ref exists"
            ((found++))
        else
            log_warning "$ref missing"
        fi
    done
    
    log_info "Found $found of ${#expected_refs[@]} reference docs"
    
    return 0
}

validate_examples() {
    print_header "Validating Examples"
    
    local examples_dir="$MONOREPO_DIR/.github/skills/skill-foundry/examples"
    
    if [ ! -d "$examples_dir" ]; then
        log_info "Examples not installed (optional)"
        return 0
    fi
    
    log_success "Examples directory exists"
    
    # Check hello-world example
    if [ -d "$examples_dir/hello-world" ]; then
        log_success "hello-world example exists"
        
        if [ -f "$examples_dir/hello-world/SKILL.md" ]; then
            log_success "hello-world/SKILL.md exists"
        else
            log_warning "hello-world/SKILL.md missing"
        fi
        
        if [ -f "$examples_dir/hello-world/README.md" ]; then
            log_success "hello-world/README.md exists"
        else
            log_warning "hello-world/README.md missing"
        fi
    else
        log_warning "hello-world example missing"
    fi
    
    return 0
}

validate_vs_code_discovery() {
    print_header "Validating VS Code Discovery"
    
    # Check .vscode/settings.json exists
    local settings_file="$MONOREPO_DIR/.vscode/settings.json"
    
    if [ ! -f "$settings_file" ]; then
        log_warning "No .vscode/settings.json found"
        log_info "VS Code will use default discovery paths"
        return 0
    fi
    
    log_success ".vscode/settings.json exists"
    
    # Check if skill-foundry is referenced (optional enhancement)
    if grep -q "skill-foundry" "$settings_file" 2>/dev/null; then
        log_success "skill-foundry referenced in settings.json"
    else
        log_info "skill-foundry not explicitly referenced (will use default paths)"
    fi
    
    return 0
}

# =============================================================================
# Summary
# =============================================================================

print_summary() {
    print_header "Validation Summary"
    
    echo ""
    echo "Core Components:"
    echo "  Meta-skill: $META_SKILL_STATUS"
    echo "  Agent: $AGENT_STATUS"
    echo ""
    echo "Optional Components:"
    echo "  Scripts: $SCRIPTS_STATUS"
    echo "  References: $REFERENCES_STATUS"
    echo "  Examples: $EXAMPLES_STATUS"
    echo ""
    
    if [ "$VALIDATION_ERRORS" -eq 0 ]; then
        log_success "All validations passed"
        echo ""
        log_info "Next steps:"
        log_info "  1. Reload VS Code (Cmd+Shift+P → 'Reload Window')"
        log_info "  2. Open .github/skills/skill-foundry/SKILL.md to verify it loads"
        log_info "  3. Type '@skill' in Copilot Chat to find Skill Foundry agent"
        log_info "  4. Create your first skill using the agent or meta-skill"
        return 0
    else
        log_error "Validation failed with $VALIDATION_ERRORS errors"
        return 1
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "Skill Foundry Validation"
    
    # Detect environment
    detect_environment
    
    # Run validations
    VALIDATION_ERRORS=0
    
    validate_meta_skill
    META_SKILL_STATUS=$?
    VALIDATION_ERRORS=$((VALIDATION_ERRORS + META_SKILL_STATUS))
    
    validate_agent
    AGENT_STATUS=$?
    VALIDATION_ERRORS=$((VALIDATION_ERRORS + AGENT_STATUS))
    
    validate_scripts
    SCRIPTS_STATUS=$?
    
    validate_references
    REFERENCES_STATUS=$?
    
    validate_examples
    EXAMPLES_STATUS=$?
    
    validate_vs_code_discovery
    
    # Print summary
    print_summary
    return $?
}

main
