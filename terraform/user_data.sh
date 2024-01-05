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

##############################################################################################################
# Install Docker if it's not already installed
echo "Installing Docker..."
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, installing now..."
    yum install -y docker
else
    echo "Docker is already installed."
fi

##############################################################################################################
# Install unzip if it's not already installed
yum install -y unzip

# Start and enable Docker service
echo "Starting and enabling Docker..."
systemctl start docker
systemctl enable docker

##############################################################################################################
# Verify Docker is running
if ! systemctl is-active --quiet docker
then
    echo "Docker is not running, something went wrong with the installation."
    exit 1
else
    echo "Docker is running."
fi

##############################################################################################################
######################################  Axon server container startup ########################################
##############################################################################################################

# Create a Docker network
echo "Creating a Docker network..."
docker network create product-service-network

# Pull and run the Axon server on the custom network
echo "Pulling and running Axon Server..."
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

# Wait for Axon Server to be ready
echo "Waiting for Axon Server to be ready..."
until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
  printf 'Still waiting for axonserver to start...\n'
  sleep 5
done
echo "Axon Server is up - executing node initialization..."
curl -X POST http://localhost:8024/v1/context/init?context=default
echo "Axon Server is ready."

##############################################################################################################
######################################## Product Service Container startup ###################################
##############################################################################################################
# Loop until the RDS instance is available and get its endpoint
echo "Fetching RDS endpoint..."
RDS_INSTANCE_IDENTIFIER="product-service-db"
while true; do
    RDS_ENDPOINT=$(aws rds describe-db-instances \
                   --db-instance-identifier $RDS_INSTANCE_IDENTIFIER \
                   --query 'DBInstances[*].Endpoint.Address' \
                   --output text)

    RDS_PORT=$(aws rds describe-db-instances \
               --db-instance-identifier $RDS_INSTANCE_IDENTIFIER \
               --query 'DBInstances[*].Endpoint.Port' \
               --output text)

    if [ -n "$RDS_ENDPOINT" ] && [ -n "$RDS_PORT" ]; then
        echo "RDS Endpoint: $RDS_ENDPOINT"
        echo "RDS Port: $RDS_PORT"
        break
    else
        echo "Waiting for RDS instance to be available..."
        sleep 30
    fi
done

# Fetching secret from AWS Secrets Manager
SECRET_NAME="AWS_MYSQL_RDS_CREDENTIALS"
REGION="eu-central-1"
SECRET=$(aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $REGION | jq -r .SecretString)

# Parse the JSON string into individual components
AWS_MYSQL_USERNAME=$(echo $SECRET | jq -r .username)
AWS_MYSQL_PASSWORD=$(echo $SECRET | jq -r .password)
echo "AWS_MYSQL_USERNAME: $AWS_MYSQL_USERNAME"
echo "AWS_MYSQL_PASSWORD: $AWS_MYSQL_PASSWORD"

# Pull and run the Product service on the custom network
echo "Pulling and running Product service..."
docker run --network product-service-network \
  -m 256m \
  --log-driver=awslogs --log-opt awslogs-region=eu-central-1 \
  --log-opt awslogs-group=EC2_Product_Service_Container_Log_Group \
  --log-opt awslogs-create-group=true \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e AWS_RDS_MYSQL_HOST=${RDS_ENDPOINT}:${RDS_PORT} \
  -e AWS_RDS_MYSQL_USERNAME=$AWS_MYSQL_USERNAME \
  -e AWS_RDS_MYSQL_PASSWORD=$AWS_MYSQL_PASSWORD \
  --name product-service \
  -p 9091:9091 \
  -d sasha1doc/cqrs_product_service:latest
