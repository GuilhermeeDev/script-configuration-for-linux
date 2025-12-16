#!/bin/bash
# shellcheck disable=SC2155
# shellcheck disable=SC2091
# shellcheck disable=SC1091

source ./config/.env

export DESKTOP_DIR="$HOME/.local/share/applications"
export DOWNLOADS_DIR="$HOME/Downloads_AS"
export DATA="$(date +%d-%m-%y 2>/dev/null || echo "0-0-0")"
export HORA="$(date +%H:%M 2>/dev/null || echo "00:01")"
export LOGFILE="./logs/[AppImages-Install]-[$DATA]-[$HORA].log"

function pause() {
  read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
  echo
}

function dir_appimage_installed() {
    # Verifica se a pasta correspondente ao AppImage existe.
    local app_name=$1
    local dir="$DOWNLOADS_DIR/$app_name"

    if [ -d "$dir" ]; then
        if $(find "$dir" -maxdepth 1 -iname "*$app_name*" -printf "%f\n" | head -n 1); then
            return 1 # ja instalado
        else
            return 0   # não instalado
        fi
    else
        return 0   # não instalado
    fi
}

function get_basename(){
    app_name=$1
    dir=$2
    nome=$(find "$dir" -maxdepth 1 -iname "*$app_name*" -printf "%f\n" | head -n 1)
    echo "$nome"
}

function list_appimages(){
    echo "===================== Apps ====================="
    echo "1. Obsidian"
    echo "2. Virtual Studio Code"
    echo " "
    pause
}


function app_installer() {
    local list_file="./config/vars/list-apps.txt"

    list_appimages

    local total
    total=$(grep -vcE '^\s*($|#)' "$list_file")

    local count=0

    while IFS='|' read -r app_name app_url; do
        # Ignora linhas vazias ou comentadas
        [[ -z "$app_name" || "$app_name" =~ ^# ]] && continue

        if dir_appimage_installed "$app_name"; then
            echo "--> $app_name já instalado." >> "$LOGFILE"
            count=$((count+1)) 
            percent=$(( 100 * count / total )) 
            # shellcheck disable=SC2183
            printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count"
            continue
        fi

        echo "--> Instalando $app_name ..." | tee -a "$LOGFILE"
        local DIR="$DOWNLOADS_DIR/$app_name"
        mkdir -p "$DIR"

        local file_name
        file_name="$(basename "$app_url")"

        if ! curl -fL "$app_url" -o "$DIR/$file_name" >> "$LOGFILE" 2>&1; then
            echo "Erro ao baixar $app_name" | tee -a "$LOGFILE"
            continue
        else
            case "$file_name" in
                *.AppImage) 
                    echo "arquivo com extensão .AppImage" | tee -a "$LOGFILE"
                    sudo chmod +x "$DIR/$file_name"
                ;;  
                *.deb)
                    echo "arquivo com extensão .deb" | tee -a "$LOGFILE"
                    sudo dpkg -i "$DIR/$file_name"
                ;;
                *)
                    echo "Extensão de arquivo não suportada." | tee -a "$LOGFILE"
                ;;
            esac
        fi

        count=$((count+1)) 
        percent=$(( 100 * count / total ))
        printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count" "$total"
    done < "$list_file"

    echo -e "\nProcesso de instalação de AppImages finalizado!" | tee -a "$LOGFILE"
}

function main(){
    mkdir -p "$DOWNLOADS_DIR"
    app_installer
    pause
    ./config/menu.sh
}

