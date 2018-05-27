<template>
<div class="container">
	<mhead>
		我的
		<div class="color-tip handler right">
			<router-link to="/setting"><i class="fa fa-cog fs18"></i></router-link>
		</div>
	</mhead>
	<div class="ctninner">
		<div class="unav mb30">
			<div class="inner">
				<div class="avatar img-box"><img :src="user.avatar" /></div>
				<div class="uname color-tip fs20">{{user.name}}</div>
			</div>
		</div>
		<div class="panel">
			<div class="panel-bd clearfix text-center">
				<div class="labtb">
					<div class="tr-item">
						<div class="tb-item">
							<router-link to="/list_friends">
								<div class="lab-item fs12 text-left color-tip">
									<i class="fa fa-users pull-left fs16"></i>
									<div class="info">
										<p class="fs14">{{user.invite_count}}</p>
										<p class="color-link">好友</p>
									</div>
								</div>
							</router-link>
						</div>
						<div class="tb-item">
							<router-link to="/invite">
								<div class="lab-item fs12 text-left color-tip">
									<i class="fa fa-user-plus pull-left fs16"></i>
									<div class="info">
										邀请好友
									</div>
								</div>
							</router-link>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel">
			<div class="panel-bd clearfix text-center">
				<div class="labtb">
					<div class="tr-item">
						<div class="tb-item">
							<div class="lab-item fs12 text-center p0">
								<p class="color-link fs9">累计收益</p>
								<p class="fs18"><span class="color-tip">{{user.earnings_count}}</span></p>
							</div>
						</div>
						<div class="tb-item">
							<div class="lab-item fs12 text-center p0">
								<p class="color-link fs9">获胜次数</p>
								<p class="fs18"><span class="color-tip">{{user.win_count}}</span></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel" v-if="wallet.length > 0">
			<router-link :to="{ path: '/address', query:{code: item.code} }" v-for="item in wallet" :key="item.id">
				<div class="panel-bd color-tip">
					<span>{{item.code}} 钱包</span>
					<span class="pull-right">
						<font class="color-link mr10">{{item.amount}} {{item.code}}</font>
					</span>
				</div>
			</router-link>
		</div>
		<tip-hc></tip-hc>
	</div>
	<mnav></mnav>
</div>
</template>

<script>
import mhead from '../components/head.vue'
import mnav from '../components/unav.vue'
import tipHc from '../components/tip_help_center.vue'
//import {mapGetters} from 'vuex'
export default{
	mounted(){
//		console.log(this.$store.state.count)
	},
	components:{
		mhead,
		tipHc,
		mnav
	},
	computed:{
//		...mapGetters(['user_state'])
	},
	data(){
		return {
			user:[],
			wallet:[]
		}
	},
	methods:{
		userInfo(){
    		var vm = this;
    		vm.$http.get(vm.commonApi.user).then(function(response){
    			console.log(response.body)
		 		if(response.body.code == 200) {
		 			vm.user = response.body.data
		 			vm.wallet = vm.user.wallet
		 		}
        	})
    	},
	    message(_content, _type) { // success, warning, 
    		var vm = this;
			vm.isloaded = true;
	        this.$alert(_content, '', { confirmButtonText: '关闭' });
	    },
	    alert(_content) {
    		var vm = this;
			vm.isloaded = true;
	        this.$alert(_content, '', { confirmButtonText: '关闭' });
	    },
		goback(){
			this.$router.go(-1)
		}
	},
	activated(){
		this.userInfo()
	 	// if(!vm.user_state.username){
	 	// 	vm.$router.replace('/star')
	 	// }
	}
}
</script>

<style>
</style>