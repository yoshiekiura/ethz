<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		充值
	</mhead>
	<div class="ctninner">
		<p class="text-center">0x2012301dsf23sdf12df9309123a</p>
		<div class="qrcode">
			
		</div>
		
		<router-link to="/user"><el-button class="full submit" round >确定</el-button></router-link>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	components:{
		mhead
	},
	data(){
		return {
			
		}
	},
	methods:{
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>