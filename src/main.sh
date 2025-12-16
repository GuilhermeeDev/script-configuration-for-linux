#!/bin/bash

# Metodo de precaução para garantir que todos os scripts tenham permissão de execução.
for f in ./config/*.sh; do
    chmod +x "$f"
done

for f in ./repos/*.sh; do
    chmod +x "$f"
done

for f in ./tools/*.sh; do
    chmod +x "$f"
done

# ────────────────────────────────────────────────
# CORES
# ────────────────────────────────────────────────
GREEN="\e[0;32m"
YELLOW="\e[1;33m"
RESET="\e[0m"
DARK_GREEN="\e[38;5;29m"
PASTEL_GREEN="\e[38;5;121m"
CYAN="\e[36m"
NEON_GREEN="\e[92m"
clear
prompt="${YELLOW}Pressione qualquer tecla para continuar...${RESET}"
# Animação de digitação
function type_text() {
    text="$1"
    delay="${2:-0.005}"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${text:$i:1}"
        sleep "$delay"
    done
}

function loading_bar() {
    bar=""
    for i in {1..30}; do
        bar="#$bar"
        echo -ne "${GREEN}[${bar}$(printf '%*s' $((30-${#bar})) '')]${RESET}\r"
        sleep 0.04
    done
    echo ""
}

function ascii_linux_as() {
echo -e "${DARK_GREEN}"
cat << "EOF"
██╗      ██╗ ███╗   ██╗  ██╗   ██╗ ██╗  ██╗    █████╗ ███████╗
██║      ██║ ████╗  ██║  ██║   ██║ ╚██╗██╔╝   ██╔══██╗██╔════╝
██║      ██║ ██╔██╗ ██║  ██║   ██║  ╚███╔╝    ███████║███████╗
██║      ██║ ██║╚██╗██║  ██║   ██║  ██╔██╗    ██╔══██║╚════██║
███████╗ ██║ ██║ ╚████║  ╚██████╔╝ ██╔╝ ██╗   ██║  ██║███████║
╚══════╝ ╚═╝ ╚═╝  ╚═══╝   ╚═════╝  ╚═╝  ╚═╝   ╚═╝  ╚═╝╚══════╝
EOF
echo -e "${RESET}"
}

# TELA INICIAL
echo ""
type_text "Iniciando o Linux Auto-Setup..." 0.04
echo -e "${RESET}"
sleep 0.5

loading_bar
sleep 0.3
clear

ascii_linux_as

echo -e "${PASTEL_GREEN}──────────────────────────────────────────────────────────────────────────────${RESET}"
echo ""
echo -e "${GREEN}Para contribuir com esse projeto acesse:${RESET}"
echo -e "${CYAN}https://github.com/GuilhermeeDev/script-Linux-auto-setup${RESET}"
echo ""

echo -e "${GREEN}Dúvidas, sugestões ou erros? Abra uma issue no GitHub.${RESET}"
echo -e "${GREEN}Para cancelar um processo em execução utilize:${RESET} ${NEON_GREEN}[ CTRL + C ]${RESET}"
echo ""

echo -e "${PASTEL_GREEN}──────────────────────────────────────────────────────────────────────────────${RESET}"

read -n 1 -s -r -p "$(echo -e "$prompt")"

./config/config.sh