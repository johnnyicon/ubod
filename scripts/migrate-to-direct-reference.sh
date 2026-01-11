#!/bin/bash
# Ubod Deployment Model Migration
# Migrates from copy model to direct reference via settings.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo "🔄 Migrating to Ubod Direct Reference Model"
echo ""
echo "This script:"
echo "  1. Removes copied prompts (now referenced via settings.json)"
echo "  2. Removes copied instructions (now referenced via settings.json)"
echo "  3. Updates .vscode/settings.json"
echo "  4. Keeps agents (still needs copying)"
echo ""

# Check if ubod submodule exists
if [ ! -d "$REPO_ROOT/projects/ubod" ]; then
    echo "❌ Error: projects/ubod not found"
    echo "   Run: git submodule update --init --recursive"
    exit 1
fi

# Backup settings.json
if [ -f "$REPO_ROOT/.vscode/settings.json" ]; then
    echo "📋 Backing up .vscode/settings.json..."
    cp "$REPO_ROOT/.vscode/settings.json" "$REPO_ROOT/.vscode/settings.json.backup-$(date +%Y%m%d-%H%M%S)"
fi

# Remove copied prompts
if [ -d "$REPO_ROOT/.github/prompts/ubod" ]; then
    echo "🗑️  Removing .github/prompts/ubod/ (now referenced directly)..."
    rm -rf "$REPO_ROOT/.github/prompts/ubod"
else
    echo "✅ No copied prompts to remove"
fi

# Remove copied instructions
if [ -d "$REPO_ROOT/.github/instructions/ubod" ]; then
    echo "🗑️  Removing .github/instructions/ubod/ (now referenced directly)..."
    rm -rf "$REPO_ROOT/.github/instructions/ubod"
else
    echo "✅ No copied instructions to remove"
fi

# Update settings.json
echo "⚙️  Updating .vscode/settings.json..."

if [ ! -f "$REPO_ROOT/.vscode/settings.json" ]; then
    echo "   Creating .vscode/settings.json..."
    mkdir -p "$REPO_ROOT/.vscode"
    cat > "$REPO_ROOT/.vscode/settings.json" <<'EOF'
{
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "projects/ubod/templates/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    "projects/ubod/prompts": true
  }
}
EOF
    echo "✅ Created settings.json"
else
    # Check if jq is available
    if command -v jq &> /dev/null; then
        # Use jq to update JSON
        jq '. + {
          "chat.instructionsFilesLocations": (.["chat.instructionsFilesLocations"] // {}) + {"projects/ubod/templates/instructions": true},
          "chat.promptFilesLocations": (.["chat.promptFilesLocations"] // {}) + {"projects/ubod/prompts": true}
        } | del(.["chat.promptFilesLocations"][".github/prompts/ubod"]) | del(.["chat.instructionsFilesLocations"][".github/instructions/ubod"])' \
        "$REPO_ROOT/.vscode/settings.json" > "$REPO_ROOT/.vscode/settings.json.tmp"
        mv "$REPO_ROOT/.vscode/settings.json.tmp" "$REPO_ROOT/.vscode/settings.json"
        echo "✅ Updated settings.json (via jq)"
    else
        echo "⚠️  jq not found - manually add to settings.json:"
        echo '    "projects/ubod/templates/instructions": true (in chat.instructionsFilesLocations)'
        echo '    "projects/ubod/prompts": true (in chat.promptFilesLocations)'
    fi
fi

echo ""
echo "✅ Migration complete!"
echo ""
echo "📝 Summary:"
echo "   - Removed: .github/prompts/ubod/ (now: projects/ubod/prompts/)"
echo "   - Removed: .github/instructions/ubod/ (now: projects/ubod/templates/instructions/)"
echo "   - Updated: .vscode/settings.json (added direct references)"
echo "   - Kept: .github/agents/ (still needs copying)"
echo ""
echo "🔄 Next steps:"
echo "   1. Reload VS Code window (Cmd+Shift+P → 'Reload Window')"
echo "   2. Test: Try invoking /ubod-checkin (should work!)"
echo "   3. Commit changes: git add .vscode/settings.json .github/"
echo ""
