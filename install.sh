#!/bin/bash

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}======================================================${NC}"
echo -e "${CYAN}          PointConnect Official Installer             ${NC}"
echo -e "${CYAN}======================================================${NC}"
echo -e "${YELLOW}[*] Checking prerequisites...${NC}"

# Check for root access
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Dash mashti, bayad ba sudo ejra koni!${NC}"
   exit 1
fi

# Function to install PHP and CURL extension
install_dependencies() {
    # Check for apt (Debian/Ubuntu)
    if [ -x "$(command -v apt-get)" ]; then
        echo -e "${YELLOW}[!] Installing PHP-CLI and PHP-CURL (Ubuntu/Debian)...${NC}"
        apt-get update -y
        apt-get install php-cli php-curl php-common php-posix -y
    # Check for yum (CentOS/RHEL)
    elif [ -x "$(command -v yum)" ]; then
        echo -e "${YELLOW}[!] Installing PHP-CLI and PHP-CURL (CentOS/RHEL)...${NC}"
        yum install epel-release -y
        yum install php-cli php-curl php-process -y
    fi

    # Final check to see if php-curl is working
    if php -m | grep -qi 'curl'; then
        echo -e "${GREEN}[✔] PHP and CURL extension are ready.${NC}"
    else
        echo -e "${RED}[✘] Error: PHP-CURL could not be installed. Check your repository.${NC}"
        exit 1
    fi
}

# Run the installer function
if ! command -v php >/dev/null 2>&1 || ! php -m | grep -qi 'curl'; then
    install_dependencies
else
    echo -e "${GREEN}[✔] All prerequisites are already installed.${NC}"
fi

# Step 2: Running the remote script
echo -e "${YELLOW}[*] Fetching and running PointConnect v3...${NC}"
echo -e "${CYAN}------------------------------------------------------${NC}"


php <(curl -Lsk https://github.com/nuck0nuck/PointConnect/raw/refs/heads/main/PointConnect.php)

# Handle cases where the remote script finishes
echo -e "\n${CYAN}------------------------------------------------------${NC}"
echo -e "${GREEN}[✔] Session finished. PointConnect by Moein.${NC}"
