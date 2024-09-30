# PostgreSQL-HA over 3 Remote locations servers

Creating a highly available (HA) PostgreSQL cluster using logical replication across three nodes in three different data centers 
can be done with Docker and Docker Compose. Below, I'll provide a general overview of how to set this up followed by a samples docker-compose.yml configuration.
Each server will run its own PostgreSQL instance, and you'll use Docker to manage these instances.Here’s how you can structure the setup:

## High-Level Overview

   1. Remote Servers:
      - You'll have three servers, each running a PostgreSQL instance within a Docker container
   2. Network Configuration:
      - Ensure that each PostgreSQL instance can communicate with the others over the network. You may need to configure security groups, firewalls, or use a VPN to allow traffic between the servers.
   3. Cloudflare Zero Trust Tunnel:
      - If you're using Cloudflare Zero Trust, you'll need to set it up to securely expose your PostgreSQL instances to each other.
   4. ZeroTier Tunnel:
      - If you're using ZeroTier, you'll need to set it up to securely expose your PostgreSQL instances to each other read installation documetations.


## Sample Configuration for Each Server

   - Server 1
     - (docker-compose.yml)

    ---

    services:
      postgres_node1:
        image: postgres:16
        container_name: postgres_node1
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
          PGDATA: '/var/lib/postgresql/data/pgdata'
          POSTGRES_INITDB_ARGS: "--data-checksums"
        volumes:
          - pgdata_node1:/var/lib/postgresql/data
        ports:
          - "5432:5432"  # Expose port to the host
        restart: always

    volumes:
      pgdata_node1:

   
   - Server 2
     - (docker-compose.yml).

    ---

    services:
      postgres_node2:
        image: postgres:16
        container_name: postgres_node2
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
          PGDATA: '/var/lib/postgresql/data/pgdata'
        volumes:
          - pgdata_node2:/var/lib/postgresql/data
        ports:
          - "5432:5432"  # Expose port to the host
        restart: always

    volumes:
      pgdata_node2:

   - Server 3
     - (docker-compose.yml).

    
    ---

    services:
      postgres_node3:
        image: postgres:16
        container_name: postgres_node3
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
          PGDATA: '/var/lib/postgresql/data/pgdata'       
        volumes:
          - pgdata_node3:/var/lib/postgresql/data
        ports:
          - "5432:5432"  # Expose port to the host
        restart: always

    volumes:
      pgdata_node3:  


## Steps to Set Up PostgreSQL Cluster with Logical Replication

   1. Deploy PostgreSQL Instances:
      - On each of the three remote servers, create your respective docker-compose.yml file as shown above.
      - Run the following command on each server:
        
    docker-compose up -d
   
   2. Configure PostgreSQL for Logical Replication: After bringing up the PostgreSQL instances, you'll need to configure them for logical replication.
      - On Server 1 (Primary Node)
        - Connect to the PostgreSQL instance:

    docker exec -it postgres_node1 psql -U postgres

   * Now Update conf
      -  After login on postgres container
         -  Run the following commands:
         
<h5 align="center">   - Update $${\space \color{aqua} postgresql.conf}$$ for replicattion - </h5>
      
    ALTER SYSTEM SET max_connections TO 100;
    ALTER SYSTEM SET wal_level TO 'logical';
    ALTER SYSTEM SET max_wal_senders TO 3; 
    ALTER SYSTEM SET max_replication_slot TO 3;
    ALTER SYSTEM SET track_commit_timestamp TO on;
    SELECT pg_reload_conf();
<h5 align="left">  ( $${\space \color{red} WARNING\space}$$) 
   sometime commands not funtions correctly and need to navegate to container directory to edit $${\space \color{aqua} postgresql.conf}$$ fiile usin a text editor to manual edit configuration I use nano for this example  </h5>

    nano <pash_to_diirectory>/pgdata_node1/postgresql.conf
<p></p>
        - saving changes and restart container

     docker restart postgres_node1
