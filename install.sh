#!/usr/bin/env bash
# Antigravity Skills & Plugins Suite Installer for macOS & Linux
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.gemini/config"

echo ""
echo "🚀 Antigravity Skills & Plugins Pack Installer (macOS/Linux)"
echo "Target: $CONFIG_DIR"
echo ""

mkdir -p "$CONFIG_DIR/skills"
mkdir -p "$CONFIG_DIR/plugins"

# 1. Install Skills
echo "📦 Installing skills to $CONFIG_DIR/skills..."
cp -R "$SCRIPT_DIR/skills/"* "$CONFIG_DIR/skills/"

# Meta learner in ~/.gemini/antigravity/skills if available
AGY_SKILLS="$HOME/.gemini/antigravity/skills"
if [ -d "$SCRIPT_DIR/skills/global-meta-learner" ]; then
    mkdir -p "$AGY_SKILLS"
    cp -R "$SCRIPT_DIR/skills/global-meta-learner" "$AGY_SKILLS/"
fi

# 2. Install Plugins
echo "🔌 Installing plugins to $CONFIG_DIR/plugins..."
cp -R "$SCRIPT_DIR/plugins/"* "$CONFIG_DIR/plugins/"

# 3. Configure plugins in config.json using python/node or basic jq
CONFIG_FILE="$CONFIG_DIR/config.json"
if command -v python3 >/dev/null 2>&1; then
    python3 -c "
import json, os

config_file = '$CONFIG_FILE'
data = {}
if os.path.exists(config_file):
    try:
        with open(config_file, 'r') as f:
            data = json.load(f)
    except:
        data = {}

if 'plugins' not in data or not isinstance(data['plugins'], dict):
    data['plugins'] = {}

plugins = [
    'android-cli-plugin',
    'chrome-devtools-plugin',
    'flutter',
    'google-antigravity-sdk',
    'modern-web-guidance-plugin',
    'ponytail',
    'ui-ux-pro-max-plugin'
]

for p in plugins:
    if p not in data['plugins']:
        data['plugins'][p] = {'enabled': True}
    else:
        data['plugins'][p]['enabled'] = True

with open(config_file, 'w') as f:
    json.dump(data, f, indent=2)
"
    echo "⚙️  Registered and enabled all plugins in config.json"
fi

# 4. Rules (AGENTS.md)
if [ -f "$SCRIPT_DIR/AGENTS.md" ]; then
    if [ ! -f "$CONFIG_DIR/AGENTS.md" ]; then
        cp "$SCRIPT_DIR/AGENTS.md" "$CONFIG_DIR/AGENTS.md"
        echo "📜 Installed global rules to $CONFIG_DIR/AGENTS.md"
    else
        if ! grep -q "GSAP Animations" "$CONFIG_DIR/AGENTS.md"; then
            cat "$SCRIPT_DIR/AGENTS.md" >> "$CONFIG_DIR/AGENTS.md"
            echo "📜 Appended GSAP & TinyFish rules to existing AGENTS.md"
        fi
    fi
fi

# 5. MCP Config
if [ ! -f "$CONFIG_DIR/mcp_config.json" ] && [ -f "$SCRIPT_DIR/mcp_config.template.json" ]; then
    cp "$SCRIPT_DIR/mcp_config.template.json" "$CONFIG_DIR/mcp_config.json"
    echo "🔗 Created default mcp_config.json"
fi

echo ""
echo "✅ Installation Complete! Restart Antigravity to activate all skills and plugins."
echo ""
