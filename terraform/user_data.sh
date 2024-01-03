#!/bin/bash

# Update the system
yum update -y

# Install AWS CLI if it's not already installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found, installing now..."
    # Instructions for Amazon Linux 2
    yum install -y awscli
else
    echo "AWS CLI is already installed."
fi

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
  --log-driver=awslogs \
  --log-opt awslogs-region=eu-central-1 \
  --log-opt awslogs-group=EC2_Axonserver_Container_Log_Group \
  --log-opt awslogs-create-group=true \
  -p 8024:8024 \
  -p 8124:8124 \
  -v axondata:/data \
  -v axonevents:/eventdata \
  -v axonconfig:/config \
  axoniq/axonserver:latest

# Pull and run the Product service on the custom network
docker run --network product-service-network \
  -m 256m \
  --log-driver=awslogs --log-opt awslogs-region=eu-central-1 \
  --log-opt awslogs-group=EC2_Product_Service_Container_Log_Group \
  --log-opt awslogs-create-group=true \
  SPRING_PROFILES_ACTIVE=prod \
  --name product-service \
  -p 9091:9091 \
  -d sasha1doc/cqrs_product_service:latest

# Wait for Axon Server to be ready
echo "Waiting for Axon Server to be ready..."
until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
  printf 'Still waiting for axonserver to start...\n'
  sleep 5
done

echo "Axon Server is up - executing node initialization..."

# Initialize Axon Server using REST API
curl -X POST http://localhost:8024/v1/context/init?context=default
