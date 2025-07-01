#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Starting EC2 Node.js Setup Script ---"

# 1. Install NVM (Node Version Manager)

echo "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash # Updated NVM version to a recent one

#Activate nvm by typing the following at the command line.
. ~/.nvm/nvm.sh


# 2. Install Node.js using NVM
echo "Installing Node.js (latest LTS)..."
nvm install node # Installs the latest LTS version
nvm use node     # Sets it as the default for the current shell

echo "Node.js installed via NVM. Version: $(node -v)"
echo "NPM version: $(npm -v)"

# 3. Install Git (if not already present)
echo "Installing Git..."
sudo apt-get update -y
sudo apt-get install git -y

echo "Git installed."


# 4. Clone the GitHub repository
echo "Cloning the repository: https://github.com/abhayrdhyani/nodejs-on-ec2.git"
#cd /home/ubuntu
sudo git clone -b FeatureB https://github.com/abhayrdhyani/nodejs-on-ec2.git
echo "Repository cloned successfully. Navigated to $(pwd)"

#sudo mv nodejs-on-ec2/ /opt

sudo mv nodejs-on-ec2 /opt/nodejs-on-ec2
cd /opt

sudo chown -R ubuntu:ubuntu /opt/nodejs-on-ec2

cd nodejs-on-ec2

# 5. Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install # Installs all dependencies from package.json
npm install express # This is usually redundant if express is in package.json and npm install is run.


echo "Dependencies installed."

#which node
#sudo /home/ubuntu/.nvm/versions/node/v24.2.0/bin/node index.js



 


