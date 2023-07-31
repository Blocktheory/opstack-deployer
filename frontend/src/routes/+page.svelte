<script>
	import welcome from "$lib/images/svelte-welcome.webp";
	import welcome_fallback from "$lib/images/svelte-welcome.png";
</script>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="OP Stack Launch Script" />
</svelte:head>

<section>
	<h1 class="text-2xl">Create your own Blockchain using OP Stack</h1>
	<div class="flex gap-5 w-full">
		<div class="bg-red p-10 w-full md:w-1/2">
			<h2 class="font-bold text-xl mb-4">Configure Rollup</h2>

			<div class="mb-4">
				<label
					class="block text-gray-700 text-sm font-bold mb-2"
					for="chainId"
				>
					Chain ID
				</label>
				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="chainId"
					type="text"
					placeholder="Chain Id"
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
					type="text"
					placeholder="Ex: My OP-Stack Chain"
				/>
			</div>
			<div class="mb-4">
				<label
					class="block text-gray-700 text-sm font-bold mb-2"
					for="blocks"
				>
					Challenge Period Blocks
				</label>
				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="blocks"
					type="text"
					placeholder="Ex: 150, 170"
				/>
			</div>
			<div class="mb-4">
				<label
					class="block text-gray-700 text-sm font-bold mb-2"
					for="staketoken"
				>
					Stake Token
				</label>
				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="staketoken"
					type="text"
					placeholder="ETH, USDC, USDT"
				/>
			</div>
			<div class="mb-4">
				<label
					class="block text-gray-700 text-sm font-bold mb-2"
					for="baseStake"
				>
					Base Stake (in Ether)
				</label>
				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="baseStake"
					type="text"
					placeholder="0.000 ETH"
				/>
			</div>
			<div class="mb-4">
				<label
					class="block text-gray-700 text-sm font-bold mb-2"
					for="owner"
				>
					Owner
				</label>
				<input
					class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
					id="owner"
					type="text"
					placeholder="Owner"
				/>
			</div>
			<div>
				<p>
					Please set the owner address to one which you are
					comfortable exposing private keys for (on your local
					device).
				</p>
			</div>
			<div>
				<button
					class="bg-blue-500 hover:bg-blue-700 w-full text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
					type="button"
				>
					Create
				</button>
			</div>
		</div>
		<div class="bg-blue p-10 w-full md:w-1/2">
			<h2 class="font-bold text-xl">Summary</h2>
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
