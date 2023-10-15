#!/usr/bin/env bash
# Copyright (c) 2021-2023 Telxey
# Author: Rax (telxey)
# License: MIT
# https://github.com//Telxey/Docker/raw/main/LICENSE
function header_info {
cat <<"EOF"
__      __ ___            _  _     ___     _       ___   
\ \    / // __|    ___   | || |   / _ \   | |     | __|  
 \ \/\/ /| (_ |   |___|  | __ |  | (_) |  | |__   | _|   
  \_/\_/  \___|   _____  |_||_|   \___/   |____|  |___|  
_|"""""|_|"""""|_|     |_|"""""|_|"""""|_|"""""|_|"""""| 
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'                          
 
EOF
}
sleep 5
mkdir /home/docker && mkdir /home/docker/secrets /
sleep 10 /

cd /home/docker /
wget -O wghole.yaml https://github.com/Telxey/Docker/blob/main/stacks/wghole/wghole.yaml
sleep 5
wget -O secrets/db.env.sample  https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/db.env.sample
wget -O secrets/server.env.sample https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/server.env.sample
sleep 5
nano secrets/db.env.sample
nano secrets/server.env.sample
if [ ! -f ./secrets/db.env ]
then
  cp ./secrets/db.env.sample ./secrets/db.env
fi
sleep 5
if [ ! -f ./secrets/server.env ]
then
  cp ./secrets/server.env.sample ./secrets/server.env
fi
cp wghole.yaml docker-compose.yml

docker compose up -d

cat <<EOF
     Completed Successfully install nginix proxy manager
     should be reachable by going to the following URL.
         http://HOST_IP:81
         defaul-user = admin@example.com
         dfault password = changeme
         
     Completed Successfully install pi-hole
     should be reachable by going to the following URL.
         http://HOST_IP:5353/admin
         
     Completed Successfully install wireguard-UI
     should be reachable by going to the following URL.
         http://HOST_IP:51821        
EOF
