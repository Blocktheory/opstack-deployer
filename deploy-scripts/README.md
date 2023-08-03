![logo (6) 1](https://github.com/Blocktheory/opstack-setup-script/assets/13044958/418b5780-2bf5-46af-99a2-66f049aedc25)
# Launch OP Stack L2 Chain
This repository contains deployment scripts to quick setup & launch the L2 Optimism chain based on opstack.

## Steps to Launch Chain
You can visit [opstack.codecrane.com]([url](https://opstack.codecrane.com/))
or Follow the steps below

#### Hardware Requirements
```
Linux ubuntu 20.04 LTS
Min. 8GB RAM & 4 Core CPU
Storage 250GB or more
```
You can use any cloud services like [Digital Ocean]([url](https://cloud.digitalocean.com/)), [AWS]([url](https://aws.amazon.com/)), [Google Cloud]([url](https://cloud.google.com/)), etc.,

## Step 1
Clone the repository
```
git clone https://github.com/Blocktheory/opstack-setup-script
// navigate to the deploy script folder
cd opstack-setup-script/deploy-scripts
```

## Step 2
Create your environment file with following keys, you can use command `nano .env` or `vim .env` to create it 
```
CHAIN_NAME="Chain Name"
CHAIN_ID=
ETH_RPC_URL="L1 RPC End Point"
ADMIN_PUBLIC_ADDRESS="Admin public address"
ADMIN_PRIVATE_KEY="Admin private key "
SEQUENCER_PUBLIC_ADDRESS="Sequencer public address"
SEQUENCER_PRIVATE_KEY="Sequencer private key "
BATCHER_PUBLIC_ADDRESS="Batcher public address"
BATCHER_PRIVATE_KEY="Batcher private key "
PROPOSER_PUBLIC_ADDRESS="proposer public address"
PROPOSER_PRIVATE_KEY="Properser private key "
```
#### Funding requirement in each accounts:
- Admin — 2 ETH
- Proposer — 5 ETH
- Batcher — 10 ETH

## Step 3
Once you've created the environemnt file inside the deploy-scripts folder, You can run the initial scripts with command
```
bash ./initial.sh
or
./initial.sh
```
#### script initial.sh performs
* Installs the necessary dependencies
* Creates the necessary directories
* Downloads the OP Stack Code

## Step 4
Once initial.sh script runs successfully, We can refresh the terminal using command 
`source ~/.bashrc`

Then we can run the setup / final script with below command 
```
bash ./setup.sh
or
./setup.sh
```
#### script setup.sh performs
* Initializes the OP Stack
* Starts the OP Stack

### Deployed Successfully

Once the script runs successfully you can now see the new chain up and running in the port **8545**. You can access it by using the RPC end points as `host:8454` along with chain id used earlier while running the script.

The best way to submit feedback and report bugs is to [open a GitHub issue](https://github.com/Blocktheory/opstack-setup-script/issues)

For more details refer: [Opstack Offical Docs]([url](https://stack.optimism.io/docs/build/getting-started))

--------------------------------------------------
