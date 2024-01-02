#!/bin/bash
  yum update -y
  yum install -y docker unzip

  # Start and enable Docker
  systemctl start docker
  systemctl enable docker

  # Create a Docker network
  docker network create axon-network

  # Pull and run the Axon server on the custom network
  docker run -d --name axonserver \
    --network axon-network \
    -p 8024:8024 \
    -p 8124:8124 \
    -v axondata:/data \
    -v axonevents:/eventdata \
    -v axonconfig:/config \
    axoniq/axonserver:latest

  # Wait for Axon Server to be ready
  echo "Waiting for Axon Server to be ready..."
  until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
    printf 'Waiting for Axon Server to start...\n'
    sleep 5
  done

  echo "Axon Server is up - executing command"

  # Initialize Axon Server using REST API
  curl -X POST http://localhost:8024/v1/context/init?context=default

  # Pull and run the Product service on the custom network
  docker run -d --name product-service \
    --network axon-network \
    -p 8081:8081 \
    -e SPRING_PROFILES_ACTIVE=prod \
    sasha1doc/cqrs_product_service:latest
