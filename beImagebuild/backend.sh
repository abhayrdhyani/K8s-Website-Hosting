#!/bin/bash
set -x # Enable verbose output for detailed debugging in workflow logs

# --- Configuration Variables ---
# Replace with your Docker Hub username
# IMPORTANT: These lines were re-typed carefully to remove any invisible/hidden characters.
DOCKER_USERNAME="abhayrdhyani"
# Name for your Docker image (e.g., my-node-backend-api)
IMAGE_NAME="my-node-backend-image"
# Tag for your Docker image (e.g., latest, v1.0, dev)
IMAGE_TAG="v1"

# Full image name with tag for Docker Hub
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

# --- Validate Docker Hub Personal Access Token (PAT) ---
# It's crucial to set DOCKER_PAT as an environment variable before running this script.
# In GitHub Actions, this is handled by the 'env:' block in your YAML.
if [ -z "$DOCKER_PAT" ]; then
  echo "Error: DOCKER_PAT environment variable is not set."
  echo "Please ensure 'DOCKER_HUB_PERSONAL_ACCESS_TOKEN' secret is configured in GitHub and passed via 'env:'."
  exit 1
fi

# --- Navigate to the backend directory where Dockerfile is ---
# Assuming this script (backend.sh) is in K8s-Website-Hosting/beImagebuild/
# and the Dockerfile is in K8s-Website-Hosting/backend/
# The workflow YAML will first 'cd beImagebuild' to run this script.
# So, this script needs to go up one level then into 'backend'.
echo "Navigating to the backend directory..."
cd .. # Go up from beImagebuild/ to K8s-Website-Hosting/
cd backend || { echo "Error: 'backend' directory not found. Exiting."; exit 1; }
echo "Currently in: $(pwd)" # Should show K8s-Website-Hosting/backend/

# --- Docker Login with Retry and Timeout ---
echo "Attempting to log in to Docker Hub as $DOCKER_USERNAME..."
MAX_RETRIES=3
RETRY_DELAY=10 # seconds

for i in $(seq 1 $MAX_RETRIES); do
  echo "Login attempt $i of $MAX_RETRIES..."
  # Use timeout to prevent indefinite hang. 60 seconds should be sufficient.
  echo "$DOCKER_PAT" | timeout 60s docker login --username "$DOCKER_USERNAME" --password-stdin

  # Check the exit code of the 'docker login' command
  if [ $? -eq 0 ]; then
    echo "Docker login successful."
    break # Exit loop on success
  elif [ $i -lt $MAX_RETRIES ]; then
    echo "Docker login failed or timed out. Retrying in $RETRY_DELAY seconds..."
    docker logout # Attempt to clear any partial/stuck login state
    sleep $RETRY_DELAY
  else
    echo "Error: Docker login failed after $MAX_RETRIES attempts. Check your username, PAT, and network connection to Docker Hub."
    exit 1 # Exit the script if all retries fail
  fi
done

# If the loop completed without a successful login, the script would have exited already.

# --- DEBUGGING IMAGE NAME (For verification) ---
echo "--- DEBUGGING IMAGE NAME ---"
echo "DOCKER_USERNAME_VAL: '$DOCKER_USERNAME'"
echo "IMAGE_NAME_VAL:      '$IMAGE_NAME'"
echo "IMAGE_TAG_VAL:       '$IMAGE_TAG'"
echo "FULL_IMAGE_NAME_VAL: '$FULL_IMAGE_NAME'" # This will clearly show if any hidden spaces exist
echo "--- END DEBUG ---"

# --- Build the Docker Image ---
echo "Building Docker image: $FULL_IMAGE_NAME"
# The '.' indicates that the Dockerfile is in the current directory (which is now 'backend/')
# DOCKER_BUILDKIT=0 added as a temporary workaround for buildx issues.
DOCKER_BUILDKIT=0 docker build -t "$FULL_IMAGE_NAME" .

if [ $? -ne 0 ]; then
  echo "Error: Docker image build failed. Check your Dockerfile and context."
  # Log out if build fails, to prevent lingering session
  docker logout
  exit 1
fi
echo "Docker image built successfully."

# --- Push the Docker Image to Docker Hub ---
echo "Pushing Docker image: $FULL_IMAGE_NAME to Docker Hub..."
docker push "$FULL_IMAGE_NAME"

if [ $? -ne 0 ]; then
  echo "Error: Docker image push failed. Check your network or Docker Hub permissions."
  docker logout
  exit 1
fi
echo "Docker image pushed successfully to Docker Hub!"

# --- Clean up (Log out from Docker Hub) ---
# It's good practice to log out, especially in automated/CI/CD environments.
echo "Logging out from Docker Hub..."
docker logout
echo "Logged out from Docker Hub."

echo "Script finished."
