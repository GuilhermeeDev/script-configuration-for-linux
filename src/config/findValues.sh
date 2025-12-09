#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC2153
# shellcheck disable=SC2129
# shellcheck disable=SC2188
source /etc/os-release

get_pktmanager(){
    
    if command apt --version >/dev/null 2>&1; then
        echo "apt"
        echo "pktmanager=apt" >> ./config/.env
        
    elif command pacman --version >/dev/null 2>&1; then
        echo "pacman"
        echo "pktmanager=pacman" >> ./config/.env

    elif command brew --version >/dev/null 2>&1; then
        echo "brew"
        echo "pktmanager=brew" >> ./config/.env

    elif command apk --version >/dev/null 2>&1; then
        echo "apk"
        echo "pktmanager=apk" >> ./config/.env

    elif command dnf --version >/dev/null 2>&1; then
        echo "dnf"
        echo "pktmanager=dnf" >> ./config/.env

    else
        echo "gerenciador de pacotes não encontrado!"
    fi
}

# Obtendo valores de ambiente
pktmanager="$(get_pktmanager)"
distrocorrigida="${NAME// /}"

> ./config/.env

# Gravando valores no .env
{
    echo "user=$USER"
    echo "pktmanager=$pktmanager"
    echo "distro=$distrocorrigida"
    echo "id=$ID"
    echo "version=$VERSION_ID"
    echo "uploadrepository=github_repository"
} >> ./config/.env




