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
mkdir /home/docker && mkdir /home/docker/secrets
cd /home/docker
wget -O wghole.yaml https://github.com/Telxey/Docker/blob/main/stacks/wghole/wghole.yaml
wget -O secrets/db.env.sample  https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/db.env.sample
wget -O secrets/server.env.sample https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/server.env.sample
nano secrets/db.env.sample
nano secrets/server.env.sample
if [ ! -f ./secrets/db.env ]
then
  cp ./secrets/db.env.sample ./secrets/db.env
fi
if [ ! -f ./secrets/server.env ]
then
  cp ./secrets/server.env.sample ./secrets/server.env
fi
docker compose -f wghole.yaml up -d

msg_ok "Completed Successfully install nginix proxy manager!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:81${CL} \n"
msg_ok "Completed Successfully install pi-hole!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:5353/admin${CL} \n"  
msg_ok "Completed Successfully install wireguard-UI!\n"
echo -e "${APP} should be reachable by going to the following URL.
         ${BL}http://${IP}:51821${CL} \n"         

