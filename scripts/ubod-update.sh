#!/bin/bash

# =============================================================================
# Ubod Update Script
# =============================================================================
#
# Updates a consumer repo to the latest Ubod version.
#
# Modes:
#   - Semi-automated (default): Syncs files, shows changelog, lists prompts to run
#   - Full-auto (--auto): Does everything including running upgrade steps
#
# Usage:
#   ./ubod-update.sh              # Semi-automated (default)
#   ./ubod-update.sh --auto       # Full automated
#   ./ubod-update.sh --dry-run    # Preview without changes
#   ./ubod-update.sh --help       # Show help
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
AUTO_MODE=false
QUIET=false
FORCE=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --auto)
            AUTO_MODE=true
            shift
            ;;
        --quiet|-q)
            QUIET=true
            shift
            ;;
        --force|-f)
            FORCE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Preview changes without making them"
            echo "  --auto       Full automated mode (no prompts)"
            echo "  --force      Skip confirmations"
            echo "  --quiet      Minimal output"
            echo "  --help       Show this help"
            echo ""
            echo "Examples:"
            echo "  $0                    # Semi-automated (default)"
            echo "  $0 --auto             # Full automated"
            echo "  $0 --dry-run          # Preview only"
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
    if [ "$QUIET" = false ]; then
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

log_action() {
    echo -e "${BLUE}→${NC} $1"
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
    # Find ubod submodule directory
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # Check if we're inside ubod submodule
    if [[ "$SCRIPT_DIR" == *"/projects/ubod/scripts"* ]]; then
        UBOD_DIR="$(dirname "$SCRIPT_DIR")"
        MONOREPO_DIR="$(dirname "$(dirname "$UBOD_DIR")")"
    elif [[ "$SCRIPT_DIR" == *"/ubod/scripts"* ]]; then
        UBOD_DIR="$(dirname "$SCRIPT_DIR")"
        MONOREPO_DIR="$(dirname "$UBOD_DIR")"
    else
        log_error "Cannot detect ubod submodule location"
        log_error "Run this script from within the ubod/scripts directory"
        exit 1
    fi
    
    # Verify directories exist
    if [ ! -d "$UBOD_DIR/ubod-meta" ]; then
        log_error "ubod-meta directory not found at $UBOD_DIR/ubod-meta"
        exit 1
    fi
    
    if [ ! -d "$MONOREPO_DIR/.github" ]; then
        log_error ".github directory not found at $MONOREPO_DIR/.github"
        exit 1
    fi
    
    # Set paths
    VERSION_FILE="$MONOREPO_DIR/.ubod-version"
    CHANGELOG_FILE="$UBOD_DIR/CHANGELOG.md"
    GITHUB_DIR="$MONOREPO_DIR/.github"
    
    log_info "Ubod directory: $UBOD_DIR"
    log_info "Monorepo directory: $MONOREPO_DIR"
}

# =============================================================================
# Version Management
# =============================================================================

get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        grep "^version:" "$VERSION_FILE" | cut -d':' -f2 | tr -d ' '
    else
        echo "0.0.0"
    fi
}

get_latest_version() {
    if [ -f "$CHANGELOG_FILE" ]; then
        # Extract first version number from changelog (after [Unreleased])
        grep -E "^## \[[0-9]+\.[0-9]+\.[0-9]+\]" "$CHANGELOG_FILE" | head -1 | sed 's/.*\[\([0-9.]*\)\].*/\1/'
    else
        echo "1.0.0"
    fi
}

get_current_commit() {
    if [ -f "$VERSION_FILE" ]; then
        grep "^commit:" "$VERSION_FILE" | cut -d':' -f2 | tr -d ' '
    else
        echo "unknown"
    fi
}

get_latest_commit() {
    cd "$UBOD_DIR" && git rev-parse HEAD
}

update_version_file() {
    local version=$1
    local commit=$2
    local date=$(date +%Y-%m-%d)
    
    if [ "$DRY_RUN" = true ]; then
        log_action "Would update .ubod-version to version $version"
        return
    fi
    
    cat > "$VERSION_FILE" << EOF
# Ubod Version Tracking
# Updated by: ubod-update.sh
# See: projects/ubod/CHANGELOG.md for version history

version: $version
commit: $commit
updated: $date
EOF
    
    log_success "Updated .ubod-version to $version"
}

# =============================================================================
# Changelog Parsing
# =============================================================================

parse_changelog_actions() {
    local from_version=$1
    local to_version=$2
    
    # This function extracts action blocks from changelog
    # Returns: action type, source, target for each entry
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        log_warning "No CHANGELOG.md found"
        return
    fi
    
    # For now, we'll rely on ubod-sync.sh for file syncing
    # This function identifies prompts that need to be run
    
    log_info "Parsing changelog from $from_version to $to_version..."
    
    # Extract RUN_PROMPT actions
    PROMPTS_TO_RUN=()
    
    # Look for action: RUN_PROMPT entries
    if grep -q "action: RUN_PROMPT" "$CHANGELOG_FILE"; then
        while IFS= read -r line; do
            if [[ "$line" == *"prompt:"* ]]; then
                prompt=$(echo "$line" | sed 's/.*prompt: *//' | tr -d ' ')
                PROMPTS_TO_RUN+=("$prompt")
            fi
        done < <(grep -A1 "action: RUN_PROMPT" "$CHANGELOG_FILE")
    fi
}

