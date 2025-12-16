#!/bin/bash

clear
# shellcheck disable=SC1091
source ./repos/functions.sh

# shellcheck disable=SC1091
source ./config/.env

CYAN="\e[36m"
YELLOW="\e[1;33m"
RESET="\e[0m"

echo -e "========================[ Repositórios ]========================"

# shellcheck disable=SC2154
echo -e "Sua ditro é: ${CYAN}$distro${RESET}"
echo ""
echo -e "[1] Instalar repositórios oficiais"
echo -e "[2] Instalar repositórios não oficiais [instavel!]"
echo -e "[3] Instalar repositórios oficiais e não oficiais [instavel!]"
echo -e "[4] Voltar ao menu anterior"
echo ""

read -p "$(echo -e "${YELLOW}Digite sua opção: ${RESET}")" op
case "${op}" in
    1)
        install_repos_oficiais
    ;;
    2)
        install_repos_unoficiais
    ;;
    3)
        install_repos_oficiais
        install_repos_nao_oficiais
    ;;
    *)
        clear
        ./config/menu.sh
    ;;
esac

./config/menu.sh