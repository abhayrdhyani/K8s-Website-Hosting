#!/bin/bash
set -x # <--- Add this line
# --- Configuration Variables ---
# Replace with your Docker Hub username
DOCKER_USERNAME="abhayrdhyani" 
# Name for your Docker image (e.g., my-node-backend-api)
IMAGE_NAME="my-node-backend-image" 
# Tag for your Docker image (e.g., latest, v1.0, dev)
IMAGE_TAG="v1" 

# Full image name with tag for Docker Hub
FULL_IMAGE_NAME="$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"

# --- Validate Docker Hub Personal Access Token (PAT) ---
# It's crucial to set DOCKER_PAT as an environment variable before running this script:
# Example: export DOCKER_PAT="dckr_pat_YOUR_ACTUAL_PERSONAL_ACCESS_TOKEN_HERE"
if [ -z "$DOCKER_PAT" ]; then
  echo "Error: DOCKER_PAT environment variable is not set."
  echo "Please set it (e.g., 'export DOCKER_PAT=\"dckr_pat_YOUR_TOKEN\"') before running this script."
  exit 1
fi

# --- Navigate to the backend directory ---
echo "Navigating to the backend directory..."
cd .. 
cd backend || { echo "Error: 'backend' directory not found. Exiting."; exit 1; }
echo "Currently in: $(pwd)"

# --- Docker Login ---
echo "Attempting to log in to Docker Hub as $DOCKER_USERNAME..."
# We pipe the PAT to --password-stdin for secure non-interactive login
echo "$DOCKER_PAT" | docker login --username "$DOCKER_USERNAME" --password-stdin

if [ $? -ne 0 ]; then
  echo "Error: Docker login failed. Please check your username and DOCKER_PAT."
  exit 1
fi
echo "Docker login successful."

# --- Build the Docker Image ---
echo "Building Docker image: $FULL_IMAGE_NAME"
# The '.' indicates that the Dockerfile is in the current directory (which is now 'backend/')
docker build -t "$FULL_IMAGE_NAME" .

if [ $? -ne 0 ]; then
  echo "Error: Docker image build failed. Check your Dockerfile and context."
  # Optional: Log out if build fails, to prevent lingering session
  docker logout
  exit 1
fi
echo "Docker image built successfully."

# --- Push the Docker Image to Docker Hub ---
echo "Pushing Docker image: $FULL_IMAGE_NAME to Docker Hub..."
docker push "$FULL_IMAGE_NAME"

if [ $? -ne 0 ]; then
  echo "Error: Docker image push failed. Check your network or Docker Hub permissions."
  # Optional: Log out if push fails
  docker logout
  exit 1
fi
echo "Docker image pushed successfully to Docker Hub!"

# --- Clean up (Optional: Log out from Docker Hub) ---
# It's good practice to log out, especially in automated/CI/CD environments.
# For local development, you might omit this if you want to stay logged in persistently.
echo "Logging out from Docker Hub..."
docker logout
echo "Logged out from Docker Hub."

echo "Script finished."
