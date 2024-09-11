#!/bin/bash

# Ensure the script has received the container ID and port as parameters
if [ -z "$1" ]; then
    echo "Container ID not provided."
    exit 1
fi
if [ -z "$2" ]; then
    echo "Port not provided."
    exit 1
fi

container_id=$1
port=$2

# Set the base directory relative to the script's location
BASE_DIR=$(dirname "$0")/..

# Request user to insert the relative path of the input file
echo "Please enter the relative path of the input file:"
read input_file

# Check if the input file exists
if [ ! -f "$BASE_DIR/$input_file" ]; then
    echo "Input file not found in $BASE_DIR."
    exit 1
fi

# Read the text from the input file
text=$(cat "$BASE_DIR/$input_file")

# Send a request to the brunet_index endpoint and save the response
response=$(curl --fail -s -X POST -H "Content-Type: application/json" -d "{\"text\": \"$text\"}" http://localhost:$port/brunet_index)

# Check the exit status of the curl command
if [ $? -ne 0 ]; then
    echo "Failed to get response from the server."
    docker logs $container_id >> "$BASE_DIR/output/logs.txt"
    exit 1
fi

# Check if the response contains an error
if echo "$response" | grep -q "error"; then
    echo "Error occurred while calculating Brunet's Index:"
    echo "$response"
    docker logs $container_id >> "$BASE_DIR/output/logs.txt"
    exit 1
fi

# Save the Brunet's Index results to a file
echo "$response" > "$BASE_DIR/output/brunet_index_results.json"

echo "Brunet's Index calculation completed successfully."

# Display the Brunet's Index results
echo "Brunet's Index results:"
cat "$BASE_DIR/output/brunet_index_results.json"

# Exit successfully
exit 0