#!/bin/bash

# Check if at least two parameters (server and container) are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 server1:port1 container_name1 [server2:port2 container_name2 ... serverN:portN container_nameN]"
    exit 1
fi

# Collect server addresses and container names from command-line arguments
servers=()
container_names=()
while [ "$#" -gt 0 ]; do
    servers+=("$1")
    container_names+=("$2")
    shift 2
done

# Path to your nginx configuration file
nginx_conf="/etc/nginx/nginx.conf"

# Function to remove servers from upstream block
remove_servers_from_upstream() {
    for server in "${servers[@]}"; do
        sed -i "/server $server;/d" $nginx_conf
    done
}

# Check if nginx configuration file exists
if [ ! -f "$nginx_conf" ]; then
    echo "Nginx configuration file not found: $nginx_conf"
    exit 1
fi

# Remove servers from upstream block
remove_servers_from_upstream

# Reload nginx to apply changes
nginx -s reload

# Stop and remove containers
for container_name in "${container_names[@]}"; do
    docker stop "$container_name"
    docker rm "$container_name"
done

