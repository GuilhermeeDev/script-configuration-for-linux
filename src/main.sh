#!/bin/bash

for f in ./config/*.sh; do
    chmod +x "$f"
done

echo "================================================================================"
echo "  Ola, bem vindo ao meu script de configuração para distros baseadas em Linux!  "
echo "================================================================================"
echo "Para contribuit com esse projeto acesse: https://github.com/GuilhermeeDev/script-configuration-for-linux.git"
echo 
read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
echo
./config/config.sh