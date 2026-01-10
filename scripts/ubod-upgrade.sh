#!/bin/bash

# =============================================================================
# Ubod Upgrade Script
# =============================================================================
#
# Upgrades a consumer repo to the latest Ubod version.
# Combines file syncing, changelog display, and version tracking.
#
# Modes:
#   - Semi-automated (default): Shows changelog, syncs files, directs to orchestrator
#   - Full-auto (--auto): Does everything without prompts
#
# Usage:
#   ./ubod-upgrade.sh              # Semi-automated (default)
#   ./ubod-upgrade.sh --auto       # Full automated
#   ./ubod-upgrade.sh --dry-run    # Preview without changes
#   ./ubod-upgrade.sh --help       # Show help
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
            FORCE=true
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
            echo "Upgrade consumer repo to latest Ubod version."
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
        log_action "Update .ubod-version to $version"
        return
    fi
    
    # Preserve existing migrations section if present
    local migrations_section=""
    if [ -f "$VERSION_FILE" ]; then
        migrations_section=$(grep -A 100 "^migrations:" "$VERSION_FILE" 2>/dev/null || echo "")
    fi
    
    cat > "$VERSION_FILE" << EOF
# Ubod Version Tracking
# Updated by: ubod-upgrade.sh
# See: projects/ubod/CHANGELOG.md for version history

version: $version
commit: $commit
updated: $date
EOF
    
    # Add migrations section (preserved from existing or empty array)
    if [ -n "$migrations_section" ]; then
        echo "" >> "$VERSION_FILE"
        echo "$migrations_section" >> "$VERSION_FILE"
    else
        echo "" >> "$VERSION_FILE"
        echo "# Applied migrations (add migration names as you apply them)" >> "$VERSION_FILE"
        echo "migrations: []" >> "$VERSION_FILE"
    fi
    
    log_success "Updated .ubod-version to $version"
}

# =============================================================================
# Changelog Display
# =============================================================================

