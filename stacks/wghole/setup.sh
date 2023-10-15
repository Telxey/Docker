#!/usr/bin/ bash
# Copyright (c) 2021-2023 Telxey
# Author: Rax (telxey)
# License: MIT
# https://github.com//Telxey/Docker/raw/main/LICENSE

mkdir /home/docker && mkdir /home/docker/wghole
PATH='/home/docker/wghole'     
cd ${PATH}
# cd /home/docker/wghole
mkdir secrets
wget -O wghole.yaml https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/wghole.yaml
wget -O secrets/db_root_pwd.txt  https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/db_root_pwd.txt
wget -O secrets/mysql_pwd.txt https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/mysql_pwd.txt
wget -O secrets/pihole_pwd.txt  https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/pihole_pwd.txt
wget -O secrets/wg_easy_pwd.txt https://raw.githubusercontent.com/Telxey/Docker/main/stacks/wghole/secrets/wg_easy_pwd.txt
sleep 5
nano secrets/db_root_pwd.txt
nano secrets/mysql_pwd.txt
nano secrets/pihole_pwd.txt
nano secrets/wg_easy_pwd.txt

cp wghole.yaml docker-compose.yml

docker compose up -d

cat <<EOF
     Completed Successfully install nginix proxy manager
     should be reachable by going to the following URL.
         http://HOST_IP:81
         defaul-user = admin@example.com
         dfault password = changeme
EOF

---------------------------------------------------------------

cat <<EOF
     Completed Successfully install pi-hole
     should be reachable by going to the following URL.
         http://HOST_IP:5353/admin
        PI-HOLE Web UI Password below
EOF
         cat secrets/pihole_pwd.txt
         
-----------------------------------------------------------------

cat <<EOF
     Completed Successfully install wireguard-UI
     should be reachable by going to the following URL.
         http://HOST_IP:51821 
       Wireguard-UI Password below  
EOF
          cat secrets/wg_easy_pwd.txt
