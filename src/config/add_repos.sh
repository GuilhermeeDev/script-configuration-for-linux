#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154
source ./config/.env
source ./config/functions.sh
source ./repos/repos.sh

case "$id" in
    ubuntu|linuxmint|pop|debian)
        echo "Sua distro é $id!"
        echo "Adicionando repositorios..."
        repos_ubuntu
    ;;
    arch|endeavouros|manjaro)
        echo "Sua distro é $id!"
        echo "Adicionando repositorios..."
        repos_arch
    ;;
    fedora)
        echo "Sua distro é $id!"
        echo "Adicionando repositorios..."
        repos_fedora
    ;;
    opensuse* )
        echo "Sua distro é $id!"
        echo "Adicionando repositorios..."
        repos_opensuse
    ;;
    *)
    echo "Distribuição '$distro' não suportada ainda!"
    return 1
    ;;
esac

pause
./config/menu.sh