<script>
	import welcome from "$lib/images/svelte-welcome.webp";
	import welcome_fallback from "$lib/images/svelte-welcome.png";
	import { Stepper, Step } from "@skeletonlabs/skeleton";
	import { clipboard } from "@skeletonlabs/skeleton";

	let env_variables = {
		CHAIN_NAME: "",
		CHAIN_ID: "",
		ETH_RPC_URL: "",
		ADMIN_PUBLIC_ADDRESS: "",
		ADMIN_PRIVATE_KEY: "",
		SEQUENCER_PUBLIC_ADDRESS: "",
		SEQUENCER_PRIVATE_KEY: "",
		BATCHER_PUBLIC_ADDRESS: "",
		BATCHER_PRIVATE_KEY: "",
		PROPOSER_PUBLIC_ADDRESS: "",
		PROPOSER_PRIVATE_KEY: "",
	};

	// @ts-ignore
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="OP Stack Launch Script" />
</svelte:head>

<section>
	<h1 class="text-2xl">Optimisim Op Stack</h1>
	<div class="flex gap-5 w-full">
		<div class="bg-red p-10 w-full">
			<div
				class="card p-4 font-semibold text-sm bg-[#FFEED3] text-[#60461F] mb-7"
			>
				All parameters shown are defaults (including some randomly
				generated addresses), which we recommend using for testing
				purposes.
				<br />
				<br />
				More information around parameter customization and guidance can
				be found in the
				<a
					href="https://stack.optimism.io/docs/build/getting-started/#prerequisites"
					target="_blank"
					class="underline">documentation</a
				>.
				<br />
				Please ensure you have at least 1.5 Goerli ETH before getting started.
			</div>
			<h2 class="font-bold text-xl mb-4 text-center">Configure Rollup</h2>

			<Stepper>
				<Step>
					<svelte:fragment slot="header"
						>Initial Setup</svelte:fragment
					>
					<div class="mb-4 w-full">
						<label
							class="block text-gray-700 text-sm font-bold mb-2"
							for="chainId"
						>
							Chain Id
						</label>
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
						<label
							class="block text-gray-700 text-sm font-bold mb-2"
							for="chainName"
						>
							Chain Name
						</label>
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
						<label
							class="block text-gray-700 text-sm font-bold mb-2"
							for="rpc_url"
						>
							Layer 1 RPC Url
						</label>
						<input
							class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
							id="rpc_url"
							name="RPC_URL"
							type="text"
							placeholder="e.g., https://rpc.ankr.com/eth_goerli"
							bind:value={env_variables.ETH_RPC_URL}
						/>
					</div>
				</Step>
				<Step>
					<svelte:fragment slot="header"
						>Configure (Optional)</svelte:fragment
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
							<label
								class="block text-gray-700 text-sm font-semi-bold mb-2 mx-3"
								for="rpc_url"
							>
								Can leave empty and add later
							</label>
						</div>
					</div>
				</Step>
				<Step>
					<svelte:fragment slot="header">Finishing up</svelte:fragment
					>
					<p>Below are the scripts</p>
					<button class="btn variant-filled p-4 bg-slate-400 mb-3">
						Download Scripts
					</button>

					<div>Download File</div>

					<!-- Source -->
					<p class="card p-10" data-clipboard="exampleElement">
						CHAIN_NAME={env_variables.CHAIN_NAME}
						<br />
						CHAIN_ID={env_variables.CHAIN_ID}
						<br />
						ETH_RPC_URL={env_variables.CHAIN_ID}
						<br />
						ADMIN_PUBLIC_ADDRESS={env_variables.ADMIN_PUBLIC_ADDRESS}
						<br />
						ADMIN_PRIVATE_KEY={env_variables.ADMIN_PRIVATE_KEY}
						<br />
						SEQUENCER_PUBLIC_ADDRESS={env_variables.SEQUENCER_PUBLIC_ADDRESS}
						<br />
						SEQUENCER_PRIVATE_KEY={env_variables.SEQUENCER_PRIVATE_KEY}
						<br />
						BATCHER_PUBLIC_ADDRESS={env_variables.BATCHER_PUBLIC_ADDRESS}
						<br />
						BATCHER_PRIVATE_KEY={env_variables.BATCHER_PRIVATE_KEY}
						<br />
						PROPOSER_PUBLIC_ADDRESS={env_variables.PROPOSER_PUBLIC_ADDRESS}
						<br />
						PROPOSER_PRIVATE_KEY={env_variables.PROPOSER_PRIVATE_KEY}
					</p>

					<!-- Trigger -->
					<button
						class="btn variant-filled"
						use:clipboard={{ element: "exampleElement" }}
						>Copy</button
					>
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