show_changelog_diff() {
    local from_version=$1
    local to_version=$2
    
    print_header "Changelog: $from_version → $to_version"
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        log_warning "No CHANGELOG.md found"
        return
    fi
    
    # Show relevant changelog sections
    # For simplicity, show all entries for versions > from_version
    
    echo ""
    echo "Changes in this update:"
    echo ""
    
    # Extract and display changelog sections
    # Show all sections between current and latest version
    local in_range=0
    while IFS= read -r line; do
        if [[ "$line" =~ ^\#\#\ \[([0-9]+\.[0-9]+\.[0-9]+)\] ]]; then
            version="${BASH_REMATCH[1]}"
            if [ "$version" = "$to_version" ]; then
                in_range=1
                echo "$line"
            elif [ "$version" = "$from_version" ]; then
                in_range=0
                break
            elif [ $in_range -eq 1 ]; then
                echo "$line"
            fi
        elif [ $in_range -eq 1 ]; then
            echo "$line"
        fi
    done < "$CHANGELOG_FILE"
    
    echo ""
}

# =============================================================================
# File Syncing
# =============================================================================

run_sync() {
    local sync_script="$UBOD_DIR/scripts/ubod-sync.sh"
    
    if [ ! -f "$sync_script" ]; then
        log_error "ubod-sync.sh not found at $sync_script"
        exit 1
    fi
    
    print_header "Syncing Files"
    
    if [ "$DRY_RUN" = true ]; then
        bash "$sync_script" --dry-run
    elif [ "$FORCE" = true ] || [ "$AUTO_MODE" = true ]; then
        bash "$sync_script" --force
    else
        bash "$sync_script"
    fi
}

# =============================================================================
# Upgrade Prompts
# =============================================================================

show_prompts_to_run() {
    print_header "Prompts to Run"
    
    # Standard upgrade prompts
    local prompts=(
        "/ubod-update-agent (batch mode) - Update agents with missing metadata"
        "/ubod-migrate-copilot-instructions - Update navigation file if needed"
    )
    
    echo ""
    echo "After syncing, consider running these prompts in Copilot chat:"
    echo ""
    
    for prompt in "${prompts[@]}"; do
        echo "  • $prompt"
    done
    
    echo ""
    
    if [ "$AUTO_MODE" = true ]; then
        log_warning "Auto mode cannot run Copilot prompts automatically"
        log_info "Please run the prompts above manually in VS Code"
    fi
}

# =============================================================================
# Main Flow
# =============================================================================

main() {
    print_header "Ubod Update"
    
    # Detect environment
    detect_environment
    
    # Get versions
    CURRENT_VERSION=$(get_current_version)
    LATEST_VERSION=$(get_latest_version)
    CURRENT_COMMIT=$(get_current_commit)
    LATEST_COMMIT=$(get_latest_commit)
    
    log_info "Current version: $CURRENT_VERSION (commit: ${CURRENT_COMMIT:0:7})"
    log_info "Latest version: $LATEST_VERSION (commit: ${LATEST_COMMIT:0:7})"
    
    # Check if update needed
    if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] && [ "$CURRENT_COMMIT" = "$LATEST_COMMIT" ]; then
        log_success "Already up to date!"
        
        if [ "$FORCE" = false ]; then
            echo ""
            read -p "Run sync anyway? (y/N) " -n 1 -r
            echo ""
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 0
            fi
        fi
    fi
    
    # Show changelog
    if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
        show_changelog_diff "$CURRENT_VERSION" "$LATEST_VERSION"
    fi
    
    # Confirm update (unless auto or force)
    if [ "$AUTO_MODE" = false ] && [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
        echo ""
        read -p "Proceed with update? (Y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            log_info "Update cancelled"
            exit 0
        fi
        
        # Offer full auto
        echo ""
        read -p "Run fully automated? (y/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            AUTO_MODE=true
            FORCE=true
            log_info "Switching to full auto mode"
        fi
    fi
    
    # Run sync
    run_sync
    
    # Update version file
    if [ "$DRY_RUN" = false ]; then
        update_version_file "$LATEST_VERSION" "$LATEST_COMMIT"
    fi
    
    # Show prompts to run
    show_prompts_to_run
    
    # Summary
    print_header "Update Complete"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "Dry run complete. No changes were made."
    else
        log_success "Updated from $CURRENT_VERSION to $LATEST_VERSION"
        echo ""
        log_info "Next steps:"
        echo "  1. Review changes: git diff .github/"
        echo "  2. Commit: git add .github/ .ubod-version && git commit -m 'chore: Update Ubod to $LATEST_VERSION'"
        echo "  3. Run prompts listed above in Copilot chat"
    fi
}

# Run main
main
