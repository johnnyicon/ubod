#!/bin/bash

# =============================================================================
# Skill Foundry Installation Script
# =============================================================================
#
# Deploys skill-foundry tool to consuming monorepo.
#
# What it does:
#   1. Copies meta-skill to .github/skills/skill-foundry/
#   2. Copies agent to .github/agents/
#   3. Copies validation/scaffolding scripts (optional)
#   4. Copies reference docs (optional)
#   5. Copies examples (optional)
#   6. Validates installation
#
# Usage:
#   ./install.sh                    # Install meta-skill + agent only (minimal)
#   ./install.sh --full             # Install everything (meta-skill + agent + scripts + references + examples)
#   ./install.sh --scripts          # Install meta-skill + agent + scripts
#   ./install.sh --references       # Install meta-skill + agent + references
#   ./install.sh --examples         # Install meta-skill + agent + examples
#   ./install.sh --dry-run          # Preview without changes
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
DRY_RUN=false
INSTALL_SCRIPTS=false
INSTALL_REFERENCES=false
INSTALL_EXAMPLES=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --full)
            INSTALL_SCRIPTS=true
            INSTALL_REFERENCES=true
            INSTALL_EXAMPLES=true
            shift
            ;;
        --scripts)
            INSTALL_SCRIPTS=true
            shift
            ;;
        --references)
            INSTALL_REFERENCES=true
            shift
            ;;
        --examples)
            INSTALL_EXAMPLES=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Install skill-foundry tool to consuming monorepo."
            echo ""
            echo "Options:"
            echo "  --full         Install everything (meta-skill + agent + scripts + references + examples)"
            echo "  --scripts      Include validation/scaffolding scripts"
            echo "  --references   Include reference documentation"
            echo "  --examples     Include example skills"
            echo "  --dry-run      Preview changes without making them"
            echo "  --help         Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                      # Minimal (meta-skill + agent only)"
            echo "  $0 --full               # Full installation"
            echo "  $0 --scripts --references  # Meta-skill + agent + scripts + references"
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
    echo -e "${CYAN}ℹ${NC} $1"
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

log_action() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Would: $1"
    else
        echo -e "${BLUE}→${NC} $1"
    fi
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
    
    # Verify we're in skill-foundry directory
    if [[ "$SCRIPT_DIR" != *"/tools/skill-foundry"* ]]; then
        log_error "Script must be run from tools/skill-foundry directory"
        exit 1
    fi
    
    # Find ubod root (2 levels up: tools/skill-foundry -> tools -> ubod)
    UBOD_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
    
    # Find monorepo root (2 levels up: ubod -> projects -> monorepo)
    MONOREPO_DIR="$(dirname "$(dirname "$UBOD_DIR")")"
    
    # Verify directories exist
    if [ ! -d "$UBOD_DIR/tools/skill-foundry" ]; then
        log_error "skill-foundry directory not found at $UBOD_DIR/tools/skill-foundry"
        exit 1
    fi
    
    if [ ! -d "$MONOREPO_DIR/.github" ]; then
        log_error ".github directory not found at $MONOREPO_DIR/.github"
        log_error "Run this from consuming monorepo with .github/ directory"
        exit 1
    fi
    
    log_info "Detected environment:"
    log_info "  Ubod: $UBOD_DIR"
    log_info "  Monorepo: $MONOREPO_DIR"
}

# =============================================================================
# Installation Functions
# =============================================================================

install_meta_skill() {
    print_header "Installing Meta-Skill"
    
    local source="$UBOD_DIR/tools/skill-foundry/skill-foundry/SKILL.md"
    local target_dir="$MONOREPO_DIR/.github/skills/skill-foundry"
    local target="$target_dir/SKILL.md"
    
    if [ ! -f "$source" ]; then
        log_error "Meta-skill not found: $source"
        return 1
    fi
    
    log_action "Copy: tools/skill-foundry/skill-foundry/SKILL.md → .github/skills/skill-foundry/SKILL.md"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp "$source" "$target"
        log_success "Meta-skill installed"
    fi
}

install_agent() {
    print_header "Installing Agent"
    
    local source="$UBOD_DIR/agents/skill-foundry-agent/AGENT.md"
    local target_dir="$MONOREPO_DIR/.github/agents"
    local target="$target_dir/skill-foundry-agent.agent.md"
    
    if [ ! -f "$source" ]; then
        log_error "Agent not found: $source"
        return 1
    fi
    
    log_action "Copy: agents/skill-foundry-agent/AGENT.md → .github/agents/skill-foundry-agent.agent.md"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp "$source" "$target"
        log_success "Agent installed"
    fi
}

