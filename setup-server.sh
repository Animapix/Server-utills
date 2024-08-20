#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Please use sudo."
  exit 1
fi

#_______________________________________________NEW USER__________________________________________________________

read -p "Do you want to create a new user? (yes/no) : " REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    read -p "Enter the name of the new user: " NEW_USER
    adduser $NEW_USER
    usermod -aG sudo $NEW_USER
    mkdir -p /home/$NEW_USER/.ssh
    chmod 700 /home/$NEW_USER/.ssh
    systemctl restart ssh
    echo "The new user $NEW_USER has been successfully created and added to the sudo group."
fi

#_______________________________________________DISABLE USER______________________________________________________

while true; do
  read -p "Do you want to disable a user? (yes/no) : " REPLY
  if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    read -p "Enter the name of the user to disable: " USER_TO_DISABLE
    usermod -L $USER_TO_DISABLE
    echo "DenyUsers $USER_TO_DISABLE" >> /etc/ssh/sshd_config
    echo "The user $USER_TO_DISABLE has been locked and their SSH access disabled."
  else
    break
  fi
done

#_______________________________________________CHANGE SERVER NAME_______________________________________________

read -p "Do you want to change the server name? (yes/no) : " REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    read -p "Enter the new server name: " NEW_HOSTNAME
    sudo hostnamectl set-hostname $NEW_HOSTNAME
    echo $NEW_HOSTNAME | sudo tee /etc/hostname > /dev/null
    sudo sed -i "s/127.0.1.1\s\+.*/127.0.1.1    $NEW_HOSTNAME/" /etc/hosts
    echo "The hostname has been changed to $NEW_HOSTNAME."
fi

#_______________________________________________REBOOT SERVER_____________________________________________________

read -p "Do you want to reboot the server? (yes/no) : " REPLY

if [[ "$REPLY" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "The server will now reboot."
    sudo reboot
fi
