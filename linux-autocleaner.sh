#!/bin/bash

# ================================
#   Linux AutoCleaner v1.0
#   by Martin
# ================================

GREEN="\e[32m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}=== Linux AutoCleaner v1.0 ===${RESET}"
echo "Starting optimization..."
sleep 1

# --- Check sudo ---
if [[ $EUID -ne 0 ]]; then
    echo "Please run with: sudo ./linux-autocleaner.sh"
    exit 1
fi

# --- Clean package cache ---
echo -e "${GREEN}→ Cleaning package cache...${RESET}"
if command -v pacman &> /dev/null; then
    pacman -Scc --noconfirm
elif command -v apt &> /dev/null; then
    apt clean
elif command -v dnf &> /dev/null; then
    dnf clean all
elif command -v zypper &> /dev/null; then
    zypper clean
fi

# --- Remove old logs ---
echo -e "${GREEN}→ Removing old logs...${RESET}"
rm -f /var/log/*.log
journalctl --vacuum-time=7d &>/dev/null

# --- Clear thumbnail cache ---
echo -e "${GREEN}→ Clearing thumbnail cache...${RESET}"
rm -rf ~/.cache/thumbnails/*

# --- Remove orphan packages (Arch only) ---
if command -v pacman &> /dev/null; then
    echo -e "${GREEN}→ Removing orphan packages...${RESET}"
    pacman -Qtdq &>/dev/null && pacman -Rns $(pacman -Qtdq) --noconfirm
fi

# --- System info ---
echo -e "${CYAN}\n=== System Info ===${RESET}"
echo "Uptime:"; uptime
echo "Disk usage:"; df -h /

echo -e "${CYAN}\n🎉 Optimization Done! Your system should feel faster.${RESET}"
