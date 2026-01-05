#!/bin/bash

# Ubod Setup Validation Script
# Validates that Ubod has been correctly set up in your monorepo

# Note: Do NOT use `set -e` here.
# This script is intended to report all missing pieces in one run.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
UBOD_DIR="$( dirname "$SCRIPT_DIR" )"
MONOREPO_DIR="${1:-.}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

# Functions
check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $description (missing: $file)"
        ((FAIL++))
        return 1
    fi
}

check_directory() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $description (missing: $dir)"
        ((FAIL++))
        return 1
    fi
}

check_file_content() {
    local file="$1"
    local pattern="$2"
    local description="$3"
    
    if grep -q "$pattern" "$file" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} $description"
        ((PASS++))
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $description (pattern not found: $pattern)"
        ((WARN++))
        return 1
    fi
}

echo "====================================="
echo "Ubod Setup Validation"
echo "====================================="
echo ""

# Phase 1: Ubod Directory Structure
echo -e "${YELLOW}Phase 1: Ubod Project Structure${NC}"
check_directory "$UBOD_DIR" "Ubod root directory"
check_directory "$UBOD_DIR/docs" "Documentation folder"
check_directory "$UBOD_DIR/prompts" "Prompts folder"
check_directory "$UBOD_DIR/templates" "Templates folder"
check_directory "$UBOD_DIR/templates/instructions" "Instructions templates"
check_directory "$UBOD_DIR/templates/agents" "Agent templates"
check_directory "$UBOD_DIR/templates/prompts" "Prompt templates"
check_directory "$UBOD_DIR/templates/config" "Config templates"
check_directory "$UBOD_DIR/scripts" "Scripts folder"
check_directory "$UBOD_DIR/tools" "Tools folder"
check_directory "$UBOD_DIR/tools/github-copilot" "GitHub Copilot folder"
check_directory "$UBOD_DIR/tools/claude-code" "Claude Code folder"
check_directory "$UBOD_DIR/tools/anti-gravity" "Anti-Gravity folder"

echo ""

# Phase 2: Core Documentation Files
echo -e "${YELLOW}Phase 2: Core Documentation${NC}"
check_file "$UBOD_DIR/README.md" "Ubod README"
check_file "$UBOD_DIR/docs/PHILOSOPHY.md" "Philosophy documentation"
check_file "$UBOD_DIR/docs/SETUP_GUIDE.md" "Setup guide"
check_file "$UBOD_DIR/docs/MULTI_TOOL_SUPPORT.md" "Multi-tool support guide"

echo ""

# Phase 3: Prompts
echo -e "${YELLOW}Phase 3: LLM Prompts${NC}"
check_file "$UBOD_DIR/prompts/01-setup-universal-kernel.prompt.md" "Prompt 1: Universal Kernel"
check_file "$UBOD_DIR/prompts/02-setup-app-specific.prompt.md" "Prompt 2: App-Specific"

echo ""

# Phase 4: Templates
echo -e "${YELLOW}Phase 4: Templates${NC}"
check_file "$UBOD_DIR/templates/instructions/universal/instruction-template.md" "Universal instruction template"
check_file "$UBOD_DIR/templates/instructions/app-specific/app-instruction-template.md" "App-specific instruction template"
check_file "$UBOD_DIR/templates/agents/agent-template.md" "Agent template"
check_file "$UBOD_DIR/templates/prompts/prompt-template.md" "Prompt template"
check_file "$UBOD_DIR/templates/config/ubod-config-template.json" "Config template"

echo ""

# Phase 5: Universal Kernel (if generated)
echo -e "${YELLOW}Phase 5: Universal Kernel in Monorepo${NC}"
if [ -d "$MONOREPO_DIR/.github/instructions" ]; then
    check_directory "$MONOREPO_DIR/.github/instructions" "Universal instructions folder"
    check_file "$MONOREPO_DIR/.github/instructions/discovery-methodology.instructions.md" "Discovery methodology instructions" || true
    check_file "$MONOREPO_DIR/.github/instructions/verification-checklist.instructions.md" "Verification checklist instructions" || true
else
    echo -e "${YELLOW}⚠${NC} Universal kernel not yet generated (run Prompt 1)"
    ((WARN++))
fi

echo ""

# Phase 6: App-Specific Setup
echo -e "${YELLOW}Phase 6: App-Specific Setup (if generated)${NC}"
if ls "$MONOREPO_DIR/apps/"*/".copilot/instructions/"* 2>/dev/null | grep -q .; then
    check_directory "$MONOREPO_DIR/apps" "Apps directory"
    echo -e "${GREEN}✓${NC} App-specific instructions found"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} App-specific setup not yet generated (run Prompt 2)"
    ((WARN++))
fi

echo ""

# Phase 7: Tool-Specific Files
echo -e "${YELLOW}Phase 7: Tool-Specific Documentation${NC}"
check_file "$UBOD_DIR/tools/github-copilot/README.md" "Copilot README"
check_file "$UBOD_DIR/tools/claude-code/README.md" "Claude Code README"
check_file "$UBOD_DIR/tools/anti-gravity/README.md" "Anti-Gravity README"

echo ""

# Phase 8: Content Validation
echo -e "${YELLOW}Phase 8: Content Validation${NC}"
check_file_content "$UBOD_DIR/README.md" "{{PLACEHOLDER}}" "Templates use placeholder pattern" || true
check_file_content "$UBOD_DIR/prompts/01-setup-universal-kernel.prompt.md" "monorepo" "Prompt 1 mentions monorepo" || true
check_file_content "$UBOD_DIR/prompts/02-setup-app-specific.prompt.md" "app-specific" "Prompt 2 mentions app-specific" || true

echo ""

# Summary
echo "====================================="
echo "Validation Summary"
echo "====================================="
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${YELLOW}Warnings:${NC} $WARN"
echo -e "${RED}Failed:${NC} $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ Ubod setup looks good!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run Prompt 1 to generate universal kernel"
    echo "2. Save outputs to .github/instructions/ and .github/agents/"
    echo "3. Run Prompt 2 for each app"
    echo "4. Save outputs to apps/{app}/.copilot/"
    echo "5. Commit to Git"
    exit 0
else
    echo -e "${RED}✗ Ubod setup has issues.${NC}"
    echo ""
    echo "Missing files:"
    echo "- Check folder structure matches expected layout"
    echo "- Verify all files were created"
    echo "- Run from Ubod directory: bash scripts/validate-setup.sh"
    exit 1
fi
