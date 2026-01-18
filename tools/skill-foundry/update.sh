#!/bin/bash

# =============================================================================
# Skill Foundry Update Script
# =============================================================================
#
# Re-deploys skill-foundry after changes in ubod.
# Useful during development or after ubod upgrade.
#
# What it does:
#   1. Detects what's currently installed
#   2. Re-copies the same components
#   3. Validates the update
#
# Usage:
#   ./update.sh              # Update with same options as original install
#   ./update.sh --full       # Force full update
#   ./update.sh --dry-run    # Preview changes
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
FORCE_FULL=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --full)
            FORCE_FULL=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Update skill-foundry deployment after ubod changes."
            echo ""
            echo "Options:"
            echo "  --full         Force full update (all components)"
            echo "  --dry-run      Preview changes without making them"
            echo "  --help         Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                # Update same components as original install"
            echo "  $0 --full         # Force full update"
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
    
    # Find ubod root
    if [[ "$SCRIPT_DIR" == *"/tools/skill-foundry"* ]]; then
        UBOD_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
        MONOREPO_DIR="$(dirname "$(dirname "$UBOD_DIR")")"
    else
        log_error "Cannot detect ubod directory"
        exit 1
    fi
    
    log_info "Detected environment:"
    log_info "  Ubod: $UBOD_DIR"
    log_info "  Monorepo: $MONOREPO_DIR"
}

detect_installed_components() {
    print_header "Detecting Installed Components"
    
    INSTALLED_SCRIPTS=false
    INSTALLED_REFERENCES=false
    INSTALLED_EXAMPLES=false
    
    if [ -d "$MONOREPO_DIR/.github/skills/skill-foundry/scripts" ]; then
        INSTALLED_SCRIPTS=true
        log_info "Detected: Scripts"
    fi
    
    if [ -d "$MONOREPO_DIR/.github/skills/skill-foundry/references" ]; then
        INSTALLED_REFERENCES=true
        log_info "Detected: References"
    fi
    
    if [ -d "$MONOREPO_DIR/.github/skills/skill-foundry/examples" ]; then
        INSTALLED_EXAMPLES=true
        log_info "Detected: Examples"
    fi
    
    if [ "$FORCE_FULL" = true ]; then
        log_warning "Forcing full update (all components)"
        INSTALLED_SCRIPTS=true
        INSTALLED_REFERENCES=true
        INSTALLED_EXAMPLES=true
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    print_header "Skill Foundry Update"
    
    if [ "$DRY_RUN" = true ]; then
        log_warning "DRY-RUN MODE - No changes will be made"
    fi
    
    # Detect environment
    detect_environment
    
    # Detect what's installed
    detect_installed_components
    
    # Build install command
    INSTALL_CMD="$SCRIPT_DIR/install.sh"
    
    if [ "$INSTALLED_SCRIPTS" = true ] && [ "$INSTALLED_REFERENCES" = true ] && [ "$INSTALLED_EXAMPLES" = true ]; then
        INSTALL_CMD="$INSTALL_CMD --full"
    else
        if [ "$INSTALLED_SCRIPTS" = true ]; then
            INSTALL_CMD="$INSTALL_CMD --scripts"
        fi
        
        if [ "$INSTALLED_REFERENCES" = true ]; then
            INSTALL_CMD="$INSTALL_CMD --references"
        fi
        
        if [ "$INSTALLED_EXAMPLES" = true ]; then
            INSTALL_CMD="$INSTALL_CMD --examples"
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        INSTALL_CMD="$INSTALL_CMD --dry-run"
    fi
    
    log_info "Running: $INSTALL_CMD"
    echo ""
    
    # Run install script
    if [ -f "$SCRIPT_DIR/install.sh" ]; then
        bash $INSTALL_CMD
    else
        log_error "install.sh not found at $SCRIPT_DIR/install.sh"
        exit 1
    fi
    
    # Validate if not dry-run
    if [ "$DRY_RUN" = false ] && [ -f "$SCRIPT_DIR/validate-all.sh" ]; then
        echo ""
        print_header "Running Validation"
        bash "$SCRIPT_DIR/validate-all.sh"
    fi
    
    if [ "$DRY_RUN" = false ]; then
        echo ""
        print_header "Update Complete"
        log_success "skill-foundry updated successfully"
        log_info "Reload VS Code window to see changes"
    fi
}

main
