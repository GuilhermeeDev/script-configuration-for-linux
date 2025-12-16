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
# shellcheck disable=SC2155

source ./config/.env

export data="$(date +%d-%m-%y 2>/dev/null || echo "0-0-0")"
export hora="$(date +%H:%M 2>/dev/null || echo "00:01")"

# Obrigatorio instalar
function install_dependencies(){
  data=$(date +%d-%m-%Y)
  LOGFILE="./logs/[Instalacao-dependencias]-[$data]-[$hora].log"
  echo "Instalando dependências necessárias..."

  case "$id" in
    ubuntu|linuxmint|pop|debian)
      sudo apt update -y
      sudo apt install -y nano jq wget curl git-lfs
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    arch|endeavouros|manjaro)
      sudo pacman -Sy --noconfirm nano jq wget curl git-lfs
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    fedora)
      sudo dnf install -y nano jq wget curl git-lfs
      echo "Dependencias baixadas com sucesso!" | tee -a  "$LOGFILE"
    ;;
    
    opensuse* )
      sudo zypper refresh
      sudo zypper install -y nano jq wget curl git-lfs
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

function instalacao_guiada(){
  tipo=()

  clear

  echo "+ Pacotes basicos para uso do linux.";
  echo "- Esse pacote inclui ferramentas essenciais para o funcionamento do sistema.";
  echo "Como: Navegador, gerenciador de rede, ferramentas de compressão, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("basic")
  fi

  clear

  echo "+ Pacotes multimida para linux.";
  echo "- Esse pacote inclui players de video, audio, editores de imagem, etc.";
  echo "Como: Spotify, VLC, GIMP, Inkscape, ffmpeg, "; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("multimedia")
  fi

  clear

  echo "+ Pacotes para jogos no linux.";
  echo "- Esse pacote inclui plataformas de jogos, drivers e ferramentas para melhorar a performance.";
  echo "Como: Steam, Lutris, Heroic, Wine, ProtonUp, MangoHud, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("games")
  fi

  clear

  echo "+ Pacotes para desenvolvedores.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento de software\n\
  mas sem suporte para linguagem de programação específica!";
  echo "Como: Git, Curl, Wget, VSCode, Neovim, Docker, Kubernetes, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev")
  fi

  clear

  echo "+ Pacotes para redes sociais e comunicação.";
  echo "- Esse pacote inclui aplicativos de mensagens e redes sociais.";
  echo "Como: Discord, Telegram, Signal, Slack, Zoom, Skype, Teams, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("social")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Java.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Java.";
  echo "Como: OpenJDK, Maven, Gradle, Eclipse, IntelliJ, VSCode, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-java")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Python.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Python.";
  echo "Como: Python3, Pip, Virtualenv, Jupyter, Pylint, VSCode, PyCharm, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-python")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em JavaScript.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em JavaScript.";
  echo "Como: Node.js, NPM, Yarn, TypeScript, ESLint, Prettier, VSCode, WebStorm, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-javascript")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em C/C++.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em C/C++.";
  echo "Como: Build-Essential, CMake, GDB, Clang, VSCode, CLion, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-cpp")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Rust.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Rust.";
  echo "Como: Rustc, Cargo, Rust-Analyzer, VSCode, CLion, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-rust")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Go.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Go.";
  echo "Como: Golang, Go-Tools, VSCode, Gopls, Delve, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-go")
  fi  

  clear

  echo "+ Pacotes para desenvolvimento em PHP.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em PHP.";
  echo "Como: PHP, Composer, Laravel, VSCode, PhpStorm, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-php")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Ruby.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Ruby.";
  echo "Como: Ruby, Rails, Gem, VSCode, RubyMine, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-ruby")
  fi

  clear

  echo "+ Pacotes para desenvolvimento em Elixir.";
  echo "- Esse pacote inclui ferramentas e IDEs para desenvolvimento em Elixir.";
  echo "Como: Erlang, Elixir, Mix, VSCode, IntelliJ-Elixir, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("dev-elixir")
  fi

  clear

  echo "+ Pacotes para DevOps e Administração de Sistemas.";
  echo "- Esse pacote inclui ferramentas para DevOps e administração de sistemas.";
  echo "Como: Docker, Kubernetes, Ansible, Terraform, Nginx, Git, etc."; 
  echo "Deseja instalar esse pacote? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    tipo+=("devops")
  fi

  clear
  local i=1
  for pacote in "${tipo[@]}"; do
    sleep 1
    listar_pacotes "$pacote"

    echo "Progressão: ($i/${#tipo[@]})"
    echo "===================================================================="
    echo "Deseja adicionar um pacote não listado? (S/N)"; read op
    op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
    if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
      nano ./config/vars/$pacote-Packages.txt
    fi

    install_packages "$pacote"

    ((i++))
    clear
  done
  pause
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
  LOGFILE="./logs/[$data]-[$hora]-[$1]-Install.log"
  local id=$id

  total=$(grep -v '^\s*$' ./config/vars/$1-Packages.txt | wc -l)
  count=0

  case "$id" in
    ubuntu|linuxmint|pop|debian)
      echo "Sua distro é $id!" >> "$LOGFILE"
      metodo="sudo apt install -y"
      $metodo >> .env
    ;;
    
    arch|endeavouros|manjaro)
      echo "Sua distro é $id!" >> "$LOGFILE"
      metodo="sudo pacman -S --noconfirm"
      $metodo >> .env
    ;;
    
    fedora)
      echo "Sua distro é $id!" >> "$LOGFILE"
      metodo="sudo dnf install -y"
      $metodo >> .env
    ;;
    
    opensuse*)
      echo "Sua distro é $id!" >> "$LOGFILE"
      metodo="sudo zypper install -y"
      $metodo >> .env
    ;;
    
    *)
      echo "Distribuição '$id' não suportada ainda!" >> "$LOGFILE"
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

