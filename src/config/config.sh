#!/bin/bash

./config/createFiles.sh
./config/findValues.sh

source ./config/functions.sh

install_dependencies
construct_json
create_file_packages

# Chama o menu
./config/menu.sh