set -eEuo pipefail

sudo -v
sudo apt install -y firewalld
sudo firewall-cmd --add-service=mdns --permanent
sudo firewall-cmd --add-port=5900/udp --permanent  # for vnc server
sudo firewall-cmd --add-port=5900/tcp --permanent  # for vnc server
sudo firewall-cmd --reload
