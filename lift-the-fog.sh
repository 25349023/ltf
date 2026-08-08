#!/usr/bin/env bash

set -eEuo pipefail


# ======================================== 
#  set up basic environment / packages
# ======================================== 

sudo -v

sudo apt update
sudo apt install -y git 

cd /tmp
git clone https://github.com/25349023/ltf.git
cd ltf

sudo apt install -y vim tmux
sudo apt install -y bat ripgrep
[[ -e /usr/bin/bat ]] || sudo ln -s /usr/bin/batcat /usr/bin/bat


# ======================================== 
#  tool configuration
# ======================================== 
cp configs/.gitconfig configs/.vimrc configs/.tmux.conf ~


# ======================================== 
#  update bashrc
# ======================================== 

SOURCE_CMD='[[ -f ~/.bashrc.ltf ]] && source ~/.bashrc.ltf'
if ! grep -Fxq "${SOURCE_CMD}" ~/.bashrc ; then
    cp ~/.bashrc ~/.bashrc.orig
    printf "\n%s\n" "${SOURCE_CMD}" >> ~/.bashrc
fi

cp configs/.bashrc.patch  ~/.bashrc.ltf
cp -r configs/.bashrc.d ~


# ======================================== 
#  install optional packages
# ======================================== 
./packages/install-docker.sh

sudo apt install -y etckeeper
sudo etckeeper init

sudo apt install -y firewalld
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-port=5900/udp --permanent  # for vnc server
sudo firewall-cmd --add-port=5900/tcp --permanent  # for vnc server


# ======================================== 
#  install custom scripts
# ======================================== 
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin

