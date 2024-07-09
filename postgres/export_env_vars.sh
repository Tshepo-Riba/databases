#!/bin/bash



# Pulling secrets from Vault

echo "Pulling secrets from the vault ........"
export VAULT_TOKEN=$(grep "Initial Root Token:" "../vault_keys.txt" | awk '{print $4}')

export PG_DB=$(curl --header "X-Vault-Token:$VAULT_TOKEN" --request GET http://127.0.0.1:8200/v1/secret/data/postgres | jq '.data.data.dbname')
export PG_USER=$(curl --header "X-Vault-Token:$VAULT_TOKEN" --request GET http://127.0.0.1:8200/v1/secret/data/postgres | jq '.data.data.username')
export PG_PASSWORD=$(curl --header "X-Vault-Token:$VAULT_TOKEN" --request GET http://127.0.0.1:8200/v1/secret/data/postgres | jq '.data.data.password')

export PG_REPLICATION_USER=$(curl --header "X-Vault-Token:$VAULT_TOKEN" --request GET http://127.0.0.1:8200/v1/secret/data/pg_replication | jq '.data.data.username')
export PG_REPLICATION_PASSWORD=$(curl --header "X-Vault-Token:$VAULT_TOKEN" --request GET http://127.0.0.1:8200/v1/secret/data/pg_replication | jq '.data.data.password')



echo "Replacing placeholders in 00_init.sql ........"
# Replace placeholders in 00_init.sql
sed -i "s/\${PG_REPLICATION_USER}/$PG_REPLICATION_USER/g" 00_init.sql
sed -i "s/\${PG_REPLICATION_PASSWORD}/$PG_REPLICATION_PASSWORD/g" 00_init.sql

echo "Secrets successfully pulled from Vault and configurations updated."



echo "Running Docker Compose with environment variables ........"
# Run Docker Compose with environment variables
docker-compose up -d --build

docker-compose logs postgres-master





