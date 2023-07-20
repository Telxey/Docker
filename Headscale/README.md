##  Instructions to Running headscale in a container ¶

### Goal

This documentation has the goal of showing a user how-to set up and run headscale in a container. Docker is used as the reference container implementation, but there is no reason that it should not work with alternatives like Podman. The Docker image can be found on Docker Hub here.

### NOTE
For this examle I use UBUNTU Server 22.04 LTS but work onall Linux distro asume have have ubuntu user if not you can set ubuntu directory on home folder

    sudo mkdir /home/ubuntu
    sudo mkdir /home/ubuntu/docker
    cd /home/ubuntu/docker
### Configure and run headscale


1- Prepare a directory on the host Docker node in your directory of choice, used to hold headscale configuration and the SQLite database:

      mkdir -p ./headscale/config
      cd ./headscale

 2-Create an empty SQlite datebase in the headscale directory:

      touch ./config/db.sqlite

 Using wget:

    wget -O ./config/config.yaml https://raw.githubusercontent.com/juanfont/headscale/main/config-example.yaml

Using curl:

    curl https://raw.githubusercontent.com/juanfont/headscale/main/config-example.yaml -o ./config/config.yaml
(Advanced) If you would like to hand craft a config file instead of downloading the example config file, create a blank headscale configuration in the headscale directory to edit:

     touch ./config/config.yaml

Modify the config file to your preferences before launching Docker container. Here are some settings that you likely want:

    # Change to your hostname or host IP
    server_url: http://your-host-name:8080
    # Listen to 0.0.0.0 so it's accessible outside the container
    metrics_listen_addr: 0.0.0.0:9090
    # The default /var/lib/headscale path is not writable in the container
    private_key_path: /etc/headscale/private.key
    # The default /var/lib/headscale path is not writable in the container
    noise:
    private_key_path: /etc/headscale/noise_private.key
    # The default /var/lib/headscale path is not writable  in the container
    db_type: sqlite3
    db_path: /etc/headscale/db.sqlite
