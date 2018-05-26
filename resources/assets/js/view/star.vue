<template>
	<div class="container bg_app1">
		<mhead>
			我的
		</mhead>
		
		<div class="star_logo_wrap">
			<div class="star_logo"><img src="/img/star_logo.png"/></div>
		</div>
		
		<div class="star-btn-wrap clearfix">
			<router-link to="/regist"><el-button type="tip" round>注册</el-button></router-link>
			<router-link to="/login"><el-button class="pull-right" type="tip" round>登录</el-button></router-link>
		</div>
		
		<tip-hc></tip-hc>
		<unav></unav>
	</div>
</template>

<script>
import mhead from '../components/head.vue'
import tipHc from '../components/tip_help_center.vue'
import unav from '../components/unav.vue'
//import {mapGetters} from 'vuex'
export default{
	components:{
		mhead,
		tipHc,
		unav
	},
	data() {
      return {
      
      }
    },
    computed:{
//  	...mapGetters(['user_state'])
    },
    activated(){
//  	var vm = this;
//  	if(vm.user_state.username){
//  		vm.$router.replace('/user')
//  	}
    },
    methods: {
    
    }
}


</script>

<style>
.bg_app1 {
	background-image: url(/img/bg_app.png); background-repeat: repeat; background-position: 0;
}
</style>























