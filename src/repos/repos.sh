#!/bin/bash

# Funções que adicionam repositorios a sua respctiva distro.

# shellcheck disable=SC1091
# shellcheck disable=SC2086
source ./config/.env
source ./config/functions.sh
data=$(date +%d-%m-%Y)
area="Repos-repos"
LOGFILE="./logs/[$data]-[$area]-Adicao-repositorios.log"

function repos_ubuntu() {
    # Repositorios para Ubuntu | Debian | Linux Mint | Pop_os
    {
        echo "Adicionando repositórios oficiais Ubuntu | Debian | Pop_os | Linux Mint."
        sudo add-apt-repository universe -y
        sudo add-apt-repository multiverse -y
        sudo add-apt-repository restricted -y
    } >>"$LOGFILE" 2>&1
    pause
}

function repos_fedora(){
    {
    echo "Adicionando repositórios oficiais Fedora."
    sudo dnf install \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$version.noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$version.noarch.rpm -y
    sudo dnf update -y
    }>> "$LOGFILE" 2>&1
    pause
}

function repos_arch(){
    # Repositorios para ArchLinux | Manjaro
    {
    echo "Adicionando repositórios no Arch Linux."
    sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB
    echo "
    [chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist
    " | sudo tee -a /etc/pacman.conf

    sudo pacman -Sy
    } >>"$LOGFILE" 2>&1
    pause
}

function repos_opensuse() {
    {
    echo "Adicionando repositórios OpenSUSE."
    sudo zypper addrepo -f https://download.opensuse.org/repositories/home:manzoku/openSUSE_Tumbleweed/home:manzoku.repo
    sudo zypper refresh
    }>> "$LOGFILE" 2>&1
    pause
}