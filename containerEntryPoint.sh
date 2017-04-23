#!/bin/bash

if [ "$IS_AWS" = true ]; then
  export DOCKER_HOST_IP=$(curl -s 169.254.169.254/latest/meta-data/local-ipv4)
fi

cmd="/app/node_modules/.bin/json-server db.json --port=8080 $@"

exec $cmd
