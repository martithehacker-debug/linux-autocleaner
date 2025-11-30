#!/bin/bash
# Linux AutoCleaner v1.0 - Safe multi-distro cleanup

echo "=== Linux AutoCleaner v1.0 ==="
echo "Starting optimization..."

# Function to confirm actions
confirm() {
    read -p "$1 [y/N]: " response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Detect package manager
if command -v pacman &>/dev/null; then
    PKG="pacman"
elif command -v apt &>/dev/null; then
    PKG="apt"
elif command -v dnf &>/dev/null; then
    PKG="dnf"
elif command -v zypper &>/dev/null; then
    PKG="zypper"
else
    echo "Unsupported Linux distribution."
    exit 1
fi

# Clean package cache
if confirm "→ Remove all cached packages?"; then
    case "$PKG" in
        pacman) sudo pacman -Scc ;;
        apt) sudo apt clean ;;
        dnf) sudo dnf clean all ;;
        zypper) sudo sudo zypper clean ;;
    esac
else
    echo "Skipping package cache cleanup."
fi

# Remove orphan packages (Arch only)
if [[ "$PKG" == "pacman" ]] && confirm "→ Remove orphan packages?"; then
    ORPHANS=$(pacman -Qtdq)
    if [[ -n "$ORPHANS" ]]; then
        sudo pacman -Rns $ORPHANS
    else
        echo "No orphan packages found."
    fi
fi

# Remove old logs
if confirm "→ Remove old logs?"; then
    sudo rm -v /var/log/*.log
fi

# Clear thumbnail cache
if confirm "→ Clear thumbnail cache?"; then
    rm -rf ~/.cache/thumbnails/*
fi

# Show system info
echo "=== System Info ==="
uptime
df -h

echo "🎉 Optimization Done! Your system should feel faster."

