#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges root. Utilisez sudo."
  exit 1
fi

#_______________________________________________NEW USER______________________________________________________

read -p "Entrez le nom du nouvel utilisateur: " NEW_USER

adduser $NEW_USER
usermod -aG sudo $NEW_USER
mkdir -p /home/$NEW_USER/.ssh
chmod 700 /home/$NEW_USER/.ssh
systemctl restart ssh
echo "Le nouvel utilisateur $NEW_USER a été créé avec succès et ajouté au groupe sudo."

#_______________________________________________DISABLE USER______________________________________________________

disable_user() {
  local USER_TO_DISABLE=$1
  usermod -L $USER_TO_DISABLE
  echo "DenyUsers $USER_TO_DISABLE" >> /etc/ssh/sshd_config
  echo "L'utilisateur $USER_TO_DISABLE a été verrouillé et son accès SSH a été désactivé."
}

while true; do
  read -p "Voulez-vous désactiver un utilisateur ? (oui/non) : " REPLY
  if [[ "$REPLY" =~ ^[Oo][Uu][Ii]$ ]]; then
    read -p "Entrez le nom de l'utilisateur à désactiver: " USER_TO_DISABLE
    disable_user $USER_TO_DISABLE
  else
    break
  fi
done

read -p "Entrez le nom du serveur: " NEW_HOSTNAME

sudo hostnamectl set-hostname $NEW_HOSTNAME

echo $NEW_HOSTNAME | sudo tee /etc/hostname
sudo sed -i "s/127.0.1.1.*/127.0.1.1    $NEW_HOSTNAME/" /etc/hosts
echo "Le nom d'hôte a été changé en $NEW_HOSTNAME. Le serveur va maintenant redémarrer."
sudo reboot