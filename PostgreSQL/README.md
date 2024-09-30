# PostgreSQL cluster 3 nodes same server

  Creating a highly available (HA) PostgreSQL cluster using logical replication across three nodes in three different 
  data centers can be done with Docker and Docker Compose. Below, I'll provide a general overview of how to set this up 
  followed by a sample docker-compose.yml configuration.

 ##  Overview of PostgreSQL HA with Logical Replication

  1.  Master and Standby Nodes: In a typical HA setup, you have one primary (master) node and multiple standby nodes. For logical replication, you can have multiple replicas reading from the primary node.

  2.  Containers: Each PostgreSQL instance will be located in a different Docker container. For this example, you'll need to configure the instances to be aware of each other's addresses.

  3.  Docker Setup: Using Docker to encapsulate each PostgreSQL instance will help manage dependencies and configurations more effectively.

  3.  Network Configuration: Ensure that the network configurations allow communication between these nodes.

##  Prerequisites

   - Install Docker and Docker Compose on your server.

   - Ensure that the PostgreSQL Docker image you use supports logical replication (e.g., the official PostgreSQL image).

### Sample  docker-compose.yml

   -  Here is an example configuration for setting up PostgreSQL with logical replication across three nodes:


    version: '3.8'

    services:
      postgres_node1:
        image: postgres:14
        container_name: postgres_node1
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
      # Enable logical replication
          POSTGRES_INITDB_ARGS: "--data-checksums"
        volumes:
          - pgdata_node1:/var/lib/postgresql/data
        ports:
          - "5432:5432"  # Expose port for replication and access
        restart: always

      postgres_node2:
        image: postgres:14
        container_name: postgres_node2
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
        volumes:
          - pgdata_node2:/var/lib/postgresql/data
        ports:
          - "5433:5432"  # Change port to avoid conflicts
        restart: always

      postgres_node3:
        image: postgres:14
        container_name: postgres_node3
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: yourpassword
          POSTGRES_DB: mydatabase
        volumes:
          - pgdata_node3:/var/lib/postgresql/data
        ports:
          - "5434:5432"  # Change port to avoid conflicts
        restart: always
  
    volumes:
      pgdata_node1:
      pgdata_node2:
      pgdata_node3: 

 ## Explanation of Configuration
 
   1. Docker PostgreSQL Containers: Three PostgreSQL containers (one for each node).
        - Each container runs the official PostgreSQL image.
        - The environment variables set up the database, user, and password.
        - Each node uses a separate volume to store its data.
        - Different ports are mapped to avoid conflicts.
   2. Data Directories: Each PostgreSQL instance has its persistent volume:
        - This ensures data isn't lost when containers are restarted.
   3. Network Considerations:
         - Make sure the Docker network configuration allows traffic between these nodes.
         - You might consider a custom Docker network if you need more control over networking.
   4. Replication Setup: This simple Docker Compose setup doesn't include logic for initiating logical replication — here are the general steps you would need to perform:
     
## Setting Up Logical Replication

   After running the docker-compose up -d, you will need manual configuration to set up logical replication. Here’s a high-level overview of steps you would take:
   
   1. Configure PostgreSQL for Replication:
         - Edit postgresql.conf on all three nodes to enable replication:
 
    wal_level = logical
    max_wal_senders = 3  # Adjust based on the number of replicas
  .      
         - Configure pg_hba.conf on all thee nodesto enable replication


    host    replication     postgres        0.0.0.0/0            
    md5     


   2. Start the Containers:

    docker-compose up -d 

   3. Create a Publication on the Primary Node: Connect to postgres_node1 (this will be your primary node) and run:

    CREATE PUBLICATION mypublication FOR ALL TABLES;
     
   4. Create Subscriptions on the Standby Nodes: Connect to postgres_node2 and postgres_node3 and run:

     CREATE SUBSCRIPTION mysubscription CONNECTION 'host=postgres_node1 
     port=5432 user=postgres password=yourpassword dbname=mydatabase' 
     PUBLICATION mypublication;


##  Additional Considerations.

   1. Monitoring:
        - Ensure you have monitoring for your PostgreSQL instances and replication lag, especially since you're working across multiple data container.
   2. Failover Strategy:
        - Plan a failover strategy, possibly using a tool like Patroni or repmgr, to manage automatic failover in case the primary node goes down.
   3. Security:
        - Secure your database connections and access, especially since you're dealing with multiple data container.
   4. Backup Strategy:
        - Implement a backup strategy for your database to avoid data loss.


## Conclusion

This setup provides a basic framework for running a PostgreSQL HA cluster with logical replication across three nodes using Docker. 
Adjust the configurations and logic-based replication setups according to your requirements and needs. 
If you have any further questions or need more detailed explanations about specific aspects, feel free to read oficial documentation

https://dzone.com/articles/postgresql-bidirectional-replication












 
