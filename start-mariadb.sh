#!/bin/bash

# Define environment variables
ROOT_PASSWORD="${MARIADB_ROOT_PASSWORD:-root_password}"
DATABASE="${MARIADB_DATABASE:-my_database}"
USER="${MARIADB_USER:-my_user}"
PASSWORD="${MARIADB_PASSWORD:-my_password}"

# Start MariaDB container with environment variables and volume
docker run -d \
  --name mariadb \
  -e MYSQL_ROOT_PASSWORD="${ROOT_PASSWORD}" \
  -e MYSQL_DATABASE="${DATABASE}" \
  -e MYSQL_USER="${USER}" \
  -e MYSQL_PASSWORD="${PASSWORD}" \
  -v database:/var/lib/mysql \
  -p ${DB_PORT:-3306}:3306 \
  my-mariadb

# Wait for MariaDB to start (adjust the timeout if needed)
timeout=60
count=0

while ! docker exec -i mariadb mysqladmin ping -proot 2>/dev/null; do
  sleep 1
  count=$((count+1))

  if [ $count -gt $timeout ]; then
    echo "MariaDB did not start within the timeout."
    exit 1
  fi
done

echo "MariaDB is up and running!"
