![logo (6) 1](https://github.com/Blocktheory/opstack-setup-script/assets/13044958/418b5780-2bf5-46af-99a2-66f049aedc25)
# Launch OP Stack L2 Chain
Our repository contains deployment scripts that facilitate the seamless setup and launch of the L2 Optimism chain, built on the robust opstack platform. Our aim is to simplify the L2 chain deployment process, allowing developers and users to effortlessly experience the power and potential of the L2 Optimism solution. With our user-friendly scripts, you can quickly configure and deploy the L2 chain.

## Launching the OP Stack chain is a straightforward process
Follow the steps below to get started:

1. _Visit [opstack.vercel.app](https://opstack.vercel.app)_: You can start the chain setup by visiting [opstack.vercel.app](https://opstack.vercel.app), where you'll find all the necessary resources and documentation or you can follow the steps in below.
2. _Hardware Requirements_: Ensure that you have the following hardware specifications

```
Linux ubuntu 20.04 LTS
Min. 8GB RAM & 4 Core CPU
Storage 250GB or more
```

3. _Cloud Service Options_: You have the flexibility to use any cloud service provider, such as [Digital Ocean]([url](https://cloud.digitalocean.com/)), [AWS]([url](https://aws.amazon.com/)), [Google Cloud]([url](https://cloud.google.com/)), etc.,

# Follow these simple steps to launch your very own L2 Optimism chain:
## Step 1 - Clone the repository
```
git clone https://github.com/Blocktheory/opstack-setup-script
// navigate to the deploy script folder
cd opstack-setup-script/deploy-scripts
```

## Step 2 - Create your environment file
Create a new environment file using nano .env or vim .env, and add the following keys:
```
CHAIN_NAME="Chain Name"
CHAIN_ID=730577
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
#### Make sure to define the funding requirements for each account::
- Admin: 2 ETH
- Proposer: 5 ETH
- Batcher: 10 ETH

## Step 3 - Run initial script
After creating the environment file, run the initial script using:
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

## L2 Chain Deployed Successfully

Once the script runs successfully you can now see the new chain up and running in the port **8545**. You can access it by using the RPC end points as `host:8545` along with chain id used earlier while running the script.

The best way to submit feedback and report bugs is to [open a GitHub issue](https://github.com/Blocktheory/opstack-setup-script/issues)

For more details refer: [Opstack Offical Docs]([url](https://stack.optimism.io/docs/build/getting-started))


## Setup Blockscout Explorer _(Optional)_
For setting up the explorer for the new l2 chain launched, Please follow setps below 

Lets, clone the blockscout explorer 
```
git clone https://github.com/blockscout/blockscout/
cd blocksout/docker-compose/
```

We can modify the environment variables here, 

```
vim blockscout/docker-compose/envs/common-blockscout.env
or 
nano blockscout/docker-compose/envs/common-blockscout.env
```
You can refer to the below values in the environment file
```
ETHEREUM_JSONRPC_VARIANT: 'geth'
ETHEREUM_JSONRPC_HTTP_URL: http://host.docker.internal:8545/
ETHEREUM_JSONRPC_TRACE_URL: http://host.docker.internal:8545/
INDEXER_DISABLE_PENDING_TRANSACTIONS_FETCHER: "true"
DATABASE_URL: postgresql://postgres:@host.docker.internal:7432/blockscout?ssl=false
ECTO_USE_SSL: "false"
NETWORK: ""
SUBNETWORK: "Blocktheory"
BLOCKSCOUT_VERSION: "Blocktheory"
PORT: 4000
```
Once the environment variables are set. You can run the docker-compose

```
docker-compose up --build -d
```

Now, you can access the blocksout explorer in port **4000**. You can access it by using the end point as `host:4000`

