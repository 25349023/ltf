#!/usr/bin/env bash

set -eEuo pipefail

sudo -v

sudo apt install -y git 

cd /tmp
git clone https://github.com/25349023/ltf.git
cd ltf
cp configs/.gitconfig ~

sudo apt install -y vim tmux
cp configs/.vimrc ~
cp configs/.tmux.conf ~

cp ~/.bashrc ~/.bashrc.old
cat configs/.bashrc.patch >> ~/.bashrc 

sudo apt update
sudo apt install -y etckeeper
sudo etckeeper init

sudo apt install -y firewalld
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-port=5900/udp --permanent  # for vnc server
sudo firewall-cmd --add-port=5900/tcp --permanent  # for vnc server