install_scripts() {
    if [ "$INSTALL_SCRIPTS" = false ]; then
        return 0
    fi
    
    print_header "Installing Scripts"
    
    local source_dir="$UBOD_DIR/tools/skill-foundry/skill-foundry/scripts"
    local target_dir="$MONOREPO_DIR/.github/skills/skill-foundry/scripts"
    
    if [ ! -d "$source_dir" ]; then
        log_error "Scripts directory not found: $source_dir"
        return 1
    fi
    
    log_action "Copy: tools/skill-foundry/skill-foundry/scripts/ → .github/skills/skill-foundry/scripts/"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp "$source_dir"/*.py "$target_dir/" 2>/dev/null || true
        log_success "Scripts installed"
    fi
}

install_references() {
    if [ "$INSTALL_REFERENCES" = false ]; then
        return 0
    fi
    
    print_header "Installing References"
    
    local source_dir="$UBOD_DIR/tools/skill-foundry/skill-foundry/references"
    local target_dir="$MONOREPO_DIR/.github/skills/skill-foundry/references"
    
    if [ ! -d "$source_dir" ]; then
        log_error "References directory not found: $source_dir"
        return 1
    fi
    
    log_action "Copy: tools/skill-foundry/skill-foundry/references/ → .github/skills/skill-foundry/references/"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp "$source_dir"/*.md "$target_dir/"
        log_success "References installed"
    fi
}

install_examples() {
    if [ "$INSTALL_EXAMPLES" = false ]; then
        return 0
    fi
    
    print_header "Installing Examples"
    
    local source_dir="$UBOD_DIR/tools/skill-foundry/examples"
    local target_dir="$MONOREPO_DIR/.github/skills/skill-foundry/examples"
    
    if [ ! -d "$source_dir" ]; then
        log_error "Examples directory not found: $source_dir"
        return 1
    fi
    
    log_action "Copy: tools/skill-foundry/examples/ → .github/skills/skill-foundry/examples/"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp -r "$source_dir"/* "$target_dir/"
        log_success "Examples installed"
    fi
}

install_templates() {
    print_header "Installing Templates"
    
    local source="$UBOD_DIR/tools/skill-foundry/skill-foundry/templates/SKILL.template.md"
    local target_dir="$MONOREPO_DIR/.github/skills/skill-foundry/templates"
    local target="$target_dir/SKILL.template.md"
    
    if [ ! -f "$source" ]; then
        log_warning "Template not found: $source (skipping)"
        return 0
    fi
    
    log_action "Copy: tools/skill-foundry/skill-foundry/templates/SKILL.template.md → .github/skills/skill-foundry/templates/SKILL.template.md"
    
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$target_dir"
        cp "$source" "$target"
        log_success "Templates installed"
    fi
}

# =============================================================================
# Validation
# =============================================================================

validate_installation() {
    print_header "Validating Installation"
    
    local errors=0
    
    # Check meta-skill
    if [ -f "$MONOREPO_DIR/.github/skills/skill-foundry/SKILL.md" ]; then
        log_success "Meta-skill deployed"
    else
        log_error "Meta-skill missing"
        ((errors++))
    fi
    
    # Check agent
    if [ -f "$MONOREPO_DIR/.github/agents/skill-foundry-agent.agent.md" ]; then
        log_success "Agent deployed"
    else
        log_error "Agent missing"
        ((errors++))
    fi
    
    # Check optional components
    if [ "$INSTALL_SCRIPTS" = true ]; then
        if [ -f "$MONOREPO_DIR/.github/skills/skill-foundry/scripts/validate.py" ]; then
            log_success "Scripts deployed"
        else
            log_warning "Scripts missing (optional)"
        fi
    fi
    
    if [ "$INSTALL_REFERENCES" = true ]; then
        if [ -d "$MONOREPO_DIR/.github/skills/skill-foundry/references" ]; then
            log_success "References deployed"
        else
            log_warning "References missing (optional)"
        fi
    fi
    
    if [ "$INSTALL_EXAMPLES" = true ]; then
        if [ -d "$MONOREPO_DIR/.github/skills/skill-foundry/examples" ]; then
            log_success "Examples deployed"
        else
            log_warning "Examples missing (optional)"
        fi
    fi
    
    return $errors
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "Skill Foundry Installation"
    
    if [ "$DRY_RUN" = true ]; then
        log_warning "DRY-RUN MODE - No changes will be made"
    fi
    
    # Detect environment
    detect_environment
    
    # Install core components (always)
    install_meta_skill
    install_agent
    install_templates
    
    # Install optional components
    install_scripts
    install_references
    install_examples
    
    # Validate
    if [ "$DRY_RUN" = false ]; then
        validate_installation
        result=$?
        
        if [ $result -eq 0 ]; then
            print_header "Installation Complete"
            log_success "Skill-foundry successfully installed"
            echo ""
            log_info "Next steps:"
            log_info "  1. Reload VS Code window (Cmd+Shift+P → 'Reload Window')"
            log_info "  2. Test meta-skill: Open skill-foundry/SKILL.md and verify it loads"
            log_info "  3. Test agent: Type '@skill' in Copilot Chat to find Skill Foundry agent"
            log_info "  4. Create first skill: Use @skill-foundry or /skill-foundry prompt (if available)"
        else
            log_error "Installation completed with errors"
            exit 1
        fi
    else
        log_info "Dry-run complete. No changes made."
    fi
}

main
