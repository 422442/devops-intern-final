#!/bin/bash

###############################################################################
# System Information Script
# Description: Displays current system information including user, date, and disk usage
# Author: DevOps Engineer
# Date: October 17, 2025
###############################################################################

# Colors for better readability
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print header
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   SYSTEM INFORMATION REPORT${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Current User
echo -e "${BLUE}Current User:${NC}"
whoami
echo ""

# Current Date and Time
echo -e "${BLUE}Current Date and Time:${NC}"
date
echo ""

# System Uptime
echo -e "${BLUE}System Uptime:${NC}"
uptime
echo ""

# Disk Usage
echo -e "${BLUE}Disk Usage:${NC}"
df -h
echo ""

# Memory Usage (if free command is available)
if command -v free &> /dev/null; then
    echo -e "${BLUE}Memory Usage:${NC}"
    free -h
    echo ""
fi

# CPU Information (basic)
if [ -f /proc/cpuinfo ]; then
    echo -e "${BLUE}CPU Information:${NC}"
    grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs
    echo ""
elif command -v sysctl &> /dev/null; then
    # For macOS
    echo -e "${BLUE}CPU Information:${NC}"
    sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "CPU info not available"
    echo ""
fi

# Network Information (hostname)
echo -e "${BLUE}Hostname:${NC}"
hostname
echo ""

# Current Working Directory
echo -e "${BLUE}Current Working Directory:${NC}"
pwd
echo ""

# Print footer
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   Report Generated Successfully${NC}"
echo -e "${GREEN}========================================${NC}"
