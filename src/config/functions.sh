#!/bin/bash

# Funções de configuração da aplicação
# Funções de uso recursivo

# shellcheck disable=SC2154
# shellcheck disable=SC2034
# shellcheck disable=SC1091
# shellcheck disable=SC2188
# shellcheck disable=SC2126
# shellcheck disable=SC2086
# shellcheck disable=SC2188


source ./config/.env

# Obrigatorio instalar
function install_dependencies(){
  data=$(date +%d-%m-%Y)
  LOGFILE="./logs/[$data]-dependencies-install.log"
  echo "Instalando dependências necessárias..."
  sleep 1

  case "$id" in
    ubuntu|linuxmint|pop|debian)
      sudo apt update -y
      sudo apt install -y nano jq git wget curl
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    arch|endeavouros|manjaro)
      sudo pacman -Sy --noconfirm nano jq git wget curl
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    fedora)
      sudo dnf install -y nano jq git wget curl
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    opensuse* )
      sudo zypper refresh
      sudo zypper install -y nano jq git wget curl
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    *)
      echo -e "Error: Gerenciador de pacotes não encontrado ou distro não suportada!\n\
      ID detectado: $id" | tee -a "$LOGFILE"
      pause
      clear
      exit 1
    ;;
  esac
  echo " "
  pause
}

function construct_json(){
  jq -n \
  --arg user "$user" \
  --arg packageManager "$pktmanager" \
  --arg distro "$distro" \
  --arg id "$id" \
  --arg version "$version" \
  '{"user":$user, "packageManager":$packageManager, "distro":$distro, "distro_id":$id, "version":$version}' > ./config/vars/config.json
}

function is_installed() {
  case "$pktmanager" in
    apt)
        dpkg -s "$1" >/dev/null 2>&1
        ;;
    pacman)
        pacman -Qi "$1" >/dev/null 2>&1
        ;;
    dnf)
        dnf list installed "$1" >/dev/null 2>&1
        ;;
    zypper)
        zypper se -i "$1" | grep -q "^i "
        ;;
  esac
}

function listar_pacotes() {
  tipo="$1"
  data=$(date +%d-%m-%Y)
  arquivo="./config/vars/$tipo-Packages.txt"
  LOGFILE="./logs/[$data]-[$tipo]-listagem-pacotes.log"

  # verifica se o arquivo existe
  if [ ! -f "$arquivo" ]; then
    echo "ERRO: Arquivo '$arquivo' não encontrado!" | tee -a "$LOGFILE"
    return 1
  fi

  echo "# Pacotes que serão instalados!" | tee -a "$LOGFILE"
  
  # Carrega pacotes válidos (sem comentários e sem linhas vazias)
  mapfile -t pacotes < <(grep -v '^\s*#' "$arquivo" | sed '/^\s*$/d')

  total=${#pacotes[@]}
  i=0
  num=1

  # Imprime 2 por linha
  while [ $i -lt $total ]; do
    p1="${pacotes[$i]}"
    p2="${pacotes[$((i+1))]}"

    if [ -n "$p2" ]; then
        printf '%-35s %s\n' \
          "$num. $p1" \
          "$((num+1)). $p2" | tee -a "$LOGFILE"
    else
        # última linha se o total for ímpar
        printf '%s\n' "$num. $p1"
    fi

    num=$((num+2))
    i=$((i+2))
  done
}

function basic_packages(){
  tipo="basic"

  listar_pacotes "$tipo"

  echo "Deseja adicionar um pacote não listado? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    nano ./config/vars/$tipo-Packages.txt
  fi

  install_packages "$tipo"

  ./config/menu.sh
}

function dev_packages(){
  tipo="dev"

  listar_pacotes $tipo

  echo "Deseja adicionar um pacote não listado? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    nano ./config/vars/$tipo-Packages.txt
  fi

  install_packages "$tipo"

  ./config/menu.sh
}

function install_packages(){
  data=$(date +%d-%m-%Y)
  LOGFILE="./logs/[$data]-[$1]-Install.log"
  local id=$id

  total=$(grep -v '^\s*$' ./config/vars/$1-Packages.txt | wc -l)
  count=0

  case "$id" in
    ubuntu|linuxmint|pop|debian)
      echo "Sua distro é $id!" | tee -a "$LOGFILE"
      metodo="sudo apt install -y"
    ;;
    
    arch|endeavouros|manjaro)
      echo "Sua distro é $id!" | tee -a "$LOGFILE"
      metodo="sudo pacman -S --noconfirm"
    ;;
    
    fedora)
      echo "Sua distro é $id!" | tee -a "$LOGFILE"
      metodo="sudo dnf install -y"
    ;;
    
    opensuse*)
      echo "Sua distro é $id!" | tee -a "$LOGFILE"
      metodo="sudo zypper install -y"
    ;;
    
    *)
      echo "Distribuição '$id' não suportada ainda!" | tee -a "$LOGFILE"
      return 1
    ;;
  esac


  while IFS= read -r package; do
    [ -z "$package" ] && continue 

    if is_installed "$package"; then
      echo "--> $package já instalado." | tee -a "$LOGFILE"
      count=$((count+1))
      percent=$(( 100 * count / total ))
      printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count" "$total"
      continue
    fi

    echo "--> Instalando $package..." | tee -a "$LOGFILE"

    $metodo "$package" >> "$LOGFILE" 2>&1

    count=$((count+1))
    percent=$(( 100 * count / total ))
    printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count" "$total"
  done < ./config/vars/$1-Packages.txt

  echo -e "\nInstalação concluída!"

  pause
}

