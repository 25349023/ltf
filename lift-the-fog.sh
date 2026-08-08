#!/usr/bin/env bash

set -eEuo pipefail


# ======================================== 
#  set up basic environment / packages
# ======================================== 

sudo -v

sudo apt update
sudo apt install -y git 


WORK_DIR=/tmp/ltf
if [[ -d ${WORK_DIR} ]] ; then
    git -C pull --rebase
else
    git clone https://github.com/25349023/ltf.git "${WORK_DIR}"
fi
cd "${WORK_DIR}"

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

[[ -s ~/.bashrc.ltf-orig ]] || cp ~/.bashrc ~/.bashrc.ltf-orig

SOURCE_CMD='[[ -f ~/.bashrc.ltf ]] && source ~/.bashrc.ltf'
if ! grep -Fxq "${SOURCE_CMD}" ~/.bashrc ; then
    printf "\n%s\n" "${SOURCE_CMD}" >> ~/.bashrc
fi

cp configs/.bashrc.patch  ~/.bashrc.ltf
cp -r configs/.bashrc.d ~


# ======================================== 
#  install optional packages
# ======================================== 

source opt-pkgs.conf

if [[ -t 0 && -t 1 ]] ; then
    CHOICES=$(whiptail --title "Lift The Fog - Packages Selection" \
        --checklist "Use [SPACE] to select/deselect, [ENTER] to confirm:" 15 65 3 \
        "${PACKAGE_LIST[@]}" \
        3>&1 1>&2 2>&3) || true
else
    echo "==> Non-interactive mode detected. Installing all default packages."
    default_pkgs=()
    for (( i=0; i < ${#PACKAGE_LIST[@]}; i+=3 )) ; do
        pkg_name=${PACKAGE_LIST[i]}
        pkg_en=${PACKAGE_LIST[i+2]}

        if [[ ${pkg_en} == "ON" ]] ; then
            default_pkgs+=( "\"${pkg_name}\"" )
        fi

    done
    CHOICES="${default_pkgs[*]}"
fi

if [[ -z "${CHOICES}" ]]; then
    echo "==> No packages selected or action cancelled. Exiting."
    exit 0
fi

echo "Selected packages: ${CHOICES}"

PACKAGE_ORDER=("etckeeper" "docker" "firewalld")

for pkg in "${PACKAGE_ORDER[@]}"; do
    if [[ "${CHOICES}" =~ \"${pkg}\" ]]; then
        script_path="./packages/install-${pkg}.sh"
        if [[ -f "${script_path}" ]]; then
            echo "==> [Installing] ${pkg}..."
            bash "${script_path}"
        else
            echo "==> [Warning] Script not found: ${script_path}"
        fi
    fi
done


# ======================================== 
#  install custom scripts
# ======================================== 
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin

