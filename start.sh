#!/bin/bash

docker compose up -d

docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
#docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
#docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
# Run the following commands only if the profile is active
if [[ "$DOCKER_COMPOSE" =~ .*"IndependentSchemaRegistry".* ]]; then
  docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
  docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
fi
