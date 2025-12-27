#!/bin/bash

# Configuration
LOG_FILE="container_run.log"
TEST_DURATION=5  # in seconds
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Initialize log file
echo "Docker Image Tests - Started at $TIMESTAMP" > "$LOG_FILE"
echo "----------------------------------------" >> "$LOG_FILE"

# Get all Docker images (excluding intermediary images)
images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep java-image | grep -v "<none>")

# Check if any images exist
if [ -z "$images" ]; then
  echo "No Docker images found." | tee -a "$LOG_FILE"
  exit 1
fi

# Count the number of images
image_count=$(echo "$images" | wc -l)
echo "Found $image_count Docker images to test." | tee -a "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Function to test an image and log results
test_image() {
  local image="$1"
  echo "Testing image: $image" | tee -a "$LOG_FILE"
  
  # Start container with a timeout
  echo "  Starting container..." | tee -a "$LOG_FILE"
  container_id=$(docker run -d "$image")
  
  if [ $? -ne 0 ]; then
    echo "  ❌ FAILED: Could not start container for image $image" | tee -a "$LOG_FILE"
    echo "----------------------------------------" >> "$LOG_FILE"
    return 1
  fi
  
  echo "  Container ID: $container_id" >> "$LOG_FILE"
  echo "  Running for $TEST_DURATION seconds..." | tee -a "$LOG_FILE"
  
  # Wait for the specified duration
  sleep "$TEST_DURATION"
  
  # Check if container is still running
  if docker ps -q --filter "id=$container_id" | grep -q .; then
    container_status="Still running after $TEST_DURATION seconds"
    exit_code="N/A"
  else
    container_status="Exited before $TEST_DURATION seconds timeout"
    exit_code=$(docker inspect "$container_id" --format='{{.State.ExitCode}}')
  fi
  
  # Capture logs
  echo "  Container logs:" | tee -a "$LOG_FILE"
  docker logs "$container_id" 2>&1 | tee -a "$LOG_FILE"
  
  # Stop and remove container
  docker stop "$container_id" >/dev/null
  docker rm "$container_id" >/dev/null
  
  # Log results
  echo "  Status: $container_status" | tee -a "$LOG_FILE"
  
  if [ "$exit_code" = "N/A" ]; then
    echo "  Exit code: N/A (container was still running)" | tee -a "$LOG_FILE"
    echo "  ✅ PASSED: Container stayed running for the full duration" | tee -a "$LOG_FILE"
  elif [ "$exit_code" = "0" ]; then
    echo "  Exit code: 0" | tee -a "$LOG_FILE"
    echo "  ✅ PASSED: Container exited with code 0" | tee -a "$LOG_FILE"
  else
    echo "  Exit code: $exit_code" | tee -a "$LOG_FILE"
    echo "  ❌ FAILED: Container exited with non-zero code" | tee -a "$LOG_FILE"
  fi
  
  echo "----------------------------------------" >> "$LOG_FILE"
}

# Test each image
count=1
for image in $images; do
  echo "[$count/$image_count] Testing $image"
  test_image "$image"
  ((count++))
  echo "" | tee -a "$LOG_FILE"
done

# Finalize log file
FINISH_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
echo "Docker Image Tests - Completed at $FINISH_TIMESTAMP" >> "$LOG_FILE"
echo "All tests completed. Results saved to $LOG_FILE"