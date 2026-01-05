#!/bin/bash

# ============================================================================
# ubod-sync.sh - Sync Ubod meta content to consuming monorepo
# ============================================================================
#
# This script syncs files from the ubod submodule to the consuming monorepo's
# .github/ directory. Run this after pulling submodule updates.
#
# Usage:
#   ./projects/ubod/scripts/ubod-sync.sh [options]
#
# Options:
#   --dry-run    Show what would be copied without making changes
#   --force      Skip confirmation prompts
#   --quiet      Minimal output
#   --help       Show this help message
#
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UBOD_DIR="$(dirname "$SCRIPT_DIR")"
MONOREPO_DIR="$(dirname "$(dirname "$UBOD_DIR")")"

# Options
DRY_RUN=false
FORCE=false
QUIET=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --quiet)
            QUIET=true
            shift
            ;;
        --help)
            head -25 "$0" | tail -20
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Logging functions
log_info() {
    if [ "$QUIET" = false ]; then
        echo -e "${BLUE}ℹ${NC} $1"
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
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} Would: $1"
    else
        echo -e "${GREEN}→${NC} $1"
    fi
}

# Check we're in the right place
check_environment() {
    if [ ! -d "$UBOD_DIR/ubod-meta" ]; then
        log_error "Cannot find ubod-meta directory at $UBOD_DIR/ubod-meta"
        log_error "Are you running this from the correct location?"
        exit 1
    fi

    if [ ! -d "$MONOREPO_DIR/.github" ]; then
        log_error "Cannot find .github directory at $MONOREPO_DIR/.github"
        log_error "This doesn't look like a consuming monorepo."
        exit 1
    fi

    log_info "Ubod directory: $UBOD_DIR"
    log_info "Monorepo directory: $MONOREPO_DIR"
}

# Sync agents (must be at root level)
sync_agents() {
    local source_dir="$UBOD_DIR/ubod-meta/agents"
    local target_dir="$MONOREPO_DIR/.github/agents"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing agents (to root level)..."

    mkdir -p "$target_dir"

    for file in "$source_dir"/*.agent.md; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        local target="$target_dir/$filename"

        if [ ! -f "$target" ]; then
            log_action "Copy NEW: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((copied++))
        elif ! diff -q "$file" "$target" > /dev/null 2>&1; then
            log_action "Update CHANGED: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((updated++))
        else
            ((skipped++))
        fi
    done

    log_success "Agents: $copied new, $updated updated, $skipped unchanged"
}

# Sync prompts (into ubod/ subfolder)
sync_prompts() {
    local source_dir="$UBOD_DIR/ubod-meta/prompts"
    local target_dir="$MONOREPO_DIR/.github/prompts/ubod"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing prompts (to ubod/ subfolder)..."

    mkdir -p "$target_dir"

    for file in "$source_dir"/*.prompt.md; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        local target="$target_dir/$filename"

        if [ ! -f "$target" ]; then
            log_action "Copy NEW: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((copied++))
        elif ! diff -q "$file" "$target" > /dev/null 2>&1; then
            log_action "Update CHANGED: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((updated++))
        else
            ((skipped++))
        fi
    done

    log_success "Prompts: $copied new, $updated updated, $skipped unchanged"
}

# Sync instructions (into ubod/ subfolder)
sync_instructions() {
    local source_dir="$UBOD_DIR/ubod-meta/instructions"
    local target_dir="$MONOREPO_DIR/.github/instructions/ubod"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing instructions (to ubod/ subfolder)..."

    mkdir -p "$target_dir"

    for file in "$source_dir"/*.instructions.md; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        local target="$target_dir/$filename"

        if [ ! -f "$target" ]; then
            log_action "Copy NEW: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((copied++))
        elif ! diff -q "$file" "$target" > /dev/null 2>&1; then
            log_action "Update CHANGED: $filename"
            if [ "$DRY_RUN" = false ]; then
                cp "$file" "$target"
            fi
            ((updated++))
        else
            ((skipped++))
        fi
    done

    log_success "Instructions: $copied new, $updated updated, $skipped unchanged"
}

# Check if copilot-instructions.md needs update
check_copilot_instructions() {
    local copilot_file="$MONOREPO_DIR/.github/copilot-instructions.md"
    
    log_info ""
    log_info "Checking copilot-instructions.md..."

    if [ ! -f "$copilot_file" ]; then
        log_warning "No copilot-instructions.md found!"
        log_warning "Consider running /ubod-migrate-copilot-instructions to create it."
        return
    fi

    # Check if it mentions ubod
    if ! grep -q "ubod" "$copilot_file" 2>/dev/null; then
        log_warning "copilot-instructions.md does not reference Ubod!"
        log_warning "Consider running /ubod-migrate-copilot-instructions to update it."
        return
    fi

    # Check if it has the navigation index pattern
    if ! grep -q "🚨" "$copilot_file" 2>/dev/null; then
        log_warning "copilot-instructions.md may need restructuring (no emoji headers)."
        log_warning "Consider running /ubod-migrate-copilot-instructions to update it."
        return
    fi

    log_success "copilot-instructions.md looks good"
}

# Show summary and next steps
show_summary() {
    log_info ""
    echo "====================================="
    echo "Sync Complete"
    echo "====================================="
    
    if [ "$DRY_RUN" = true ]; then
        log_warning "This was a DRY RUN - no files were changed"
        log_info "Run without --dry-run to apply changes"
    else
        log_info ""
        log_info "Next steps:"
        echo "  1. Review changes: git diff .github/"
        echo "  2. Commit: git add .github/ && git commit -m 'chore: Sync ubod meta content'"
        echo "  3. Test prompts: Try /ubod-update-agent or other ubod prompts"
        log_info ""
        log_info "If you added new prompts, you may want to update copilot-instructions.md:"
        echo "  Run: /ubod-migrate-copilot-instructions"
    fi
}

# Main
main() {
    echo ""
    echo "====================================="
    echo "Ubod Sync"
    echo "====================================="
    
    if [ "$DRY_RUN" = true ]; then
        log_warning "DRY RUN MODE - No changes will be made"
    fi

    check_environment

    if [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
        echo ""
        read -p "Sync ubod meta content to .github/? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Aborted."
            exit 0
        fi
    fi

    sync_agents
    sync_prompts
    sync_instructions
    check_copilot_instructions
    show_summary
}

main "$@"
