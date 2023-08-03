<script>
	import { page } from "$app/stores";
	import logo from "$lib/images/blocktheory.svg";
	import github from "$lib/images/github.svg";
</script>

<header>
	<div>
		<h1 class="text-2xl text-left">Optimisim Op Stack</h1>
	</div>

	<div class="corner">
		<a href="https://github.com/Blocktheory/opstack-setup-script">
			<img src={github} alt="GitHub" />
		</a>
	</div>
</header>

<style>
	header {
		display: flex;
		justify-content: space-around;
	}
</style>
