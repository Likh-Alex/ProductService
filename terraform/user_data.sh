#!/bin/bash
  yum update -y
  yum install -y docker unzip

  # Start and enable Docker
  systemctl start docker
  systemctl enable docker

  # Pull and run the Axon server
  docker run -d --name axonserver \
    -p 8024:8024 \
    -p 8124:8124 \
    -v axondata:/data \
    -v axonevents:/eventdata \
    -v axonconfig:/config \
    axoniq/axonserver:latest

  # Pull and run the Product service
  docker run -d --name product-service -p 8081:8081 sasha1doc/cqrs_product_service:latest

  # Wait for Axon Server to be ready
  echo "Waiting for Axon Server to be ready..."
  until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
    printf 'Still waiting for Axon Server to be ready...'
    sleep 5
  done

  echo "Axon Server is up - executing command"

  # Initialize Axon Server using REST API
  curl -X POST http://localhost:8024/v1/context/init?context=default