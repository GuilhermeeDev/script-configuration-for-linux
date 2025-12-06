#! /bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC2153
source /etc/os-release

get_pktmanager(){
    echo "# Variavel de ambiente temporaria" >> .env

    if command apt --version >/dev/null 2>&1; then
        echo "apt"
        echo "pktmanager=apt" >> .env
        
    elif command pacman --version >/dev/null 2>&1; then
        echo "pacman"
        echo "pktmanager=pacman" >> .env

    elif command brew --version >/dev/null 2>&1; then
        echo "brew"
        echo "pktmanager=brew" >> .env

    elif command apk --version >/dev/null 2>&1; then
        echo "apk"
        echo "pktmanager=apk" >> .env

    elif command dnf --version >/dev/null 2>&1; then
        echo "dnf"
        echo "pktmanager=dnf" >> .env

    else
        echo "gerenciador de pacotes não encontrado!"
    fi
}

values=(user pktmanager distro distroId)

user=$USER
pktmanager="$(get_pktmanager)"
distro=$NAME
id=$ID

values[0]=$user, values[1]=$pktmanager, values[2]=$distro, values[3]=$id

echo -e "[log] Valores de ambiente:\nUser:${values[0]}\nGerenciador_pacotes:${values[1]}\nDistro:${values[2]}\nId_distro:${values[3]}"

echo "user=$user" >> .env

distrocorrigida="${distro// /}"
echo "distro=$distrocorrigida" >> .env
echo "id=$id" >> .env

#Versao no .json