function create_file_content(){
  > ./config/vars/basic-Packages.txt
  {
    echo "build-essential"
    echo "linux-headers-generic"
    echo "mesa-vulkan-drivers"
    echo "net-tools"
    echo "network-manager"
    echo "neofetch"
    echo "firefox"
    echo "openssh-client"
    echo "lsd"
    echo "fzf"
    echo "tldr"
    echo "rar"
    echo "unrar"
    echo "zip"
    echo "unzip"
    echo "vim"
    echo "gimp"
    echo "libreoffice"
    echo "htop"
    echo "gnupg"
    echo "snapd"
  } >> ./config/vars/basic-Packages.txt

  > ./config/vars/dev-Packages.txt
  {
    echo "curl"
    echo "wget"
    echo "gnupg"
    echo "make"
    echo "cmake"
    echo "pkg-config"
    echo "gdb"
    echo "lldb"
    echo "valgrind"
    echo "podman"
    echo "kubectl"
    echo "virtualbox"
    echo "qemu-system"
    echo "neovim"
    echo "sqlite3"
    echo "redis-tools"
  } >> ./config/vars/dev-Packages.txt

  > ./config/vars/games-Packages.txt
  {
    echo "steam"
    echo "lutris"
    echo "heroic-games-launcher"
    echo "gamemode"
    echo "mesa-vulkan-drivers"
    echo "wine"
    echo "winetricks"
    echo "protonup-qt"
    echo "mangohud"
    echo "goverlay"
    echo "flatpak"
  } >> ./config/vars/games-Packages.txt

  > ./config/vars/multimedia-Packages.txt
  {
    echo "vlc"
    echo "ffmpeg"
    echo "gimp"
    echo "inkscape"
    echo "kdenlive"
    echo "audacity"
    echo "obs-studio"
    echo "shotwell"
    echo "imagemagick"
    echo "pinta"
    echo "blender"
    echo "cheese"
    echo "celluloid"
    echo "rhythmbox"
    echo "darktable"
    echo "krita"
    echo "simple-scan"
  } >> ./config/vars/multimedia-Packages.txt

  > ./config/vars/dev-java-Packages.txt
  {
    echo "default-jdk"
    echo "openjdk-17-jdk"
    echo "maven"
    echo "gradle"
    echo "eclipse-java"
    echo "intellij-idea-community"
    echo "junit"
    echo "visualvm"
  } >> ./config/vars/dev-java-Packages.txt

  > ./config/vars/dev-python-Packages.txt
  {
    echo "python3"
    echo "python3-pip"
    echo "python3-venv"
    echo "virtualenv"
    echo "pylint"
    echo "black"
    echo "mypy"
    echo "flake8"
    echo "jupyter-notebook"
    echo "pycharm-community"
  } >> ./config/vars/dev-python-Packages.txt

  > ./config/vars/dev-javascript-Packages.txt
  {
    echo "nodejs"
    echo "npm"
    echo "yarn"
    echo "nvm"
    echo "typescript"
    echo "eslint"
    echo "prettier"
    echo "nodemon"
    echo "webstorm"
  } >> ./config/vars/dev-javascript-Packages.txt


  > ./config/vars/dev-cpp-Packages.txt
  {
    echo "build-essential"
    echo "cmake"
    echo "gdb"
    echo "lldb"
    echo "valgrind"
    echo "clang"
    echo "clion"
  } >> ./config/vars/dev-cpp-Packages.txt

  > ./config/vars/dev-rust-Packages.txt
  {
    echo "rustc"
    echo "cargo"
    echo "rust-analyzer"
    echo "clion"
    echo "cargo"
    echo "rustfmt"
    echo "clippy"
  } >> ./config/vars/dev-rust-Packages.txt


  > ./config/vars/dev-go-Packages.txt
  {
    echo "golang"
    echo "go-tools"
    echo "gopls"
    echo "dlv"
    echo "air"
    echo "gin"
    echo "goland"
  } >> ./config/vars/dev-go-Packages.txt


  > ./config/vars/dev-php-Packages.txt
  {
    echo "php"
    echo "composer"
    echo "laravel"
    echo "symfony"
    echo "codeigniter"
    echo "phalcon"
    echo "phpstorm"
  } >> ./config/vars/dev-php-Packages.txt


  > ./config/vars/dev-ruby-Packages.txt
  {
    echo "ruby"
    echo "rails"
    echo "ruby-dev"
    echo "gem"
    echo "bundler"
    echo "rbenv"
    echo "rubymine"
    echo "sqlite3"
  } >> ./config/vars/dev-ruby-Packages.txt


  > ./config/vars/dev-elixir-Packages.txt
  {
    echo "erlang"
    echo "elixir"
    echo "mix"
    echo "hex"
    echo "phoenix"
    echo "intellij-elixir"
  } >> ./config/vars/dev-elixir-Packages.txt


  > ./config/vars/devops-Packages.txt
  {
    echo "docker.io"
    echo "docker-compose"
    echo "podman"
    echo "kubectl"
    echo "helm"
    echo "ansible"
    echo "terraform"
    echo "packer"
    echo "vagrant"
    echo "qemu-system"
    echo "virt-manager"
    echo "awscli"
    echo "azure-cli"
    echo "google-cloud-cli"
    echo "nginx"
    echo "apache2"
    echo "tmux"
    echo "git"
    echo "jq"
    echo "yq"
  } >> ./config/vars/devops-Packages.txt


  > ./config/vars/social-Packages.txt
  {
    echo "evolution"
  } >> ./config/vars/social-Packages.txt

  > ./config/vars/list-apps.txt
  {
    echo "Obsidian|https://github.com/obsidianmd/obsidian-releases/releases/download/v1.10.6/Obsidian-1.10.6.AppImage"
    echo "Visual-Code|https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  } >> ./config/vars/list-apps.txt
}

function pause() {
  read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
  echo
}