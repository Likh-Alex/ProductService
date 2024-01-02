#!/bin/bash

  # Update the system
  yum update -y

  # Install Docker if it's not already installed
  if ! command -v docker &> /dev/null
  then
      echo "Docker could not be found, installing now..."
      yum install -y docker
  else
      echo "Docker is already installed."
  fi

  # Install unzip if it's not already installed
  yum install -y unzip

  # Start and enable Docker service
  systemctl start docker
  systemctl enable docker

  # Verify Docker is running
  if ! systemctl is-active --quiet docker
  then
      echo "Docker is not running, something went wrong with the installation."
      exit 1
  else
      echo "Docker is running."
  fi

  # Create a Docker network
  docker network create product-service-network

  # Pull and run the Axon server on the custom network
  docker run -d --name axonserver \
    --network product-service-network \
    -p 8024:8024 \
    -p 8124:8124 \
    -v axondata:/data \
    -v axonevents:/eventdata \
    -v axonconfig:/config \
    axoniq/axonserver:latest

  # Pull and run the Product service on the custom network
  docker container run --network product-service-network \
    --name product-service \
    -p 8081:8081 \
    -d sasha1doc/cqrs_product_service:latest

  # Wait for Axon Server to be ready
  echo "Waiting for Axon Server to be ready..."
  until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
    printf 'Waiting for Axon Server to start...\n'
    sleep 5
  done

  echo "Axon Server is up - executing command"

  # Initialize Axon Server using REST API
  curl -X POST http://localhost:8024/v1/context/init?context=default
