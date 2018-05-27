<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		充值
	</mhead>
	<div class="ctninner">
		<p class="text-center">{{address.address}}</p>
		<div class="qrcode">
			<img :src="address.qrcodeUrl">
		</div>
		
		<div class="submit-wrap">
			<router-link to="/user"><el-button class="full submit" round >确定</el-button></router-link>
		</div>
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
			code:'',
			address:[]
		}
	},
    activated(){
    	var vm = this
    	vm.getAddress()
    },
	methods:{
		getAddress(){
    		var vm = this
    		vm.code = vm.$route.query.code;
    		vm.$http.get(vm.commonApi.depositsAddress,
    			{params:{code:vm.code}}).then(function(response){
		 		if(response.body.code == 200) {
		 			vm.address = response.body.data
		 		}
        	})
    	},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>