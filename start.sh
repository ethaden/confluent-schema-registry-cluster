#!/bin/bash

docker compose up -d

docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
# Run the following commands only if the profile is active
if [[ "$DOCKER_COMPOSE" =~ .*"IndependentSchemaRegistry".* ]]; then
  docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
  docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
fi

export MEASUREMENT1_SCHEMA=$(jq -n --rawfile schema avro/measurement-v1.avsc '{schema: $schema}')
export MEASUREMENT2_SCHEMA=$(jq -n --rawfile schema avro/measurement-v2.avsc '{schema: $schema}')

docker compose exec schema-registry curl -u admin:admin -X POST -H "Content-Type: application/vnd.schemaregistry.v1+json" \
--data "$MEASUREMENT1_SCHEMA" \
http://schema-registry:8081/subjects/measurements-value/versions

