#!/bin/bash
# shellcheck disable=SC1091
source ./config/functions.sh
clear

# ======================= PALETA OPCIONAL =======================
# Recomendo colocar isso no topo do menu ou no config de cores:
GREEN="\e[0;32m"
DARK_GREEN="\e[38;5;22m"
NEON="\e[1;32m"
LIGHT_GREEN="\e[92m"
CYAN="\e[36m"
WHITE="\e[97m"
YELLOW="\e[93m"
RESET="\e[0m"

# ======================= FUNÇÃO DO MENU =========================
menu() {
    clear
    echo -e "${DARK_GREEN}"
cat << "EOF"
 
███╗   ███╗ ███████╗ ███╗   ██╗ ██╗   ██╗
████╗ ████║ ██╔════╝ ████╗  ██║ ██║   ██║
██╔████╔██║ █████╗   ██╔██╗ ██║ ██║   ██║
██║╚██╔╝██║ ██╔══╝   ██║╚██╗██║ ██║   ██║
██║ ╚═╝ ██║ ███████╗ ██║ ╚████║ ╚██████╔╝
╚═╝     ╚═╝ ╚══════╝ ╚═╝  ╚═══╝  ╚═════╝ 

EOF
echo -e "${RESET}"

echo -e "${NEON}========================[ MENU PRINCIPAL ]========================${RESET}"
echo -e "${GREEN}Selecione uma das opções abaixo:${RESET}"
echo ""
echo -e "${LIGHT_GREEN}[1]${RESET} Instalação de pacotes guiada (Perguntas de Sim/Não)"
echo -e "${LIGHT_GREEN}[2]${RESET} Instalar pacotes básicos do sistema"
echo -e "${LIGHT_GREEN}[3]${RESET} Instalar pacotes para programadores"
echo -e "${LIGHT_GREEN}[4]${RESET} Instalar pacotes .appImages || .deb (Ubuntu-based)"
echo -e "${LIGHT_GREEN}[5]${RESET} Adicionar repositórios com base na distro"
echo -e "${LIGHT_GREEN}[6]${RESET} Sair"
echo ""

read -p "$(echo -e "${YELLOW}Digite sua opção: ${RESET}")" op

case "${op}" in
    1)
        instalacao_guiada
    ;;
    2)
        basic_packages

    ;;
    3)
        dev_packages
    ;;
    4)
        ./tools/install_appimages.sh
    ;;
    5)
        ./repos/menu_repos.sh
    ;;
    6|*)
        echo -e "${RED}Saindo...${RESET}"
        rm -rf "./config/vars"
        rm "./config/.env"

        clear
        exit 1
    ;;
esac
}

menu
