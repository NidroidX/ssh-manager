# ssh-manager

This script is a simple CLI (Command Line Interface) SSH connection manager ,you can easily manage your SSH connections via the CLI
without having to remember ip/hosts, ports , etc.


## Features
- Easily manage your SSH connections and connect to them quickly.
- Add new SSH connections.
- Edit exsisting SSH connections
- Delete old SSH connections.

## Requirements
- SSH Client
- Bash (version 4.0 or later)

## Installation

1. Clone the repository: 
``` 

git clone https://github.com/itachi1621/ssh-manager.git 

```
2. Move into the cloned directory with 

``` 

cd ssh-manager

```
3. Make the script executable with

``` 

chmod +x ssh-manager.sh

```
4. Execute the script using

``` 

./ssh-manager.sh 

```

## Optional Install To System

### To make available globally only to current user

```
cp ssh-manager.sh $HOME/.local/bin/ssh-manager

```

### To make available globally to all users

```
sudo cp ssh-manager.sh /usr/local/bin/ssh-manager

```

## Screenshots

**Main Menu**


![SSH Manager Menu](https://github.com/itachi1621/ssh-manager/assets/62318474/e28b12ea-6fcf-44f3-80eb-614d46cf0886)


**Add New SSH Connection**

![SSH Manager Add](https://user-images.githubusercontent.com/62318474/230812732-a9550f4a-6fd7-4f6c-b24c-cd440288e670.png)


**Edit SSH Connection**

![SSH Manager Edit](https://github.com/itachi1621/ssh-manager/assets/62318474/fef91e0e-1db7-4606-bf0e-1e8727a147e6)


**Connect to saved SSH Connection**

![SSH Manager Connect](https://user-images.githubusercontent.com/62318474/230813252-e3a6178f-2202-4ccf-88df-ca7bbb6ebaa6.png)

**List saved SSH connections**

![SSH Manager Saved Connections](https://user-images.githubusercontent.com/62318474/230813682-cd26cd01-5555-47c1-9cb4-013f96babb79.png)

**Delete a saved SSH connection**

![SSH Manager Delete Connection](https://user-images.githubusercontent.com/62318474/230813990-8376c235-2585-4455-92e0-5b8cfb0d2275.png)

## Tested On

- Ubuntu Server 22.04 LTS
- Ubuntu 22.04 LTS
- Ubuntu Server 20.04 LTS
- Debian 12

## License
This script is licensed under the MIT License.
