#!/usr/bin/env bash

# function backup() {

# }

set -eEuo pipefail

sudo -v

cp ~/.bashrc ~/.bashrc.old
cat configs/.bashrc.patch >> ~/.bashrc 

sudo apt update
sudo apt install -y etckeeper
sudo etckeeper init

sudo apt install -y git vim tmux

cp configs/.vimrc ~
cp configs/.gitconfig ~
cp configs/.tmux.conf ~


sudo apt install -y firewalld
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-port=5900/udp --permanent  # for vnc server
sudo firewall-cmd --add-port=5900/tcp --permanent  # for vnc server
