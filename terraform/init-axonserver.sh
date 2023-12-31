# Wait for Axon Server to be ready
echo "Waiting for Axon Server to be ready..."
until $(curl --output /dev/null --silent --head --fail http://localhost:8024); do
  printf 'Still waiting for Axon Server to be ready...'
  sleep 5
done

echo "Axon Server is up - executing command"

# Initialize Axon Server using REST API
curl -X POST http://localhost:8024/v1/context/init?context=default