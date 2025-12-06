#!/bin/bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154
source .env

function install_all_dependencies(){

    echo "Deseja instalar todas as dependências necessárias para rodar o programa? (S/N)"; read op

    op=$(echo "$op" | tr '[:upper:]' '[:lower:]')

    if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
        $pktmanager install curl jq
        echo "Dependencias instaladas!"
    else
        echo -e "O programa rodará de maneira limitada!\nPara ter acesso a todas as funções, instale as dependências do programa."
    fi
}

function install_jq(){
    if ! command jq --version >/dev/null 2>&1; then
        echo "Pacote 'jq' não encontrado, deseja instala-lo?(S/N)"; read op
        
        op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
        if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
            $pktmanager install jq
            echo -e "jq instalado com sucesso!\nFuncionalidade de construir o config.json habilitada!"
        else
            echo -e "jq não sera instalado!\nFunção de construir o config.json desabilitada!"
        fi

    else
        echo -e "jq já está instalado — função de construir o config.json habilitada."
    fi
}

#Construindo o obj config.json, mas somentes após a instalação do "jq"
function construct_json_obj(){
    echo "[log] Construindo cabeçalho .json do programa..."

    jq -n \
    --arg user "$user" \
    --arg packageManager "$pktmanager" \
    --arg distro "$distro" \
    --arg id "$id" \
    '{ "user":$user, "packageManager":$packageManager, "distro":$distro, "distro_id":$id }' > config.json

    echo "[log] Cabeçalho .json construido!"

}

construct_json_obj


