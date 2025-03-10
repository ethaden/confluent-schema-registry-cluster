#!/bin/bash

docker compose up -d

while ! nc -z localhost 8081; do   
  sleep 0.1 # wait for 1/10 of the second before check again
done

while ! nc -z localhost 18081; do   
  sleep 0.1 # wait for 1/10 of the second before check again
done

while ! nc -z localhost 28081; do   
  sleep 0.1 # wait for 1/10 of the second before check again
done

docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry2 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -s '*' -o '*' -p 'admin'
docker compose exec schema-registry3 sr-acl-cli --config /etc/schema-registry/schema-registry.properties --add -o 'SUBJECT_READ:GLOBAL_READ' -s '*' -t '*' -p 'user'
