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
				<div class="avatar img-box"><img src="/img/album1.jpg" /></div>
				<div class="uname color-tip fs20">喵</div>
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
										<p class="fs14">1100</p>
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
								<p class="fs18"><span class="color-tip">9999.99</span></p>
							</div>
						</div>
						<div class="tb-item">
							<div class="lab-item fs12 text-center p0">
								<p class="color-link fs9">获胜次数</p>
								<p class="fs18"><span class="color-tip">123</span></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel">
			<router-link to="/address">
				<div class="panel-bd color-tip">
					<span>钱包</span>
					<span class="pull-right">
						<font class="color-link mr10">0.00 eth</font>
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
			
		}
	},
	methods:{
		submit(){
			var	that = this;
//			that.$emit('lgn-smt',true);
		}
	},
	activated(){
//		var vm = this;
//  	if(!vm.user_state.username){
//  		vm.$router.replace('/star')
//  	}
	}
}
</script>

<style>
</style>