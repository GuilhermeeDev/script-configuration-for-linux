#!/bin/bash
# shellcheck disable=SC2154
# shellcheck disable=SC2034
# shellcheck disable=SC1091
# shellcheck disable=SC2188
source ./config/.env

# Obrigatorio instalar
function install_dependencies(){
  $pktmanager install nano jq git git-lfs curl 
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

is_installed() {
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

function install_basic_packages(){
  data=$(date +%d-%m-%Y)
  LOGFILE="./logs/[$data]-basic-Install.log"


  # shellcheck disable=SC2126
  total=$(grep -v '^\s*$' ./config/vars/basicPackages.txt | wc -l)
  count=0

  #lista pacotes
  echo "# Pacotes que serão instalados!"
  echo "1. build-essential      2. linux-headers-generic"
  echo "3. mesa-vulkan-drivers  4. net-tools"
  echo "5. network-manager      6. flatpack"
  echo "7. wget                 8. xorg"
  echo "9. curl                 10. zip"
  echo "11. unzip               12. htop"
  echo "13. neofetch            14. vim"
  echo "15. ufw                 16. rar"
  echo "17. unrar               18. tar"
  echo "19. firefox             20. openssh-client"
  echo "21. vlc                 22. ffmpeg"
  echo "23. libreoffice         24. okular"
  echo "25. evince              26. gimp"
  echo "27. steam               28. clamav"
  echo "29. gnupg               30. lsd"
  echo "31. fzf                 32. tldr"
  echo
  echo "Deseja adicionar um pacote não listado? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    nano ./config/vars/basicPackages.txt
  fi

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

    $pktmanager install -y "$package" >> "$LOGFILE" 2>&1

    count=$((count+1))
    percent=$(( 100 * count / total ))
    printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count" "$total"
  done < ./config/vars/basicPackages.txt
  echo -e "\nInstalação concluída!"
  ./config/menu.sh
}

function install_dev_packages(){
  data=$(date +%d-%m-%Y)
  LOGFILE="./logs/[$data]-dev-install.log"

  # shellcheck disable=SC2126
  total=$(grep -v '^\s*$' ./config/vars/devPackages.txt | wc -l)
  count=0

  #lista pacotes
  echo "# Pacotes que serão instalados!"
  echo "1. cmake                 2. pkg-config"
  echo "3. gdb                   4. lldb"
  echo "5. valgrind              6. python3"
  echo "7. python3-pip           8. python3-venv"
  echo "9. jupyter-notebook      10. nodejs"
  echo "11. npm                  12. yarn"
  echo "13. pnpm                 14. default-jdk"
  echo "15. maven                16. gradle"
  echo "17. postgresql           18. sqlite3"
  echo "19. mysql-client         20. redis"
  echo "21. redis-tools          22. docker.io"
  echo "23. docker-compose       24. podman"
  echo "25. kubectl              26. virtualbox"
  echo "27. qemu-system          28. dotnet-sdk-8.0"
  echo "29. golang-go            30. rustc"
  echo "31. cargo                32. php"
  echo "33. php-cli              34. composer"
  echo "35. ruby                 36. ruby-dev"
  echo "37. gem                  38. httpie"
  echo "39. nmap                 40. ansible"
  echo "41. terraform            42. awscli"
  echo "43. azure-cli            44. google-cloud-cli"
  echo
  echo "Deseja adicionar um pacote não listado? (S/N)"; read op
  op=$(echo "$op" | tr '[:upper:]' '[:lower:]')
  if [ "$op" = "s" ] || [ "$op" = "sim" ]; then
    nano ./config/vars/devPackages.txt
  fi

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

    $pktmanager install -y "$package" >> "$LOGFILE" 2>&1

    count=$((count+1))
    percent=$(( 100 * count / total ))
    printf "\rProgresso: %d%% (%d/%d)" "$percent" "$count" "$total"
  done < ./config/vars/devPackages.txt
  echo -e "\nInstalação concluída!"
  ./config/menu.sh
}

function create_file_packages(){
  # shellcheck disable=SC2188

  # Criando arquivos com pacotes basicos para linux.
  > ./config/vars/basicPackages.txt
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
  } >> ./config/vars/basicPackages.txt
  # < ./config/vars/basicPackages.txt
  # Criando arquivo com pacotes de desenvolvedor para linux.

  > ./config/vars/devPackages.txt
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
  echo "terraform"
  echo "awscli"
  echo "azure-cli"
  echo "google-cloud-cli"
  echo "snapd"
  } >> ./config/vars/devPackages.txt
}

# function install_packages_lfs(){
#   #Monta um .zip com os arquivos .deb | .appImage | selecionados ou um pacotão ja pre montado.
#   echo " "
# }

function safe_delete() {
  [[ -z "$1" ]] && { echo "ERRO: Caminho vazio para delete"; return 1; }
  [[ "$1" == "/" ]] && { echo "ERRO: PERIGO: não vou deletar /"; return 1; }
  rm -rf "$1" >/dev/null 2>&1
}