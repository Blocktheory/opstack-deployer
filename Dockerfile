# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Enable "exit on error" and "pipefail" mode
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set non-interactive environment variables for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install required packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    make \
    jq \
    wget \
    nodejs \
    npm \
    direnv

# Download and install Go
RUN wget https://go.dev/dl/go1.20.linux-amd64.tar.gz && \
    tar xvzf go1.20.linux-amd64.tar.gz && \
    cp -n go/bin/go /usr/bin/go && \
    mv -n go /usr/lib && \
    echo 'export GOROOT=/usr/lib/go' >> ~/.bashrc && \
    source ~/.bashrc

# Install PNPM and Yarn
# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install PNPM
RUN npm install -g pnpm

# Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
    source ~/.bashrc

# Install Foundry
RUN mkdir -p $HOME/.foundry/bin && \
    curl -o $HOME/.foundry/bin/foundryup https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/foundryup && \
    chmod +x $HOME/.foundry/bin/foundryup && \
    mkdir -p $HOME/.foundry/share/man/man1 && \
    echo >> $HOME/.bashrc && echo "export PATH=\"\$PATH:$HOME/.foundry/bin\"" >> $HOME/.bashrc && \
    echo "source $HOME/.bashrc" >> $HOME/.bashrc
RUN export PATH="$PATH:$HOME/.foundry/bin"

ENV GOROOT=/usr/lib/go
ENV PATH="$PATH:$HOME/.foundry/bin"

# Set up working directory
WORKDIR /app

# Copy the script file into the container
COPY deploy-scripts/setup.sh /app/setup.sh


RUN echo "CHAIN_ID=$CHAIN_ID\nCHAIN_NAME=$CHAIN_NAME\nETH_RPC_URL=$ETH_RPC_URL\nADMIN_PUBLIC_ADDRESS=$ADMIN_PUBLIC_ADDRESS\nADMIN_PRIVATE_KEY=$ADMIN_PRIVATE_KEY\nSEQUENCER_PUBLIC_ADDRESS=$SEQUENCER_PUBLIC_ADDRESS\nSEQUENCER_PRIVATE_KEY=$SEQUENCER_PRIVATE_KEY\nBATCHER_PUBLIC_ADDRESS=$BATCHER_PUBLIC_ADDRESS\nBATCHER_PRIVATE_KEY=$BATCHER_PRIVATE_KEY\nPROPOSER_PUBLIC_ADDRESS=$PROPOSER_PUBLIC_ADDRESS\nPROPOSER_PRIVATE_KEY=$PROPOSER_PRIVATE_KEY\nRPC_KIND=$RPC_KIND\n" > .env

# COPY .env .env

# Make the script executable
RUN chmod +x /app/setup.sh

# Run the script
CMD /bin/bash -c " source ~/.bashrc && /app/setup.sh"