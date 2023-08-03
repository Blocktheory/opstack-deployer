<script>
	import { Stepper, Step } from "@skeletonlabs/skeleton";
	import { clipboard } from "@skeletonlabs/skeleton";
	import Info from "$lib/images/info.svg";
	import Downloadfile from "$lib/components/Downloadfile.svelte";
	import InfoContent from "../lib/components/InfoContent.svelte";
	import { CodeBlock } from "@skeletonlabs/skeleton";

	let env_variables = {
		CHAIN_NAME: "",
		CHAIN_ID: "",
		ETH_RPC_URL: "",
		ETH_RPC_KIND: "",
		ADMIN_PUBLIC_ADDRESS: "",
		ADMIN_PRIVATE_KEY: "",
		SEQUENCER_PUBLIC_ADDRESS: "",
		SEQUENCER_PRIVATE_KEY: "",
		BATCHER_PUBLIC_ADDRESS: "",
		BATCHER_PRIVATE_KEY: "",
		PROPOSER_PUBLIC_ADDRESS: "",
		PROPOSER_PRIVATE_KEY: "",
	};

	let donwloadScript = () => {
		return `
	CHAIN_NAME=${env_variables.CHAIN_NAME}
	CHAIN_ID=${env_variables.CHAIN_ID}
	ETH_RPC_URL=${env_variables.ETH_RPC_URL}
	ETH_RPC_URL=${env_variables.ETH_RPC_KIND}
	ADMIN_PUBLIC_ADDRESS=${env_variables.ADMIN_PUBLIC_ADDRESS}
	ADMIN_PRIVATE_KEY=${env_variables.ADMIN_PRIVATE_KEY}
	SEQUENCER_PUBLIC_ADDRESS=${env_variables.SEQUENCER_PUBLIC_ADDRESS}
	SEQUENCER_PRIVATE_KEY=${env_variables.SEQUENCER_PRIVATE_KEY}
	BATCHER_PUBLIC_ADDRESS=${env_variables.BATCHER_PUBLIC_ADDRESS}
	BATCHER_PRIVATE_KEY=${env_variables.BATCHER_PRIVATE_KEY}
	PROPOSER_PUBLIC_ADDRESS=${env_variables.PROPOSER_PUBLIC_ADDRESS}
	PROPOSER_PRIVATE_KEY=${env_variables.PROPOSER_PRIVATE_KEY}`;
	};

	$: lockedStep1 = !(
		env_variables.CHAIN_ID.trim() !== "" &&
		env_variables.CHAIN_NAME.trim() !== "" &&
		env_variables.ETH_RPC_URL.trim() !== ""
	);
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="OP Stack Launch Script" />
</svelte:head>

