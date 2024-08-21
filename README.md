# Setup Server Script

## Description

Ce script permet de gérer facilement les utilisateurs, de modifier le nom du serveur, de mettre à jour le système, et bien plus encore sur un serveur Ubuntu. Il a été conçu pour automatiser certaines tâches administratives courantes, rendant la gestion du serveur plus efficace et moins sujette aux erreurs.

## Prérequis

- Un serveur Ubuntu.
- Accès root ou des privilèges sudo.

## Installation

### 1. Télécharger la dernière version

Pour télécharger la dernière version du package `.deb`, utilisez la commande suivante. Cette commande télécharge le package et l'enregistre sous le nom `setup-server.deb` :

```bash
wget -O setup-server.deb <package http address>
```
### 2. Installer le package

Une fois le package téléchargé, installez-le avec dpkg :

```bash
sudo dpkg -i setup-server.deb
```
### 3. Nettoyer après l'installation
Après l'installation, vous pouvez supprimer le fichier .deb pour libérer de l'espace disque :
```bash
rm setup-server.deb
```

> [!TIP]
> Vous pouvez effectuer tout ceci en une seul commande
> ```bash
> wget -O setup-server.deb <package http address> && sudo dpkg -i setup-server.deb && rm setup-server.deb
> ```

## Utilisation
Une fois le package installé, exécutez le script en utilisant la commande suivante :
```bash
sudo setup-server
```
Le script vous posera une série de questions pour configurer et gérer votre serveur. Il vous permet de :

- Créer de nouveaux utilisateurs.
- Désactiver des utilisateurs existants.
- Changer le nom du serveur.
- Mettre à jour et upgrader le système.
- Redémarrer le serveur.

### Exemples d'utilisation

1. Créer un nouvel utilisateur :
   - Lancez le script : sudo setup-server.
   - Répondez "yes" à la question "Do you want to create a new user?".
   - Suivez les instructions pour entrer le nom de l'utilisateur et configurer l'accès SSH.
  
2. Désactiver un utilisateur :
   - Lancez le script : sudo setup-server.
   - Répondez "yes" à la question "Do you want to disable a user?".
   - Entrez le nom de l'utilisateur à désactiver.

3. Changer le nom du serveur :
   - Lancez le script : sudo setup-server.
   - Répondez "yes" à la question "Do you want to change the server name?".
   - Entrez le nouveau nom du serveur.

4. Mettre à jour et upgrader le serveur :
   - Lancez le script : sudo setup-server.
   - Répondez "yes" à la question "Do you want to update and upgrade the server?".

5. Redémarrer le serveur :
   - Lancez le script : sudo setup-server.
   - Répondez "yes" à la question "Do you want to reboot the server?".


## Désinstallation
Si vous souhaitez désinstaller le script, vous pouvez le faire en utilisant la commande suivante :
```bash
sudo dpkg -r setup-server
```

## Contributions
Les contributions sont les bienvenues ! Si vous souhaitez contribuer :

1. Forkez le dépôt.
2. Créez une branche pour votre fonctionnalité (git checkout -b ma-nouvelle-fonctionnalité).
3. Commitez vos modifications (git commit -am 'Ajout d'une nouvelle fonctionnalité').
4. Poussez la branche (git push origin ma-nouvelle-fonctionnalité).
5. Soumettez une pull request.
Merci de vous assurer que vos contributions respectent les lignes directrices du projet.

## Licence
Ce projet est sous licence MIT. Consultez le fichier LICENSE pour plus de détails.
