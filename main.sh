#!/bin/bash

set -e

function build_image() {
  local image_name=$1
  echo "Building image '$image_name'."
  docker build -t "$image_name" "./$image_name"
}

function stop_rm_container() {
    local container_name=$1
    if docker ps -a --format '{{.Names}}' | grep -q $container_name; then
        echo "Stopping and removing container '$container_name'."
        docker stop $container_name && docker rm $container_name
    fi
}

function error_handling() {
  local error=$1
  if [[ $error == "run_operation" ]]; then
    echo "Error: Specify a run operation."
    exit 1
  elif [[ $error == "producer_container_number" ]]; then
    echo "Error: integer value between 1 and 8 is required for 'producer' option."
    exit 1
  else
    echo "Wrong input. Pick one of: 'run_operation', 'producer_container_number'."
  fi
}


if [[ "$1" == "producer" ]]; then
  containers=${3:-8}

  if [[ "$2" == "build" ]]; then
    build_image "producer"
    exit 0
  fi
  if (( $containers >= 1 && $containers <= 8 )); then
    for ((i=1;i<=${containers};i++)); do
      container_name="shop-${i}"
      if [[ "$2" == "up" ]]; then
        echo "Starting container '$container_name'."
        docker run \
          --env-file ./producer/.env \
          --detach \
          -e SHOP_ID="$i" \
          --net kafka-postgres-grafana-data-pipeline_shops-network \
          --name  "$container_name" producer
      elif [[ "$2" == "down" ]]; then
        stop_rm_container $container_name
      else
        error_handling "run_operation"
      fi
    done
  else
    error_handling "producer_container_number"
  fi

elif [[ "$1" == "consumer" ]]; then
  container_name="consumer"
  if [[ "$2" == "build" ]]; then
    build_image "consumer"
  elif [[ "$2" == "up" ]]; then
    echo "Starting container '$container_name'."
    docker run \
      --env-file ./consumer/.env \
      --detach \
      --net kafka-postgres-grafana-data-pipeline_shops-network \
      --name $container_name $container_name
  elif [[ "$2" == "down" ]]; then
    stop_rm_container $container_name
  else
    error_handling "run_operation"
  fi
fi