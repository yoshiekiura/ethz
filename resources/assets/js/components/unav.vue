<template>
	<div class="nav-handle obj-fixed">
		<!--active-->
		<div class="nav-cell text-center lh10" :class="(current == '/') && 'active'">
			<router-link to="/"><i class="fa fa-cube"></i></router-link>
		</div>
		<div class="nav-cell text-center lh10" :class="(current == '/list_project') && 'active'">
			<router-link to="/list_project"><i class="fa fa-tasks"></i></router-link>
		</div>
		<div class="nav-cell text-center lh10"  :class="(current == '/star' || current == '/user') && 'active'">
			<router-link v-if="!user_state.token" to="/star"><i class="fa fa-user-circle"></i></router-link>
			<router-link v-if="user_state.token" to="/user"><i class="fa fa-user-circle"></i></router-link>
		</div>
	</div>
</template>

<script>
import {mapGetters} from 'vuex'
export default {
	data(){
		return {
			current:this.$route.path
		}
	},
	computed:{
		...mapGetters(['user_state'])
	}
}
</script>
