<template>
	<div class="hello">
		<button @click="add">login in</button>
	</div>
</template>

<script>
export default {
	 methods: {
	 	add() {
	 		console.log($store.state)
	 	}
	 }
}
</script>
