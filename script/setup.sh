#!/bin/bash

# Enable "exit on error" and "pipefail" mode
set -eo pipefail

output_location="/var/optimism/packages/contracts-bedrock/deploy-config/"

# Function to check if a required parameter is missing
function check_parameter {
    if [ -z "$2" ]; then
        echo "Error: $1 is not defined in the .env file."
        exit 1
    fi
}

# Load the .env file if it exists
if [ -f .env ]; then
    source .env
else
    echo "Error: .env file not found."
    exit 1
fi

# Check required parameters
check_parameter "CHAIN_NAME" "$CHAIN_NAME"
check_parameter "CHAIN_ID" "$CHAIN_ID"
check_parameter "ETH_RPC_URL" "$ETH_RPC_URL"
check_parameter "ADMIN_PUBLIC_ADDRESS" "$ADMIN_PUBLIC_ADDRESS"
check_parameter "ADMIN_PRIVATE_KEY" "$ADMIN_PRIVATE_KEY"
check_parameter "SEQUENCER_PUBLIC_ADDRESS" "$SEQUENCER_PUBLIC_ADDRESS"
check_parameter "SEQUENCER_PRIVATE_KEY" "$SEQUENCER_PRIVATE_KEY"
check_parameter "BATCHER_PUBLIC_ADDRESS" "$BATCHER_PUBLIC_ADDRESS"
check_parameter "BATCHER_PRIVATE_KEY" "$BATCHER_PUBLIC_ADDRESS"
check_parameter "PROPOSER_PUBLIC_ADDRESS" "$PROPOSER_PUBLIC_ADDRESS"
check_parameter "PROPOSER_PRIVATE_KEY" "$PROPOSER_PRIVATE_KEY"

# Clone and install Optimism
cd ~
cd /var
git clone https://github.com/blocktheory/optimism.git
cd optimism
pnpm install
make op-node op-batcher op-proposer

foundryup
pnpm build

# Clone and install op-geth
cd ..
git clone https://github.com/blocktheory/op-geth.git
cd op-geth
make geth

# Set ETH_RPC_URL environment variable
cd ../optimism/
export ETH_RPC_URL="$ETH_RPC_URL"


output=$(cast block finalized --rpc-url $ETH_RPC_URL | grep -E "(timestamp|hash|number)")

blockhash=$(echo "$output" | awk '/hash/ {print $2}')
number_value=$(echo "$output" | awk '/number/ {print $2}')
timestamp=$(echo "$output" | awk '/timestamp/ {print $2}')

json_data=$(cat <<EOF
{
  "numDeployConfirmations": 1,

  "finalSystemOwner": "$ADMIN_PUBLIC_ADDRESS",
  "portalGuardian": "$ADMIN_PUBLIC_ADDRESS",
  "controller": "$ADMIN_PUBLIC_ADDRESS",

  "l1StartingBlockTag": "$blockhash",

  "l1ChainID": 5,
  "l2ChainID": $CHAIN_ID,
  "l2BlockTime": 2,

  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 300,

  "p2pSequencerAddress": "$SEQUENCER_PUBLIC_ADDRESS",
  "batchInboxAddress": "0xff000000000000000000000000000000000$CHAIN_ID",
  "batchSenderAddress": "$BATCHER_PUBLIC_ADDRESS",

  "l2OutputOracleSubmissionInterval": 120,
  "l2OutputOracleStartingBlockNumber": 0,
  "l2OutputOracleStartingTimestamp": $timestamp,

  "l2OutputOracleProposer": "$PROPOSER_PUBLIC_ADDRESS",
  "l2OutputOracleChallenger": "$ADMIN_PUBLIC_ADDRESS",

  "finalizationPeriodSeconds": 12,

  "proxyAdminOwner": "$ADMIN_PUBLIC_ADDRESS",
  "baseFeeVaultRecipient": "$ADMIN_PUBLIC_ADDRESS",
  "l1FeeVaultRecipient": "$ADMIN_PUBLIC_ADDRESS",
  "sequencerFeeVaultRecipient": "$ADMIN_PUBLIC_ADDRESS",

  "baseFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "l1FeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "sequencerFeeVaultMinimumWithdrawalAmount": "0x8ac7230489e80000",
  "baseFeeVaultWithdrawalNetwork": 0,
  "l1FeeVaultWithdrawalNetwork": 0,
  "sequencerFeeVaultWithdrawalNetwork": 0,

  "gasPriceOracleOverhead": 2100,
  "gasPriceOracleScalar": 1000000,

  "enableGovernance": true,
  "governanceTokenSymbol": "OP",
  "governanceTokenName": "Optimism",
  "governanceTokenOwner": "$ADMIN_PUBLIC_ADDRESS",

  "l2GenesisBlockGasLimit": "0x1c9c380",
  "l2GenesisBlockBaseFeePerGas": "0x3b9aca00",
  "l2GenesisRegolithTimeOffset": "0x0",

  "eip1559Denominator": 50,
  "eip1559Elasticity": 10
}
EOF
)

create_file_name_format() {
    local input_string="$1"
    # Replace spaces and special characters with underscores using parameter expansion and regex
    formatted_string="${input_string//[^[:alnum:]_]/_}"
    # Convert the string to lowercase
    formatted_string="${formatted_string,,}"
    echo "$formatted_string"
}

file_name_format=$(create_file_name_format "$CHAIN_NAME")

echo "$json_data" > "$output_location/$file_name_format.json"

cd packages/contracts-bedrock/
cp -n .envrc.example .envrc


