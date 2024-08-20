#!/bin/bash

# Couleurs pour les impressions stylisées
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}${BOLD}This script must be run as root. Please use sudo.${RESET}"
  exit 1
fi

#_______________________________________________NEW USER__________________________________________________________

echo -e "${CYAN}${BOLD}--- User Management ---${RESET}"

echo -e "${YELLOW}Do you want to create a new user? (yes/no): ${RESET}"
read REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the name of the new user: ${RESET}"
    read NEW_USER
    adduser $NEW_USER
    usermod -aG sudo $NEW_USER
    mkdir -p /home/$NEW_USER/.ssh
    chmod 700 /home/$NEW_USER/.ssh
    systemctl restart ssh
    echo -e "${GREEN}${BOLD}The new user $NEW_USER has been successfully created and added to the sudo group.${RESET}"
fi

#_______________________________________________DISABLE USER______________________________________________________

echo -e "${CYAN}${BOLD}--- Disable User ---${RESET}"

while true; do
  echo -e "${YELLOW}Do you want to disable a user? (yes/no): ${RESET}"
  read REPLY
  if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the name of the user to disable: ${RESET}"
    read USER_TO_DISABLE
    usermod -L $USER_TO_DISABLE
    echo "DenyUsers $USER_TO_DISABLE" >> /etc/ssh/sshd_config
    echo -e "${GREEN}${BOLD}The user $USER_TO_DISABLE has been locked and their SSH access disabled.${RESET}"
  else
    break
  fi
done

#_______________________________________________CHANGE SERVER NAME_______________________________________________

echo -e "${CYAN}${BOLD}--- Change Server Name ---${RESET}"

echo -e "${YELLOW}Do you want to change the server name? (yes/no): ${RESET}"
read REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the new server name: ${RESET}"
    read NEW_HOSTNAME
    sudo hostnamectl set-hostname $NEW_HOSTNAME
    echo $NEW_HOSTNAME | sudo tee /etc/hostname > /dev/null
    sudo sed -i "s/127.0.1.1\s\+.*/127.0.1.1    $NEW_HOSTNAME/" /etc/hosts
    echo -e "${GREEN}${BOLD}The hostname has been changed to $NEW_HOSTNAME.${RESET}"
fi

#_______________________________________________UPDATE & UPGRADE SERVER__________________________________________

echo -e "${CYAN}${BOLD}--- Update & Upgrade Server ---${RESET}"

echo -e "${YELLOW}Do you want to update and upgrade the server? (yes/no): ${RESET}"
read REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${CYAN}${BOLD}Updating package lists...${RESET}"
    sudo apt-get update
    echo -e "${CYAN}${BOLD}Upgrading installed packages...${RESET}"
    sudo apt-get upgrade -y
    echo -e "${GREEN}${BOLD}The server has been updated and upgraded successfully.${RESET}"
fi

#_______________________________________________REBOOT SERVER_____________________________________________________

echo -e "${CYAN}${BOLD}--- Reboot Server ---${RESET}"

echo -e "${YELLOW}Do you want to reboot the server? (yes/no): ${RESET}"
read REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${RED}${BOLD}The server will now reboot.${RESET}"
    sudo reboot
fi