<section>
	<div class="flex gap-5 w-full">
		<div class="bg-red p-10 w-full">
			<div
				class="card p-4 font-semibold text-sm bg-[#FFEED3] text-[#60461F] mb-7"
			>
				Launch OP Stack Chain
				<br /><br />
				Use below interface and kick off your chain on OPStack. This interface
				is currently intended to help launching L2 chain based on OP stack.
				Find more details
				<a
					href="https://github.com/Blocktheory/opstack-setup-script"
					target="_blank"
					class="underline">here</a
				>.
				<br />
			</div>
			<h2 class="font-bold text-xl mb-4 text-center">Configure Rollup</h2>

			<Stepper start={2}>
				<Step locked={lockedStep1}>
					<svelte:fragment slot="header"
						>Initial Setup</svelte:fragment
					>
					<div class="mb-4 w-full">
						<div class="flex">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="chainId"
							>
								Chain Id
								<sup class="text-md text-red-600">*</sup>
							</label>
							<InfoContent content="this is Chain ID" />
						</div>
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
							id="chainId"
							name="CHAINID"
							bind:value={env_variables.CHAIN_ID}
							type="text"
							placeholder="e.g., 8691"
						/>
					</div>
					<div class="mb-4">
						<div class="flex">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="chainName"
							>
								Chain Name
								<sup class="text-md text-red-600">*</sup>
							</label>
							<InfoContent
								content="What you would like to call your new chain"
							/>
						</div>
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
							id="chainName"
							name="chainName"
							type="text"
							placeholder="e.g., Blocktheory"
							bind:value={env_variables.CHAIN_NAME}
						/>
					</div>
					<div class="mb-4">
						<div class="flex">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="rpc_url"
							>
								Layer 1 RPC Url
								<sup class="text-md text-red-600">*</sup>
							</label>
							<InfoContent
								content="The layer 1 chain RPC end point"
							/>
						</div>
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
							id="rpc_url"
							name="RPC_URL"
							type="text"
							placeholder="e.g., https://rpc.ankr.com/eth_goerli"
							bind:value={env_variables.ETH_RPC_URL}
						/>
					</div>
					<div class="mb-4">
						<div class="flex">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="rpc_kind"
							>
								Layer 1 RPC Kind
								<sup class="text-md text-red-600">*</sup>
							</label>
							<InfoContent
								content="The kind of RPC URL you are using"
							/>
						</div>
						<select class="select bg-white">
							<option>Alchemy</option>
							<option>Quicknode</option>
							<option>Parity</option>
							<option>Nethermind</option>
							<option> Debug_geth</option>
							<option> Erigon</option>
							<option> Basic</option>
							<option> Any </option>
						</select>
					</div>
				</Step>
				<Step>
					<svelte:fragment slot="header"
						>Setup Wallets (Optional)</svelte:fragment
					>
					<div class=" card p-5 mb-3">
						<!-- owner -->

						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="adminpa"
							>
								Admin Public Address
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="adminpa"
								name="adminpa"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.ADMIN_PUBLIC_ADDRESS}
							/>
						</div>
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="adminpvtkey"
							>
								Admin Private Key
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="adminpvtkey"
								name="adminpvtkey"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.ADMIN_PRIVATE_KEY}
							/>
						</div>
						<p class="text-sm text-gray-700">
							Recommended ETH for Admin is <b>2 ETH</b>
						</p>
					</div>
					<div class=" card p-5 mb-3">
						<!-- Sequencer -->
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="sequencerpa"
							>
								Sequencer Public Address
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="sequencerpa"
								name="sequencerpa"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.SEQUENCER_PUBLIC_ADDRESS}
							/>
						</div>
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="sequencerpvtkey"
							>
								Sequencer Private Key
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="sequencerpvtkey"
								name="sequencerpvtkey"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.SEQUENCER_PRIVATE_KEY}
							/>
						</div>
					</div>
					<div class=" card p-5 mb-3">
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="batcherpa"
							>
								Batcher Public Address
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="batcherpa"
								name="batcherpa"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.BATCHER_PUBLIC_ADDRESS}
							/>
						</div>
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="batcherpvtkey"
							>
								Batcher Private Key
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="batcherpvtkey"
								name="batcherpvtkey"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.BATCHER_PRIVATE_KEY}
							/>
						</div>
						<p class="text-sm text-gray-700">
							Recommended ETH for Batcher is <b>10 ETH</b>
						</p>
					</div>
					<div class=" card p-5 mb-3">
						<!-- Proposer block -->
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="proposerpa"
							>
								Proposer Public Address
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="proposerpa"
								name="proposerpa"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.PROPOSER_PUBLIC_ADDRESS}
							/>
						</div>
						<div class="mb-4">
							<label
								class="block text-gray-700 text-sm font-bold mb-2"
								for="proposerpvtkey"
							>
								Proposer Private Key
							</label>
							<input
								class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
								id="proposerpvtkey"
								name="proposerpvtkey"
								type="text"
								placeholder="e.g, 0x06...7A7B"
								bind:value={env_variables.PROPOSER_PRIVATE_KEY}
							/>
						</div>
						<p class="text-sm text-gray-700">
							Recommended ETH for Proposer is <b>5 ETH</b>
						</p>
					</div>
				</Step>
				<Step>
					<svelte:fragment slot="header">Finishing up</svelte:fragment
					>
					<p class="text-lg text-gray-700 font-bold">Instructions</p>
					<p class="text-lg text-gray-700 font-semibold">Step 1</p>
					<p class="text-md">Hardware Requirments</p>
					<div class="card p-4">
						Linux ubuntu 20.04 LTS
						<br /> Min. 8GB RAM & 4 Core CPU
						<br />
						Storage 250GB or more
					</div>
					<p class="text-lg text-gray-700 font-semibold">
						You can use any cloud services like Digital Ocean, AWS,
						Google Cloud, etc.,
					</p>
					<!-- <Downloadfile
						fileName="inital.sh"
						fileURL="https://ds-storage.sgp1.cdn.digitaloceanspaces.com/blocktheory/op-script/initial.sh"
					/> -->
					<!-- <a
						href={"https://ds-storage.sgp1.cdn.digitaloceanspaces.com/blocktheory/op-script/initial.sh"}
						class="btn variant-filled p-4 bg-slate-400 mb-3"
						download="inital.sh"
					>
						Download Intial Script
					</a> -->
					<p class="text-lg text-gray-700 font-semibold">Step 2</p>
					<p class="text-md">Clone the repository</p>

					<CodeBlock
						language="bash"
						code={`
					git clone https://github.com/Blocktheory/opstack-setup-script \n// navigate to the deploy script folder\ncd opstack-setup-script/deploy-scripts\n
					`}
					/>
					<!-- <a
						href={"https://ds-storage.sgp1.cdn.digitaloceanspaces.com/blocktheory/op-script/setup.sh"}
						class="btn variant-filled p-4 bg-slate-400 mb-3"
						download="setup.sh"
					>
						Download Setup Script
					</a> -->
					<p>
						Create your environment file with following keys, you
						can use command nano .env or vim .env to create it

						<!-- Source -->
					</p>
					<CodeBlock
						language="bash"
						code={`
					CHAIN_NAME=${env_variables.CHAIN_NAME}\nCHAIN_ID=${env_variables.CHAIN_ID}\nETH_RPC_URL=${env_variables.ETH_RPC_URL} \nRPC_KIND=${env_variables.ETH_RPC_KIND}			\nADMIN_PUBLIC_ADDRESS=${env_variables.ADMIN_PUBLIC_ADDRESS}				\nADMIN_PRIVATE_KEY=${env_variables.ADMIN_PRIVATE_KEY}		\nSEQUENCER_PUBLIC_ADDRESS=${env_variables.SEQUENCER_PUBLIC_ADDRESS}	\nSEQUENCER_PRIVATE_KEY=${env_variables.SEQUENCER_PRIVATE_KEY}					\nBATCHER_PUBLIC_ADDRESS=${env_variables.BATCHER_PUBLIC_ADDRESS}			\nBATCHER_PRIVATE_KEY=${env_variables.BATCHER_PRIVATE_KEY}				\nPROPOSER_PUBLIC_ADDRESS=${env_variables.PROPOSER_PUBLIC_ADDRESS}			\nPROPOSER_PRIVATE_KEY=${env_variables.PROPOSER_PRIVATE_KEY}
					`}
					/>
					<p class="text-lg text-gray-700 font-semibold">Step 3</p>
					<p class="text-md">
						Once you've created the environemnt file inside the
						deploy-scripts folder, You can run the initial scripts
						with command
					</p>

					<CodeBlock
						language="bash"
						code={`
							bash ./initial.sh\n or\n./initial.sh
						`}
					/>
					<p class="mb-0 pb-0">script initial.sh performs</p>
					<ol class="mb-0 pt-0">
						<li>- Installs the necessary dependencies</li>
						<li>- Creates the necessary directories Downloads</li>
						<li>- The OP Stack Code</li>
					</ol>
					<p class="" />
					<p class="text-md">
						Once initial.sh script runs successfully,
						<br />
						We can refresh the terminal using
						<code class="card p-2"> source ~/.bashrc</code>
						<br />
						Then we can run the setup / final script with below command
					</p>
					<CodeBlock
						language="bash"
						code={`
					bash ./setup.sh\nor\n./setup.sh
					`}
					/>

					<p>script setup.sh</p>
					<ul>
						<li>- Performs Initializes the OP Stack Starts</li>
						<li>- The OP Stack</li>
					</ul>
					<p class="font-semibold">L2 Chain Deployed Successfully</p>
					<p>
						Once the script runs successfully you can now see the
						new chain up and running in the port 8545. You can
						access it by using the RPC end points as <code
							>host:8454</code
						>
						along with chain id used earlier while running the script.
						The best way to submit feedback and report bugs is to
						<a
							href="https://github.com/Blocktheory/opstack-setup-script/issues"
							class="underline">open a GitHub issue</a
						><br /> <br /> For more details refer:
						<a
							href="https://stack.optimism.io/#dive-deeper-into-the-op-stack"
							class="underline">Opstack Offical Docs</a
						>
					</p>
				</Step>
			</Stepper>

			<!-- <form on:submit|preventDefault={createFile}>
				<div>
					<button
						class="bg-blue-500 hover:bg-blue-700 w-full text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
						type="submit"
					>
						Create
					</button>
				</div>
			</form> -->
		</div>
	</div>
</section>

<style>
	section {
		display: flex;
		flex-direction: column;
		/* justify-content: center; */
		align-items: center;
		flex: 0.6;
	}

	h1 {
		width: 100%;
	}

	h2 {
		width: 100%;
		font-weight: 500;
	}
</style>