show_changelog_diff() {
    local from_version=$1
    local to_version=$2
    
    print_header "Changelog: $from_version → $to_version"
    
    if [ ! -f "$CHANGELOG_FILE" ]; then
        log_warning "No CHANGELOG.md found"
        return
    fi
    
    echo ""
    echo "Changes in this upgrade:"
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
# Agent Migration (Fix misplaced agents from app folders)
# =============================================================================

migrate_misplaced_agents() {
    log_info ""
    log_info "Checking for misplaced agents..."
    
    local found_misplaced=false
    local migrated=0
    local target_dir="$MONOREPO_DIR/.github/agents"
    
    # Check for agents in app folders (they won't be discovered there)
    for app_dir in "$MONOREPO_DIR"/apps/*/; do
        [ -d "$app_dir" ] || continue
        
        local copilot_agents="$app_dir.copilot/agents"
        
        if [ -d "$copilot_agents" ]; then
            for agent_file in "$copilot_agents"/*.agent.md; do
                [ -f "$agent_file" ] || continue
                
                if [ "$found_misplaced" = false ]; then
                    log_warning "⚠️  Found agents in app folders - VS Code only discovers agents at .github/agents/"
                    echo ""
                    found_misplaced=true
                fi
                
                local filename=$(basename "$agent_file")
                local target="$target_dir/$filename"
                local app_name=$(basename "$(dirname "$(dirname "$agent_file")")")
                
                log_action "MIGRATE: $app_name/.copilot/agents/$filename → .github/agents/$filename"
                
                if [ "$DRY_RUN" = false ]; then
                    mkdir -p "$target_dir"
                    cp "$agent_file" "$target"
                    rm "$agent_file"
                    ((migrated++))
                fi
            done
            
            # Clean up empty directories
            if [ "$DRY_RUN" = false ] && [ -d "$copilot_agents" ] && [ -z "$(ls -A "$copilot_agents")" ]; then
                rmdir "$copilot_agents"
            fi
        fi
    done
    
    if [ "$found_misplaced" = true ]; then
        log_success "Migrated $migrated agents to .github/agents/"
        log_info "ℹ️  VS Code limitation: Agents MUST be at .github/agents/ (no subfolders)"
    else
        log_success "No misplaced agents found"
    fi
}

validate_settings_json() {
    local settings_file="$MONOREPO_DIR/.vscode/settings.json"
    
    log_info ""
    log_info "Validating .vscode/settings.json..."
    
    if [ ! -f "$settings_file" ]; then
        log_info "No settings.json found (will be created by VS Code)"
        return
    fi
    
    # Check for incorrect array format
    local has_errors=false
    
    if grep -q '"chat.instructionsFilesLocations": \[' "$settings_file" 2>/dev/null; then
        log_warning "❌ chat.instructionsFilesLocations using ARRAY format (should be OBJECT)"
        has_errors=true
    fi
    
    if grep -q '"chat.promptFilesLocations": \[' "$settings_file" 2>/dev/null; then
        log_warning "❌ chat.promptFilesLocations using ARRAY format (should be OBJECT)"
        has_errors=true
    fi
    
    if grep -q '"chat.agentFilesLocations"' "$settings_file" 2>/dev/null; then
        log_warning "❌ chat.agentFilesLocations is not a valid VS Code setting (remove it)"
        has_errors=true
    fi
    
    if [ "$has_errors" = true ]; then
        echo ""
        log_warning "⚠️  settings.json has format errors!"
        echo ""
        echo "CORRECT FORMAT (object with boolean values):"
        echo ""
        echo '  "chat.instructionsFilesLocations": {'
        echo '    ".github/instructions": true,'
        echo '    "apps/app-name/.copilot/instructions": true'
        echo '  },'
        echo '  "chat.promptFilesLocations": {'
        echo '    ".github/prompts": true,'
        echo '    "apps/app-name/.copilot/prompts": true'
        echo '  }'
        echo ""
        echo "INCORRECT FORMAT (array - causes lint errors):"
        echo ""
        echo '  "chat.instructionsFilesLocations": ['
        echo '    ".github/instructions",'
        echo '    "apps/app-name/.copilot/instructions"'
        echo '  ]'
        echo ""
        log_warning "Run /ubod-upgrade prompt to auto-fix, or edit manually"
        echo ""
    else
        log_success "settings.json format looks good"
    fi
}

ensure_prompt_locations() {
    local settings_file="$MONOREPO_DIR/.vscode/settings.json"
    
    if [ ! -f "$settings_file" ]; then
        log_info "No settings.json found - skipping prompt locations setup"
        return
    fi
    
    # Check if chat.promptFilesLocations exists
    if grep -q '"chat.promptFilesLocations"' "$settings_file" 2>/dev/null; then
        return
    fi
    
    log_info ""
    log_action "Adding chat.promptFilesLocations to settings.json..."
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY RUN] Would add chat.promptFilesLocations"
        return
    fi
    
    # Detect existing prompt directories
    local prompt_dirs=()
    
    # Check for .github/prompts
    if [ -d "$MONOREPO_DIR/.github/prompts" ]; then
        prompt_dirs+=('    ".github/prompts": true')
    fi
    
    # Check for app-specific prompts
    for app_dir in "$MONOREPO_DIR"/apps/*/; do
        if [ -d "$app_dir/.copilot/prompts" ]; then
            local rel_path=$(realpath --relative-to="$MONOREPO_DIR" "$app_dir/.copilot/prompts")
            prompt_dirs+=("    \"$rel_path\": true")
        fi
        if [ -d "$app_dir/prompts" ]; then
            local rel_path=$(realpath --relative-to="$MONOREPO_DIR" "$app_dir/prompts")
            prompt_dirs+=("    \"$rel_path\": true")
        fi
    done
    
    if [ ${#prompt_dirs[@]} -eq 0 ]; then
        log_info "No prompt directories found - skipping"
        return
    fi
    
    # Create the JSON block
    local json_block=""
    json_block+='  "chat.promptFilesLocations": {\n'
    
    for i in "${!prompt_dirs[@]}"; do
        if [ $i -eq $((${#prompt_dirs[@]} - 1)) ]; then
            json_block+="${prompt_dirs[$i]}\n"
        else
            json_block+="${prompt_dirs[$i]},\n"
        fi
    done
    
    json_block+='  },'
    
    # Insert before the last closing brace
    local temp_file=$(mktemp)
    awk -v json="$json_block" '
        /^}$/ && !done {
            printf "%s\n", json
            done = 1
        }
        { print }
    ' "$settings_file" > "$temp_file"
    
    mv "$temp_file" "$settings_file"
    
    log_success "Added chat.promptFilesLocations"
    log_info "ℹ️  Reload VS Code for prompts to appear: Cmd+Shift+P → 'Reload Window'"
}

# =============================================================================
# File Syncing (merged from ubod-sync.sh)
# =============================================================================

sync_agents() {
    local source_dir="$UBOD_DIR/ubod-meta/agents"
    local target_dir="$MONOREPO_DIR/.github/agents"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing agents (to root level)..."

    mkdir -p "$target_dir"

    # Sync root-level agent files
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

    # Note: Agent subdirectories not currently supported by VS Code
    # All agents must be at .github/agents/ root level
    # If we add subdirectory support in the future, add sync logic here

    log_success "Agents: $copied new, $updated updated, $skipped unchanged"
}

sync_prompts() {
    local source_dir="$UBOD_DIR/ubod-meta/prompts"
    local target_dir="$MONOREPO_DIR/.github/prompts/ubod"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing prompts (to ubod/ subfolder)..."

    mkdir -p "$target_dir"

    # Sync root-level prompt files
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

    # Sync subdirectories (e.g., adr/)
    for subdir in "$source_dir"/*/; do
        [ -d "$subdir" ] || continue
        
        # Skip deprecated directory
        local dirname=$(basename "$subdir")
        if [ "$dirname" = "deprecated" ]; then
            continue
        fi
        
        local target_subdir="$target_dir/$dirname"
        mkdir -p "$target_subdir"
        
        # Sync all files in subdirectory
        for file in "$subdir"/*; do
            [ -f "$file" ] || continue
            local filename=$(basename "$file")
            local target="$target_subdir/$filename"
            
            if [ ! -f "$target" ]; then
                log_action "Copy NEW: $dirname/$filename"
                if [ "$DRY_RUN" = false ]; then
                    cp "$file" "$target"
                fi
                ((copied++))
            elif ! diff -q "$file" "$target" > /dev/null 2>&1; then
                log_action "Update CHANGED: $dirname/$filename"
                if [ "$DRY_RUN" = false ]; then
                    cp "$file" "$target"
                fi
                ((updated++))
            else
                ((skipped++))
            fi
        done
    done

    log_success "Prompts: $copied new, $updated updated, $skipped unchanged"
}

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

sync_schemas() {
    local source_dir="$UBOD_DIR/ubod-meta/schemas"
    local target_dir="$MONOREPO_DIR/.github/schemas"
    local copied=0
    local updated=0
    local skipped=0

    log_info ""
    log_info "Syncing schemas..."

    if [ ! -d "$source_dir" ]; then
        log_info "No schemas directory in ubod - skipping"
        return
    fi

    mkdir -p "$target_dir"

    for file in "$source_dir"/*; do
        [ -f "$file" ] || continue
        local filename=$(basename "$file")
        local target_file="$target_dir/$filename"

        if [ "$DRY_RUN" = true ]; then
            if [ ! -f "$target_file" ]; then
                log_info "[DRY RUN] Would copy: $filename (NEW)"
                ((copied++))
            elif ! cmp -s "$file" "$target_file"; then
                log_info "[DRY RUN] Would update: $filename"
                ((updated++))
            else
                ((skipped++))
            fi
        else
            if [ ! -f "$target_file" ]; then
                cp "$file" "$target_file"
                log_info "  + $filename (NEW)"
                ((copied++))
            elif ! cmp -s "$file" "$target_file"; then
                cp "$file" "$target_file"
                log_info "  ↻ $filename (UPDATED)"
                ((updated++))
            else
                ((skipped++))
            fi
        fi
    done

    log_success "Schemas: $copied new, $updated updated, $skipped unchanged"
}

check_copilot_instructions() {
    local copilot_file="$MONOREPO_DIR/.github/copilot-instructions.md"
    
    log_info ""
    log_info "Checking copilot-instructions.md..."

    if [ ! -f "$copilot_file" ]; then
        log_warning "No copilot-instructions.md found at root level."
        log_warning "This is typically created by the /ubod-upgrade orchestrator prompt."
        return
    fi

    # Check if it mentions ubod
    if ! grep -qi "ubod" "$copilot_file" 2>/dev/null; then
        log_warning "copilot-instructions.md does not reference Ubod."
        log_warning "The /ubod-upgrade prompt can help update this."
        return
    fi

    log_success "copilot-instructions.md looks good"
}

run_file_sync() {
    print_header "Syncing Files"
    
    # Migration & validation (pre-sync)
    migrate_misplaced_agents
    validate_settings_json
    ensure_prompt_locations
    
    # Regular sync
    sync_agents
    sync_prompts
    sync_instructions
    sync_schemas
    check_copilot_instructions
}

# =============================================================================
# Next Steps
# =============================================================================

show_next_steps() {
    print_header "Next Step"
    
    echo ""
    log_info "Run this orchestrator prompt in Copilot chat:"
    echo ""
    echo "  /ubod-upgrade"
    echo ""
    log_info "This prompt handles agent creation, updates, and orchestration."
    echo ""
}

# =============================================================================
# Main Flow
# =============================================================================

main() {
    print_header "Ubod Upgrade"
    
    # Detect environment
    detect_environment
    
    # Get versions
    CURRENT_VERSION=$(get_current_version)
    LATEST_VERSION=$(get_latest_version)
    CURRENT_COMMIT=$(get_current_commit)
    LATEST_COMMIT=$(get_latest_commit)
    
    log_info "Current version: $CURRENT_VERSION (commit: ${CURRENT_COMMIT:0:7})"
    log_info "Latest version: $LATEST_VERSION (commit: ${LATEST_COMMIT:0:7})"
    
    # Check if upgrade needed
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
    
    # Confirm upgrade (unless auto or force)
    if [ "$AUTO_MODE" = false ] && [ "$FORCE" = false ] && [ "$DRY_RUN" = false ]; then
        echo ""
        read -p "Proceed with upgrade? (Y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            log_info "Upgrade cancelled"
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
    
    # Run file sync
    run_file_sync
    
    # Update version file
    if [ "$DRY_RUN" = false ]; then
        update_version_file "$LATEST_VERSION" "$LATEST_COMMIT"
    fi
    
    # Show next steps
    show_next_steps
    
    # Summary
    print_header "Upgrade Complete"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "Dry run complete. No changes were made."
    else
        log_success "Upgraded from $CURRENT_VERSION to $LATEST_VERSION"
        echo ""
        log_info "Recommended:"
        echo "  1. Review changes: git diff .github/"
        echo "  2. Commit changes: git add .github/ .ubod-version && git commit -m 'chore: Upgrade Ubod to $LATEST_VERSION'"
        echo "  3. Run /ubod-upgrade in Copilot chat for orchestration"
    fi
}

# Run main
main
