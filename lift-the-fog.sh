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
cd /usr/bin
[[ -f ./bat ]] || sudo ln -s batcat bat
cd /tmp/ltf


# ======================================== 
#  tool configuration
# ======================================== 
cp configs/.gitconfig configs/.vimrc configs/.tmux.conf ~


# ======================================== 
#  update bashrc
# ======================================== 
if [[ ! -f ~/.bashrc.old ]] ; then
    cp ~/.bashrc ~/.bashrc.old
    printf "\nsource ~/.bashrc.ltf\n" >> ~/.bashrc
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

