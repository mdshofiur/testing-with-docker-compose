#!/bin/bash


# Check if at least one server address is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 server1 [server2 ... serverN]"
    exit 1
fi


# Define the server addresses and ports
servers=("localhost:8083" "localhost:8084")

# Path to your nginx configuration file
nginx_conf="/etc/nginx/nginx.conf"

# Function to add servers to upstream block
add_servers_to_upstream() {
    for server in "${servers[@]}"; do
        sed -i "/upstream backend {/a \    server $server;" $nginx_conf
    done
}

# Check if nginx configuration file exists
if [ ! -f "$nginx_conf" ]; then
    echo "Nginx configuration file not found: $nginx_conf"
    exit 1
fi

# Add servers to upstream block
add_servers_to_upstream

# Format nginx configuration file
# sed -i 's/}/}\n\n/g' $nginx_conf
# sed -i 's/{/{\n/g' $nginx_conf

# Reload nginx to apply changes
nginx -s reload

# Docker run command
docker run -d -p 8083:8080 --name dev_app-container_2 shafikur/aspdotnet-app:dev
docker run -d -p 8084:8080 --name dev_app-container_3 shafikur/aspdotnet-app:dev
