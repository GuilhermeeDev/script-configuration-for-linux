#!/bin/bash
# shellcheck disable=SC1091
source ./config/functions.sh
clear

echo "=========================== MENU ==========================="
echo -e "1. Instalar pacotes basicos para uso do linux.\n\
2. Instalar pacotes de desenvolvedor para linux.\n\
3. Adicionar repositorios com base na distro.\n\
4. Instalar 'beautifulLinux'(beta)\n\
5. Sair. "; read op

case "${op}" in
    1)
        echo "=========================== Install BasicPackages ==========================="
        basic_packages
    ;;
    2)
        echo "=========================== Install DevPackages ==========================="
        dev_packages
    ;;
    3)
        echo "=========================== Install Repositories ==========================="
        ./config/add_repos.sh
    ;;
    *)
        clear
        exit 1
    ;;
esac
