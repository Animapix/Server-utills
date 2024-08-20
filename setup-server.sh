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

# _____________________________________________POSER LES QUESTIONS_________________________________________________

echo -e "${CYAN}${BOLD}--- User Management ---${RESET}"

echo -e "${YELLOW}Do you want to create a new user? (yes/no): ${RESET}"
read CREATE_NEW_USER

if [[ "$CREATE_NEW_USER" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the name of the new user: ${RESET}"
    read NEW_USER
    echo -e "${YELLOW}Do you want to create .ssh folder ? (yes/no): ${RESET}"
    read CREATE_SSH_FOLDER
    if [[ "$CREATE_SSH_FOLDER" =~ ^[Yy][Ee][Ss]$ ]]; then
        echo -e "${YELLOW}Do you want to add a public key to the .ssh folder? (yes/no): ${RESET}"
        read ADD_PUBLIC_KEY
        if [[ "$ADD_PUBLIC_KEY" =~ ^[Yy][Ee][Ss]$ ]]; then
            echo -e "${YELLOW}Enter the public key: ${RESET}"
            read PUBLIC_KEY
        fi
    fi
fi

echo -e "${CYAN}${BOLD}--- Disable User ---${RESET}"

echo -e "${YELLOW}Do you want to disable a user? (yes/no): ${RESET}"
read DISABLE_USER
if [[ "$DISABLE_USER" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the name of the user to disable: ${RESET}"
    read USER_TO_DISABLE
fi

echo -e "${CYAN}${BOLD}--- Change Server Name ---${RESET}"

echo -e "${YELLOW}Do you want to change the server name? (yes/no): ${RESET}"
read CHANGE_SERVER_NAME
if [[ "$CHANGE_SERVER_NAME" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${YELLOW}Enter the new server name: ${RESET}"
    read NEW_HOSTNAME
fi

echo -e "${CYAN}${BOLD}--- Update & Upgrade Server ---${RESET}"

echo -e "${YELLOW}Do you want to update and upgrade the server? (yes/no): ${RESET}"
read UPDATE_UPGRADE

echo -e "${CYAN}${BOLD}--- Reboot Server ---${RESET}"

echo -e "${YELLOW}Do you want to reboot the server? (yes/no): ${RESET}"
read REBOOT_SERVER

# _____________________________________________EXÉCUTER LES ACTIONS_________________________________________________

# Créer un nouvel utilisateur
if [[ "$CREATE_NEW_USER" =~ ^[Yy][Ee][Ss]$ ]]; then
    adduser $NEW_USER
    usermod -aG sudo $NEW_USER
    if [[ "$CREATE_SSH_FOLDER" =~ ^[Yy][Ee][Ss]$ ]]; then
        mkdir -p /home/$NEW_USER/.ssh
        chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh
        chmod 700 /home/$NEW_USER/.ssh
        echo -e "${GREEN}${BOLD}The .ssh folder has been created successfully.${RESET}"
        if [[ "$ADD_PUBLIC_KEY" =~ ^[Yy][Ee][Ss]$ ]]; then
            echo $PUBLIC_KEY > /home/$NEW_USER/.ssh/authorized_keys
            chown $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/authorized_keys
            chmod 600 /home/$NEW_USER/.ssh/authorized_keys
            echo -e "${GREEN}${BOLD}The public key has been added to the .ssh folder.${RESET}"
        fi
    fi
    systemctl restart ssh
    echo -e "${GREEN}${BOLD}The new user $NEW_USER has been successfully created and added to the sudo group.${RESET}"
fi

# Désactiver un utilisateur
if [[ "$DISABLE_USER" =~ ^[Yy][Ee][Ss]$ ]]; then
    usermod -L $USER_TO_DISABLE
    echo "DenyUsers $USER_TO_DISABLE" >> /etc/ssh/sshd_config
    echo -e "${GREEN}${BOLD}The user $USER_TO_DISABLE has been locked and their SSH access disabled.${RESET}"
fi

# Changer le nom du serveur
if [[ "$CHANGE_SERVER_NAME" =~ ^[Yy][Ee][Ss]$ ]]; then
    sudo hostnamectl set-hostname $NEW_HOSTNAME
    echo $NEW_HOSTNAME | sudo tee /etc/hostname > /dev/null
    sudo sed -i "s/127.0.1.1\s\+.*/127.0.1.1    $NEW_HOSTNAME/" /etc/hosts
    echo -e "${GREEN}${BOLD}The hostname has been changed to $NEW_HOSTNAME.${RESET}"
fi

# Mettre à jour et upgrader le serveur
if [[ "$UPDATE_UPGRADE" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${CYAN}${BOLD}Updating package lists...${RESET}"
    sudo apt-get update
    echo -e "${CYAN}${BOLD}Upgrading installed packages...${RESET}"
    sudo apt-get upgrade -y
    echo -e "${GREEN}${BOLD}The server has been updated and upgraded successfully.${RESET}"
fi

# Redémarrer le serveur
if [[ "$REBOOT_SERVER" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${RED}${BOLD}The server will now reboot.${RESET}"
    sudo reboot
fi
