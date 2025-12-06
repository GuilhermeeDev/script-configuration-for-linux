#!/bin/bash
# shellcheck disable=SC1091
source ./config/functions.sh

echo "=========================== MENU ==========================="

echo -e "1. Instalar pacotes basicos para uso do linux.\n2. Instalar pacotes de desenvolvedor para linux.\n3. Instalar 'beautifulLinux'(beta)\n4. Pacotes [.appImage;.deb;]\n5. Sair. "; read op
export op

case "${op}" in
    1)
        echo "=========================== BasicPackages ==========================="
        install_basicPackages
    ;;
    2)
        echo "=========================== DevPackages ==========================="
        install_devPackages
    ;;
    3)
        echo "item 3"
    ;;
    4)
        install_packages_lfs

    ;;
    5)
        echo "Saindo.."
        exit

    ;;
    *)
        echo "Saindo.."
        exit
    ;;
esac
