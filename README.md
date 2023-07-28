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