function create_file_packages(){
  # Criando arquivos com pacotes basicos para linux.
  > ./config/vars/basic-Packages.txt
  {
  echo "# Lista de pacotes basicos para linux."
  echo "build-essential"
  echo "linux-headers-generic"
  echo "mesa-vulkan-drivers"
  echo "net-tools"
  echo "network-manager"
  echo "flatpack"
  echo "wget"
  echo "xorg"
  echo "curl"
  echo "zip"
  echo "unzip"
  echo "htop"
  echo "neofetch"
  echo "vim"
  echo "ufw"
  echo "rar"
  echo "unrar"
  echo "tar"
  echo "firefox"
  echo "openssh-client"
  echo "vlc"
  echo "ffmpeg"
  echo "libreoffice"
  echo "okular"
  echo "evince"
  echo "gimp"
  echo "steam"
  echo "clamav"
  echo "gnupg"
  echo "lsd"
  echo "fzf"
  echo "tldr"
  } >> ./config/vars/basic-Packages.txt
  # < ./config/vars/basicPackages.txt
  # Criando arquivo com pacotes de desenvolvedor para linux.

  > ./config/vars/dev-Packages.txt
  {
  echo "cmake"
  echo "pkg-config"
  echo "gdb"
  echo "lldb"
  echo "valgrind"
  echo "python3"
  echo "python3-pip"
  echo "python3-venv"
  echo "jupyter-notebook"
  echo "nodejs"
  echo "npm"
  echo "yarn"
  echo "pnpm"
  echo "default-jdk"
  echo "maven"
  echo "gradle"
  echo "postgresql"
  echo "sqlite3"
  echo "mysql-client"
  echo "redis"
  echo "redis-tools"
  echo "docker.io"
  echo "docker-compose"
  echo "podman"
  echo "kubectl"
  echo "virtualbox"
  echo "qemu-system"
  echo "dotnet-sdk-8.0"
  echo "golang-go"
  echo "rustc"
  echo "cargo"
  echo "php"
  echo "php-cli"
  echo "composer"
  echo "ruby"
  echo "ruby-dev"
  echo "gem"
  echo "httpie"
  echo "nmap"
  echo "ansible"
  echo "erlang"
  echo "elixir"
  } >> ./config/vars/dev-Packages.txt
}

function safe_delete() {
  [[ -z "$1" ]] && { echo "ERRO: Caminho vazio para delete"; return 1; }
  [[ "$1" == "/" ]] && { echo "ERRO: PERIGO: não vou deletar /"; return 1; }
  rm -rf "$1" >/dev/null 2>&1
}

function pause() {
  read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
  echo
}