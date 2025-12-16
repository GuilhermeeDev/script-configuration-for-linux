#!/bin/bash
# shellcheck disable=SC1091    

# Função que orquestra o funcionamento inicial do script

./config/createFiles.sh
./config/findValues.sh

source ./config/functions.sh
install_dependencies
construct_json
create_file_content

# Chama o menu
./config/menu.sh