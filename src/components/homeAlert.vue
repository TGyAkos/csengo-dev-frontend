<template>
	<v-alert
		closable
		:title="title"
		:text="message"
		type="info"
		
	/>
</template>

<script>
export default {
	data() {
		return {
			title: "Értesítés",
			message:
				"A szavazási fázis szünetel, kis türelmeteket kérjük! 2023.11.14.",
		};
	},
};
</script>

<style></style>
