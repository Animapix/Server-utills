# Setup Server Script

## Description
This script allows you to create users, change the server name, update the system, and much more on an Ubuntu server. It is designed to automate common administrative tasks.

## Prerequisites
- An Ubuntu server.
- Root access or sudo privileges.

## Installation

### 1. Download the latest version
To download the latest version of the `.deb` package, use the following command. This command will download the package and save it as `setup-server.deb`:
```bash
wget -O setup-server.deb https://github.com/Animapix/Server-utills/releases/download/v1.1.1/setup-server.deb
```


### 2. Install the package
Once the package is downloaded, install it with dpkg:
```bash
sudo dpkg -i setup-server.deb
```

### 3. Clean up after installation
After the installation, you can delete the .deb file to free up disk space:
```bash
rm setup-server.deb
```
> [!TIP]
> You can do all of this in a single command:
> ```bash
> wget -O setup-server.deb https://github.com/Animapix/Server-utills/releases/download/v1.1.1/setup-server.deb && sudo dpkg -i setup-server.deb && rm setup-server.deb
> ```

## Usage
Once the package is installed, run the script using the following command:
```bash
sudo setup-server
```
The script will ask you a series of questions to configure and manage your server. It allows you to:
- Update and upgrade the system.
- Change the server name.
- Create new users.
- Disable existing users.
- Reboot the server.

## Uninstallation
If you want to uninstall the script, you can do so using the following command:
```bash
sudo dpkg -r setup-server
```

## Contributions
Contributions are welcome! If you would like to contribute:
1. Fork the repository.
2. Create a branch for your feature (git checkout -b my-new-feature).
3. Commit your changes (git commit -am 'Add a new feature').
4. Push the branch (git push origin my-new-feature).
5. Submit a pull request.
Please ensure your contributions follow the project's guidelines.

## Licence
This project is licensed under the MIT License. See the LICENSE file for more details.
