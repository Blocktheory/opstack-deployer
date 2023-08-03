# EVM Rollup from the OP Stack, L2 Chain Setup Script

This repository contains scripts to quick setup the L2 Optimism chain based on op stack.

## initial.sh

This script performs:

* Installs the necessary dependencies
* Creates the necessary directories
* Downloads the OP Stack Code

## setup.sh

This script performs:
* Initializes the OP Stack
* Starts the OP Stack

## Usage
To use the scripts, simply run them from the command line:


## Required 
ETH_RPC_URL — URL for your L1 node.
Accounts for 
- Admin
- Proposer
- Batcher
- Sequencer
or you can create a new one with command `cast wallet new`

#### Recommended funding amounts are as follows:
Admin — 2 ETH
Proposer — 5 ETH
Batcher — 10 ETH


For more details please refer: (Op-Stack-Get-Started)[https://stack.optimism.io/docs/build/getting-started]
## How to Run
```
Step 1
bash ./initial.sh 

Step 2
bash ./setup.sh -n <chain_name> -i=530067 -a "<admin_address>" -A "<admin_privatekey>" -s "<sequencer_address>" -S "<sequencer_privatekey>" -b "<batcher_address>" -B "<batcher_privatekey>" -p "<proposer_address>" -P "<proposer_private>" -r "<rpc_url>"
```


# Explorer

You can use Blockscout as an explorer for your chain. 

```
    git clone https://github.com/blockscout/blockscout/
    cd blocksout/docker-compose/
```

You can modify the environment variables here

```
    vim blockscout/docker-compose/envs/common-blockscout.env
```

```
    ETHEREUM_JSONRPC_VARIANT: 'geth'
    ETHEREUM_JSONRPC_HTTP_URL: http://host.docker.internal:8545/
    ETHEREUM_JSONRPC_TRACE_URL: http://host.docker.internal:8545/
    INDEXER_DISABLE_PENDING_TRANSACTIONS_FETCHER: "true"
    DATABASE_URL: postgresql://postgres:@host.docker.internal:7432/blockscout?ssl=false
    ECTO_USE_SSL: "false"
    NETWORK: ""
    SUBNETWORK: "Blocktheory"
    BLOCKSCOUT_VERSION: "Blocktheory 0.0.1"
    PORT: 4000
```

Once the environment variables are set. You can run the docker-compose

```
    docker-compose up --build
```