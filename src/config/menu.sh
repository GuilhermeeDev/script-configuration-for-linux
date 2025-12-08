#!/bin/bash
# shellcheck disable=SC1091
source ./config/functions.sh
clear

echo "=========================== MENU ==========================="
echo -e "1. Instalar pacotes basicos para uso do linux.\n\
2. Instalar pacotes de desenvolvedor para linux.\n\
3. Instalar 'beautifulLinux'(beta)\n\
4. Instalar pacotes |.appImage | .deb |\n\
5. Sair. "; read op

case "${op}" in
    1)
        echo "=========================== Install BasicPackages ==========================="
        install_basic_packages
    ;;
    2)
        echo "=========================== Install DevPackages ==========================="
        install_dev_packages
    ;;
    *)
        exit
    ;;
esac
