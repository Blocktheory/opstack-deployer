#!/bin/bash

# Enable "exit on error" and "pipefail" mode
set -eo pipefail

chain_name="blocktheory"
output_location="/var/optimism/packages/contracts-bedrock/deploy-config/"
eth_rpc_url="https://eth-goerli.g.alchemy.com/v2/4twDaZ1szgaV3gpcG1scbEPMVTp8hTqh"
admin_public_address=""
admin_private_key=""
sequencer_public_address=""
sequencer_private_key=""
batcher_public_address=""
batcher_private_key=""
proposer_public_address=""
proposer_private_key=""


while getopts ":n:i:a:A:s:S:b:B:p:P:" opt; do
  case $opt in
         n) chain_name="$OPTARG";;
        i) chain_id="$OPTARG";;
        a) admin_public_address="$OPTARG";;
        A) admin_private_key="$OPTARG";;
        s) sequencer_public_address="$OPTARG";;
        S) sequencer_private_key="$OPTARG";;
        b) batcher_public_address="$OPTARG";;
        B) batcher_private_key="$OPTARG";;
        p) proposer_public_address="$OPTARG";;
        P) proposer_private_key="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2
        exit 1
        ;;
    :) echo "Option -$OPTARG requires an argument." >&2
       exit 1
       ;;
  esac
done

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
export ETH_RPC_URL="$eth_rpc_url"


output=$(cast block finalized --rpc-url $ETH_RPC_URL | grep -E "(timestamp|hash|number)")

blockhash=$(echo "$output" | awk '/hash/ {print $2}')
number_value=$(echo "$output" | awk '/number/ {print $2}')
timestamp=$(echo "$output" | awk '/timestamp/ {print $2}')

json_data=$(cat <<EOF
{
  "numDeployConfirmations": 1,

  "finalSystemOwner": "$admin_public_address",
  "portalGuardian": "$admin_public_address",
  "controller": "$admin_public_address",

  "l1StartingBlockTag": "$blockhash",

  "l1ChainID": 5,
  "l2ChainID": 42069,
  "l2BlockTime": 2,

  "maxSequencerDrift": 600,
  "sequencerWindowSize": 3600,
  "channelTimeout": 300,

  "p2pSequencerAddress": "$sequencer_public_address",
  "batchInboxAddress": "0xff00000000000000000000000000000000042069",
  "batchSenderAddress": "$batcher_public_address",

  "l2OutputOracleSubmissionInterval": 120,
  "l2OutputOracleStartingBlockNumber": 0,
  "l2OutputOracleStartingTimestamp": $timestamp,

  "l2OutputOracleProposer": "$proposer_public_address",
  "l2OutputOracleChallenger": "$admin_public_address",

  "finalizationPeriodSeconds": 12,

  "proxyAdminOwner": "$admin_public_address",
  "baseFeeVaultRecipient": "$admin_public_address",
  "l1FeeVaultRecipient": "$admin_public_address",
  "sequencerFeeVaultRecipient": "$admin_public_address",

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
  "governanceTokenOwner": "$admin_public_address",

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

file_name_format=$(create_file_name_format "$chain_name")

echo "$json_data" > "$output_location/$file_name_format.json"

cd packages/contracts-bedrock/
cp .envrc.example .envrc


# Function to load .envrc files in a directory and its subdirectories
load_envrc_file() {
    local dir="$1"
    local envrc_file="$dir/.envrc"

    if [ -f "$envrc_file" ]; then
        echo "Loading environment variables from: $envrc_file"
        source "$envrc_file"
    fi

}

load_envrc_file "$(pwd)"

export ETH_RPC_URL=$eth_rpc_url
export DEPLOYMENT_CONTEXT=$file_name_format
export PRIVATE_KEY=$admin_private_key
export L1_RPC=https://eth-goerli.g.alchemy.com/v2/4twDaZ1szgaV3gpcG1scbEPMVTp8hTqh
export RPC_KIND=alchemy

source ~/.bashrc

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
    --l1-rpc $eth_rpc_url

# Set Up op-geth

openssl rand -hex 32 > jwt.txt
cp genesis.json ../../op-geth/
cp jwt.txt ../../op-geth/
cp ../packages/contracts-bedrock/.envrc ../../op-geth/

# Initialize op-geth

cd ../../op-geth/
mkdir datadir
build/bin/geth init --datadir=datadir genesis.json
direnv allow .


# Run op-geth

nohup ./build/bin/geth --datadir ./datadir --http --http.corsdomain="*" --http.vhosts="*" --http.addr=0.0.0.0 --http.api=web3,debug,eth,txpool,net,engine --ws --ws.addr=0.0.0.0 --ws.port=8546 --ws.origins="*" --ws.api=debug,eth,txpool,net,engine --syncmode=full --gcmode=archive --nodiscover --maxpeers=0 --networkid=42069 --authrpc.vhosts="*" --authrpc.addr=0.0.0.0 --authrpc.port=8551 --authrpc.jwtsecret=./jwt.txt --rollup.disabletxpoolgossip=true &


# Setting up op-node env
cp .envrc ../optimism/op-node/
cd ../optimism/op-node

load_envrc_file "$(pwd)"

export SEQ_KEY=$sequencer_private_key
export BATCHER_KEY=$batcher_private_key

direnv allow .


# Run op-node

nohup ./bin/op-node 	--l2=http://localhost:8551 	--l2.jwt-secret=./jwt.txt 	--sequencer.enabled 	--sequencer.l1-confs=3 	--verifier.l1-confs=3 	--rollup.config=./rollup.json 	--rpc.addr=0.0.0.0 	--rpc.port=8547 	--p2p.disable 	--rpc.enable-admin 	--p2p.sequencer.key=$SEQ_KEY 	--l1=https://eth-goerli.g.alchemy.com/v2/4twDaZ1szgaV3gpcG1scbEPMVTp8hTqh 	--l1.rpckind=$RPC_KIND &


# setting up op-batcher
cp .envrc ../op-batcher
cd ../op-batcher
direnv allow .

# Run op-batcher

nohup ./bin/op-batcher     --l2-eth-rpc=http://localhost:8545     --rollup-rpc=http://localhost:8547     --poll-interval=1s     --sub-safety-margin=6     --num-confirmations=1     --safe-abort-nonce-too-low-count=3     --resubmission-timeout=30s     --rpc.addr=0.0.0.0     --rpc.port=8548     --rpc.enable-admin     --max-channel-duration=1     --l1-eth-rpc=$L1_RPC     --private-key=$BATCHER_KEY &


# Setting up op-proposer

cp .envrc ../op-proposer
cd ../op-proposer

json_file="/var/optimism/packages/contracts-bedrock/deployments/$file_name_format/L2OutputOracleProxy.json"
param_name="address"
l2oo_addr=$(jq -r ".$param_name" "$json_file")

load_envrc_file "$(pwd)"

# sets Propose private key
export PROPOSER_KEY=$proposer_private_key

# sets address of L2OutputOracleProxy
export L2OO_ADDR=$l2oo_addr

direnv allow .


# Run op-proposer

nohup ./bin/op-proposer     --poll-interval=12s     --rpc.port=8560     --rollup-rpc=http://localhost:8547     --l2oo-address=$L2OO_ADDR     --private-key=$PROPOSER_KEY     --l1-eth-rpc=$L1_RPC &
