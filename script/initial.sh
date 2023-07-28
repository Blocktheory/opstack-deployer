#!/bin/bash

# Enable "exit on error" and "pipefail" mode
set -eo pipefail

# Update package lists
sudo apt update

# Install build essentials
sudo apt install -y build-essential

# Install required packages
sudo apt install -y git curl make jq

# Download and install Go
echo 'Installing Go...'
wget https://go.dev/dl/go1.20.linux-amd64.tar.gz
tar xvzf go1.20.linux-amd64.tar.gz
sudo cp go/bin/go /usr/bin/go
sudo mv go /usr/lib
export GOROOT=/usr/lib/go
echo 'export GOROOT=/usr/lib/go' >> ~/.bashrc
source ~/.bashrc

# Install Node.js
echo 'Installing node and supported packages...'
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PNPM and Yarn
sudo npm install -g pnpm
sudo npm install -g yarn

# Install Rust
echo 'Installing Rust...'
curl https://sh.rustup.rs -sSf | sh -s -- -y
source ~/.bashrc

# Install Foundry
echo 'Installing Foundry...'
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc

# Install direnv
sudo apt install direnv