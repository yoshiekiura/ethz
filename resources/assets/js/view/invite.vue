<template>
<div class="container invite-page">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		<span>邀请好友</span>
	</mhead>
	<div class="ctninner">
		<div class="logs">
			<span class="s">一夜致富</span>
			<span class="l">不是梦</span>
		</div>
		<div class="tips text-center mb20">
			<p class="fs14">复制链接,邀请你好友一同加入</p>
		</div>
		<el-form ref="form" :model="form" class="color-tip fs12" >
			<el-form-item class="p20">
				<el-input v-model="inviteUrl" readonly></el-input>
			</el-form-item>
		</el-form>
		
		<div class="submit-wrap" v-loading="!isloaded">
			<el-button @click="submit" class="full submit" round >
				<i class="fa fa-link mr10 fs16" style="vertical-align: -2px;"></i>
				复制链接
			</el-button>
		</div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
import {mapGetters} from 'vuex'
export default{
	components:{
		mhead
	},
	computed:{
		...mapGetters(['user_state']),
		inviteUrl(){
			console.log(this.$route)
			return window.location.host + '?invitor=' + this.user_state.invitecode;
		}
	},
	data(){
		return {
			form: {
				mail:''
			},
			isloaded:true
		}
	},
	mounted(){
		var vm = this;
		console.log(vm.user_state);
	},
	methods:{
		submit(){
			var	vm = this;
			
		},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>