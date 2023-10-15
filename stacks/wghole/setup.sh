#!/usr/bin/env bash
# Copyright (c) 2021-2023 Telxey
# Author: Rax (telxey)
# License: MIT
# https://github.com//Telxey/Docker/raw/main/LICENSE
function header_info {
clear
cat <<"EOF"
__      __ ___            _  _     ___     _       ___   
\ \    / // __|    ___   | || |   / _ \   | |     | __|  
 \ \/\/ /| (_ |   |___|  | __ |  | (_) |  | |__   | _|   
  \_/\_/  \___|   _____  |_||_|   \___/   |____|  |___|  
_|"""""|_|"""""|_|     |_|"""""|_|"""""|_|"""""|_|"""""| 
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'                          
 
EOF
}
mkdir /home/docker
cd /home/docker
https://github.com/Telxey/Docker/.git
nano  wghole.yaml
docker compose -f wghole.yaml up -d

