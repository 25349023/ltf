#!/usr/bin/env bash

set -eEuo pipefail

sudo -v

cp ~/.bashrc ~/.bashrc.old
cat .bashrc.patch >> ~/.bashrc 

sudo apt update
sudo apt install -y etckeeper
sudo etckeeper init

sudo apt install -y git vim tmux
git config --global user.name 25349023
git config --global user.email 25349023.qq@gmail.com
git config --global alias.st status
git config --global alias.l "log --oneline"
cp ~/.tmux.conf ~/.tmux.conf.old
cp .tmux.conf ~


sudo apt install -y firewalld
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-port=5900/udp --permanent  # for vnc server
sudo firewall-cmd --add-port=5900/tcp --permanent  # for vnc server
