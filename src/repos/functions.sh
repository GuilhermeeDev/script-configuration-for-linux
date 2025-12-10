#!/bin/bash

# Funções que adicionam repositorios com base na distro.

# shellcheck disable=SC1091
# shellcheck disable=SC2086

source ./config/.env
source ./config/functions.sh
data=$(date +%d-%m-%Y)
area="Repos"
LOGFILE="./logs/[$data]-[$area]-adicionando-repositorios.log"

function listar_repos() {
    echo "Listando os repositórios atuais:"

    case "$id" in
    ubuntu|linuxmint|pop|debian)
        echo "[APT – Debian | Ubuntu | Linux Mint | Pop_os]" | tee -a "$LOGFILE"
        ls /etc/apt/sources.list.d/ | tee -a "$LOGFILE"
        echo "===========================================" | tee -a "$LOGFILE"
        cat /etc/apt/sources.lis | grep 'deb http' | tee -a "$LOGFILE"
    ;;
    arch|endeavouros|manjaro)
        echo "[Pacman – Arch Linux | EndeavourOS | Manjaro]" | tee -a "$LOGFILE"
        ls /etc/pacman.d/ | tee -a "$LOGFILE"
        echo "===========================================" | tee -a "$LOGFILE"
        cat /etc/pacman.conf | grep '\[.*\]' | tee -a "$LOGFILE"
    ;;
    fedora)
        echo "[DNF – Fedora]" | tee -a "$LOGFILE"
        ls /etc/yum.repos.d/ | tee -a "$LOGFILE"
        echo "===========================================" | tee -a "$LOGFILE"
        cat /etc/dnf/dnf.conf | tee -a "$LOGFILE"
    ;;
    opensuse* )
        echo "[Zypper – OpenSUSE]" | tee -a "$LOGFILE"
        ls /etc/zypp/repos.d/ | tee -a "$LOGFILE"
        echo "===========================================" | tee -a "$LOGFILE"
        cat /etc/zypp/zypp.conf | tee -a "$LOGFILE"
    ;;
    *)
        echo "Distribuição '$distro' não suportada ainda!" | tee -a "$LOGFILE"
        return 1
    ;;
    esac
    clear
}

function install_repos_oficiais() {
    echo "Iniciando a adição de repositórios oficiais para $distro!."
    echo "Listando repositórios antes da adição:" >> "$LOGFILE"
    listar_repos >> "$LOGFILE"
    sleep 3

    case "$id" in
        ubuntu|debian|linuxmint|pop)
            oficial_ubuntu
        ;;
        fedora)
            oficial_fedora
        ;;
        arch|manjaro|endeavouros)
            oficial_arch
        ;;
        opensuse* )
            oficial_opensuse
        ;;
        *)
            echo "Distribuição '$distro' não suportada ainda!"
            return 1
        ;;
    esac

    echo "Listando repositórios após a adição:" >> "$LOGFILE"
    listar_repos >> "$LOGFILE"
    echo "Repositórios oficiais adicionados com sucesso para $distro!" >> "$LOGFILE"
    echo ""
    pause
    clear
}

function install_repos_unoficiais(){
    
    echo "Iniciando a adição de repositórios não oficiais para $distro!."
    echo "Listando repositórios antes da adição:" >> "$LOGFILE"
    listar_repos >> "$LOGFILE"
    sleep 3

    case "$id" in
        ubuntu|debian|linuxmint|pop)
            unoficial_ubuntu
        ;;
        fedora)
            unoficial_fedora
        ;;
        arch|manjaro|endeavouros)
            unoficial_arch
        ;;
        opensuse* )
            unoficial_opensuse
        ;;
        *)
            echo "Distribuição '$distro' não suportada ainda!"
            return 1
        ;;
    esac

    echo "Listando repositórios após a adição:" >> "$LOGFILE"
    listar_repos >> "$LOGFILE"
    echo "Repositórios não oficiais adicionados com sucesso para $distro!" >> "$LOGFILE"
    echo ""
    pause
    clear
}

function oficial_ubuntu() {
    # Repositorios para Ubuntu | Debian | Linux Mint | Pop_os
    sudo add-apt-repository main -y
    sudo add-apt-repository universe -y
    sudo add-apt-repository multiverse -y
    sudo add-apt-repository restricted -y

    sudo apt update -y
}

function unoficial_ubuntu(){
    # Repositorios não oficiais para Ubuntu | Debian | Linux Mint | Pop_os
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo add-apt-repository ppa:libreoffice/ppa -y
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo add-apt-repository ppa:ondrej/php -y

    sudo apt update -y
}

function oficial_fedora(){
    # Repositorios oficiais para Fedora
    # sudo dnf config-manager --set-enabled fedora-cisco-openh264
    # sudo dnf config-manager --set-enabled google-chrome
    # sudo dnf config-manager --set-enabled rpmfusion-free
    # sudo dnf config-manager --set-enabled rpmfusion-nonfree

    sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$version.noarch.rpm -y
    sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$version.noarch.rpm -y
    sudo dnf install https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f43\&arch=x86_64 -y

    sudo dnf update -y
}

function unoficial_fedora(){
    # Repositorios não oficiais para Fedora
    sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-multimedia.repo
    sudo dnf config-manager --add-repo=https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
    sudo dnf config-manager --add-repo=https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    sudo dnf update -y
}

function oficial_arch(){
    # Repositorios oficiais para Arch Linux | EndeavourOS | Manjaro
    sudo sed -i 's/^#\[multilib\]/[multilib]/' /etc/pacman.conf
    sudo sed -i 's/^#Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/' /etc/pacman.conf
    grep -q "^\[core\]" /etc/pacman.conf || echo -e "[core]\nInclude = /etc/pacman.d/mirrorlist\n" | sudo tee -a /etc/pacman.conf >/dev/null
    grep -q "^\[extra\]" /etc/pacman.conf || echo -e "[extra]\nInclude = /etc/pacman.d/mirrorlist\n" | sudo tee -a /etc/pacman.conf >/dev/null

    sudo pacman -Sy --noconfirm
}

function unoficial_arch(){
    # Repositorios não oficiais para Arch Linux | EndeavourOS | Manjaro
    sudo pacman -S --noconfirm --needed git base-devel
    git clone https://aur.archlinux.org/paru-bin.git /tmp/paru-bin
    cd /tmp/paru-bin || exit
    makepkg -si --noconfirm
    cd - || exit
    rm -rf /tmp/paru-bin

    paru -S --noconfirm --needed yay chaotic-aur-bin

    sudo pacman -Sy
}

function oficial_opensuse() {
    # Repositorios oficiais para OpenSUSE
    sudo zypper addrepo -f https://download.opensuse.org/repositories/openSUSE:Factory/standard/openSUSE:Factory.repo
    sudo zypper refresh
}

function unoficial_opensuse() {
    # Repositorios não oficiais para OpenSUSE
    sudo zypper addrepo -f https://download.opensuse.org/repositories/home:manzoku/openSUSE_Tumbleweed/home:manzoku.repo
    sudo zypper refresh
}
