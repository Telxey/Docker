# PostgreSQL-HA over 3 Remote locations servers

Creating a highly available (HA) PostgreSQL cluster using logical replication across three nodes in three different data centers 
can be done with Docker and Docker Compose. Below, I'll provide a general overview of how to set this up followed by a samples docker-compose.yml configuration.
Each server will run its own PostgreSQL instance, and you'll use Docker to manage these instances.Here’s how you can structure the setup:

## High-Level Overview

   1. Remote Servers:
      - You'll have three servers, each running a PostgreSQL instance within a Docker container
   2. Network Configuration:
      - Ensure that each PostgreSQL instance can communicate with the others over the network. You may need to configure security groups, firewalls, or use a VPN to allow traffic between the servers.
   3. Cloudflare Zero Trust:
      - Tunnel: If you're using Cloudflare Zero Trust, you'll need to set it up to securely expose your PostgreSQL instances to each other.











