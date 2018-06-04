<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		充值
	</mhead>
	<div class="ctninner">
		<div class="qrcode" v-loading = '!address.qrcodeUrl'>
			<img :src="address.qrcodeUrl">
		</div>
		<el-form class="color-tip fs12 w500 mt40 m-auto" >
			<el-form-item class="p20">
				<el-input v-model="address.address" readonly></el-input>
			</el-form-item>
		</el-form>
		<div class="submit-wrap w500 m-auto">
			<el-button class="full submit" round @click="clip">
				<i class="fa fa-link mr10 fs16" style="vertical-align: -2px;"></i>
				复制地址
			</el-button>
			<router-link :to='{path:"/withdraw", query:{code:code}}'><el-button class="full submit" round type="tip">提现</el-button></router-link>
		</div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
import clipboard from 'clipboard-js'
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
    	clip(){
    		var vm = this;
    		if(vm.address){
    			clipboard.copy(vm.address.address).then(function(){
    				vm.$alert('复制成功', { confirmButtonText: '确定' });
    			})
    		}
    	},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>