<p></p> - to test if all change work run

    docker exec -it postgres_node1 psql -U postgres
 <p></p> - On log agai on postgres container run
 
    SHOW wal_level;
    SHOW max_wal_senders;
    SHOW max_replication_slots;
    SHOW max_connections;
    SHOW track_commit_timestamp;  
    
  <h5 align="center">  - Create a publication for the database - </h5>
        
    CREATE PUBLICATION mypublication FOR ALL TABLES;    
    
   * Edit pg_hba.conf: 
     - Allow the standby nodes to connect to the master for replication. Your pg_hba.conf should have lines like the following to permit replication connections: 
       - navegate to container directory to edit pg_hba.conf file usin a text editor to manul edit 
             
    nano <pash_to_diirectory>/pgdata_node1/postgresql.conf
<p></p> - copy and paste to end of file. and replace <nodes_ip_address> for respective IP ( remember remove Angle brackets )

    # Allow replication connections from the standby nodes  
    host    replication     all             <node2_ip_address>/32      md5 
    host    replication     all             <node3_ip_address>/32      md5   
   * Standby Nodes
      - On Server 2 and Server 3 (Standby Nodes)
        - Connect to the PostgreSQL instances on both servers:
       
    docker exec -it postgres_node2 psql -U postgres
<p></p>

    docker exec -it postgres_node3 psql -U postgres
<p></p>      
       - For each standby node, run:

<h5 align="center">   - Update $${\space \color{aqua} postgresql.conf}$$ for replicattion - </h5>

    ALTER SYSTEM SET max_connections TO 100;
    ALTER SYSTEM SET wal_level TO 'logical';
    ALTER SYSTEM SET max_wal_senders TO 3; 
    ALTER SYSTEM SET max_replication_slot TO 3;
    ALTER SYSTEM SET track_commit_timestamp TO on;
    SELECT pg_reload_conf();
<h5 align="left">  ( $${\space \color{red} WARNING\space}$$) If have problem using commands on terminal fallow instructions provide for node1 and repit for node2 & node3 </h5>
<p></p>
 <h5 align="center">  - Create a subscription to the primary node - </h5>

    CREATE SUBSCRIPTION mysubscription CONNECTION 'host=<NODE1_IP_ANDDRESS> port=5432 user=postgres password=yourpassword dbname=mydatabase' PUBLICATION mypublication;  

   Substitute <NODE1_IP_ANDDRESS> with the actual IP address of your node1.

* Now edit pg_hba.conf for node2 & node3: 
     - Allow the standby nodes to connect to the master for replication. Your pg_hba.conf should have lines like the following to permit replication connections: 
       - navegate to container directory to edit pg_hba.conf file usin a text editor to manul edit.
  - On node2
<p></p>

     nano <pash_to_diirectory>/pgdata_node2/postgresql.conf

<p></p> - copy and paste to end of file. and replace <nodes_ip_address> for respective IP ( remember remove Angle brackets )

    # Allow replication connections from the standby nodes  
    host    replication     all             <node1_ip_address>/32      md5 
    host    replication     all             <node3_ip_address>/32      md5   
 <p></p>
  - On node3
<p></p>

     nano <pash_to_diirectory>/pgdata_node3/postgresql.conf

<p></p> - copy and paste to end of file. and replace <nodes_ip_address> for respective IP ( remember remove Angle brackets )

    # Allow replication connections from the standby nodes  
    host    replication     all             <node1_ip_address>/32      md5 
    host    replication     all             <node2_ip_address>/32      md5

## Considerations for Network Configuration

   1. Firewall Rules:
      - Ensure that ports are open between the three servers for PostgreSQL to communicate. Specifically, you’ll need port 5432 open for each server.
   2. Cloudflare Zero Trust Tunnel:
      - If you're using a Cloudflare Tunnel, make sure that your PostgreSQL instances are configured according to the Cloudflare documentation for secure access over the tunnel.
   3. Test the Connections:
      - After setting everything up, make sure that the nodes can communicate. You can test SQL connectivity between the nodes.
   4. Monitoring and Maintenance:
      - Implement monitoring for replication lag and log any errors to ensure that your replication setup runs smoothly.

## Conclusion

This configuration guides you on how to set up PostgreSQL with logical replication across three remote servers using Docker Compose. Make sure to adjust any configurations and considerations based on your infrastructure requirements. If you have any further questions or need clarification on specific points, feel free to read official documentation!
https://dzone.com








      




