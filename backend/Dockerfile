# Use an official Node.js runtime as a parent image
#
# Using a specific Node.js LTS version for stability (e.g., 20-alpine or 22-alpine)
FROM node:20-alpine

# Set the working directory inside the container
# This is where your application code will reside
WORKDIR /app

# Copy package.json and package-lock.json first
# This step is optimized for Docker caching. If only your source code changes,
# npm install won't need to be re-run on subsequent builds.
COPY package*.json ./

# Install Node.js application dependencies
# This command will read package.json and install all listed dependencies.
RUN npm install

# Copy the rest of your application code into the container
# The '.' on the left refers to your local current directory (where Dockerfile is)
# The '.' on the right refers to the WORKDIR (/app) inside the container
COPY . .

# Expose the port your Node.js application listens on.
# Assuming your express app listens on port 3000 (a common default).
# If your index.js explicitly listens on a different port, change this.
EXPOSE 80

# Define the command to run your Node.js application when the container starts.
# We use "npm start" as defined in your package.json scripts.
CMD ["node", "index.js"]

# Note: The userscript.sh is for setting up your EC2 VM, not for the Docker container.
# It is not needed inside this Dockerfile.
