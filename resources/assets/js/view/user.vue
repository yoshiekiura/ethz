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
				<div class="avatar img-box"><img :src="user_state.avatar" /></div>
				<div class="uname color-tip fs20">{{user_state.username}}</div>
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
										<p class="fs14">{{user_state.friendsamount}}</p>
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
								<p class="fs20"><span class="color-tip">{{user_state.earnings || 0}}</span></p>
								<p class="color-link fs9">累计收益</p>
							</div>
						</div>
						<div class="tb-item">
							<div class="lab-item fs12 text-center p0">	
								<p class="fs20"><span class="color-tip">{{user_state.wins || 0}}</span></p>
								<p class="color-link fs9">获胜次数</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel" v-if="user_state.wallet">
			<router-link v-for="(item, index) in user_state.wallet" :key="index" :to="{ path: '/address', query:{code: item.code} }">
				<div class="panel-bd color-tip">
					<span>{{item.code}} 钱包</span>
					<span class="pull-right">
						<font class="color-link mr10">{{item.amount}} {{item.code}}</font>
					</span>
				</div>
			</router-link>
		</div>
		<div class="panel" v-if="!user_state.wallet">
			<div class="panel-bd text-center">
				您还没绑定钱包 ! <span class="color-tip">赶紧去绑定吧</span>
			</div>
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
import {mapGetters} from 'vuex'
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
		...mapGetters(['user_state'])
	},
	data(){
		return {
//			user:[],
//			wallet:[]
		}
	},
	methods:{
//		userInfo(){
//  		var vm = this;
//  		vm.$http.get(vm.commonApi.user).then(function(response){
//  			console.log(response.body)
//		 		if(response.body.code == 200) {
//		 			vm.user = response.body.data
//		 			vm.wallet = vm.user.wallet
//		 		}
//      	})
//  	},
		goback(){
			this.$router.go(-1)
		}
	},
	activated(){
		var vm = this;
	 	 if(!vm.user_state.token){
	 	 	vm.$router.replace('/star')
	 	 }
	}
}
</script>

<style>
</style>