# Function to load .envrc files in a directory 
update_env_variable() {
    local variable_name="$1"
    local new_value="$2"

    # Check if the variable exists in the .envrc file
    if grep -q "^export $variable_name=" .envrc; then
        # Variable exists, update its value using sed
        awk -v var="$variable_name" -v val="$new_value" 'BEGIN {FS=OFS="="} $1 == "export " var {$2 = val} 1' .envrc > .envrc.tmp && mv .envrc.tmp .envrc
    else
        # Variable does not exist, add it to the .envrc file
        echo "export $variable_name=$new_value" >> .envrc
    fi
}

update_env_variable "ETH_RPC_URL" "$ETH_RPC_URL"
update_env_variable "DEPLOYMENT_CONTEXT" "$file_name_format"
update_env_variable "PRIVATE_KEY" "$ADMIN_PRIVATE_KEY"
update_env_variable "L1_RPC" "$ETH_RPC_URL"
update_env_variable "RPC_KIND" "alchemy"

export ETH_RPC_URL=$ETH_RPC_URL
export DEPLOYMENT_CONTEXT=$file_name_format
export PRIVATE_KEY=$ADMIN_PRIVATE_KEY
export L1_RPC=$ETH_RPC_URL
export RPC_KIND=alchemy

source ~/.bashrc
direnv allow .

mkdir deployments/$file_name_format
forge script scripts/Deploy.s.sol:Deploy --private-key $PRIVATE_KEY --broadcast --rpc-url $ETH_RPC_URL
forge script scripts/Deploy.s.sol:Deploy --sig 'sync()' --private-key $PRIVATE_KEY --broadcast --rpc-url $ETH_RPC_URL

# Run op-node

cd ../../op-node/

go run cmd/main.go genesis l2 \
    --deploy-config ../packages/contracts-bedrock/deploy-config/$file_name_format.json \
    --deployment-dir ../packages/contracts-bedrock/deployments/$file_name_format/ \
    --outfile.l2 genesis.json \
    --outfile.rollup rollup.json \
    --l1-rpc $ETH_RPC_URL

# Set Up op-geth

openssl rand -hex 32 > jwt.txt
cp -n genesis.json ../../op-geth/
cp -n jwt.txt ../../op-geth/
cp -n ../packages/contracts-bedrock/.envrc ../../op-geth/

# Initialize op-geth

cd ../../op-geth/
mkdir datadir
build/bin/geth init --datadir=datadir genesis.json
direnv allow .


# Run op-geth

nohup ./build/bin/geth --datadir ./datadir --http --http.corsdomain="*" --http.vhosts="*" --http.addr=0.0.0.0 --http.api=web3,debug,eth,txpool,net,engine --ws --ws.addr=0.0.0.0 --ws.port=8546 --ws.origins="*" --ws.api=debug,eth,txpool,net,engine --syncmode=full --gcmode=archive --nodiscover --maxpeers=0 --networkid=$CHAIN_ID --authrpc.vhosts="*" --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.jwtsecret=./jwt.txt --rollup.disabletxpoolgossip=true &


# Setting up op-node env
cp -n .envrc ../optimism/op-node/
cd ../optimism/op-node

update_env_variable "SEQ_KEY" "$SEQUENCER_PRIVATE_KEY"
update_env_variable "BATCHER_KEY" "$BATCHER_PRIVATE_KEY"

export SEQ_KEY=$SEQUENCER_PRIVATE_KEY
export BATCHER_KEY=$BATCHER_PRIVATE_KEY

direnv allow .


# Run op-node

nohup ./bin/op-node 	--l2=http://localhost:8551 	--l2.jwt-secret=./jwt.txt 	--sequencer.enabled 	--sequencer.l1-confs=3 	--verifier.l1-confs=3 	--rollup.config=./rollup.json 	--rpc.addr=0.0.0.0 	--rpc.port=8547 	--p2p.disable 	--rpc.enable-admin 	--p2p.sequencer.key=$SEQ_KEY 	--l1=$ETH_RPC_URL 	--l1.rpckind=$RPC_KIND &


# setting up op-batcher
cp -n .envrc ../op-batcher
cd ../op-batcher
direnv allow .

# Run op-batcher

nohup ./bin/op-batcher     --l2-eth-rpc=http://localhost:8545     --rollup-rpc=http://localhost:8547     --poll-interval=1s     --sub-safety-margin=6     --num-confirmations=1     --safe-abort-nonce-too-low-count=3     --resubmission-timeout=30s     --rpc.addr=0.0.0.0     --rpc.port=8548     --rpc.enable-admin     --max-channel-duration=1     --l1-eth-rpc=$L1_RPC     --private-key=$BATCHER_KEY &


# Setting up op-proposer

cp -n .envrc ../op-proposer
cd ../op-proposer

json_file="/var/optimism/packages/contracts-bedrock/deployments/$file_name_format/L2OutputOracleProxy.json"
param_name="address"
l2oo_addr=$(jq -r ".$param_name" "$json_file")

update_env_variable "PROPOSER_KEY" "$PROPOSER_PRIVATE_KEY"
update_env_variable "L2OO_ADDR" "$l2oo_addr"

# sets Propose private key
export PROPOSER_KEY=$PROPOSER_PRIVATE_KEY

# sets address of L2OutputOracleProxy
export L2OO_ADDR=$l2oo_addr

direnv allow .


# Run op-proposer
nohup ./bin/op-proposer     --poll-interval=12s     --rpc.port=8560     --rollup-rpc=http://localhost:8547     --l2oo-address=$L2OO_ADDR     --private-key=$PROPOSER_KEY     --l1-eth-rpc=$L1_RPC &
