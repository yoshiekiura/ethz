<template>
<div id="app">
	<!--@lgn-smt='isLogin'-->
	<!--<login-page v-if="!login.status" ></login-page>-->
	<keep-alive>
		<router-view></router-view>
	</keep-alive>
</div>
</template>

<script>
import jwtToken from './helpers/jwt'
import {mapGetters} from 'vuex'	
export default {
	 computed:{
	 	...mapGetters(['user_state']),
	 	token(){
	 		let vm = this;
	 		console.log(vm.user_state.token);
	 		return vm.user_state.token
	 	}
	 },
	created(){
		let vm = this;
		let enter_path = vm.$route.path;
//		jwtToken.removeToken();
		let local_state = jwtToken.getUserState();
		if(local_state) {
			vm.$store.dispatch('setUserState', local_state);
		}
		
//		console.log(local_state, vm.user_state)
		if(!vm.user_state.token){
			if(enter_path !=  '/' || enter_path != '/list_project' || enter_path != '/star' || enter_path != '/login' || enter_path != '/regist' || enter_path != '/reback') {
				vm.$router.replace('/star');
			}
		}else{
			if(enter_path ==  '/star' || enter_path == '/login' || enter_path == '/regist' ){
				vm.$router.replace('/user')
			}
		}
		
		vm.$router.beforeEach((to, from, next) => {
			let _path_ = to.path;
			if(!vm.user_state.token){
				if(_path_ ==  '/' || _path_ == '/list_project' || _path_ == '/star' || _path_ == '/login' || _path_ == '/regist' || _path_ == '/reback'){
					return next()
				}else {
					return next('/star')
				}
			}else{
				if(_path_ ==  '/star' || _path_ == '/login' || _path_ == '/regist' ){
					return next('/user')
				}else{
					return next();
				}
			}
		})
	},
	mounted(){		//替代ready方法
		let vm = this
		documentResetFontSize()
		window.onresize = () => {		//挂载一个window.resize的方法, 元素改变的时候改变
			return (() => {
				window.screenWidth = document.body.clientWidth
				vm.screenWidth = window.screenWidth
			})()
		}
		
	},
 	name: 'app',
 	components:{
	//	'login-page':Lgn
	},
	data(){
	  	return {
	  		login:{
	  			status:false
	  		},
	  		screenWidth:document.body.clientWidth	//定义一个默认值, 让vue监听
	  	}
	},
	watch:{
		screenWidth (val) {
			if(!this.timer){
				this.screenWidth = val
				this.timer = true
				let that = this
				setTimeout(function(){
					documentResetFontSize();
					that.timer = false;
				},500)
			}
		}
	},
	methods:{
//		isLogin(msg){
//			console.log(msg,546546)
//		}
	}
  
}

//窗口reset大小, 当窗口640时字体为100px;
function documentResetFontSize(){
	var maxWidth = 720;
	var clientWidth = document.documentElement.clientWidth
	clientWidth = clientWidth >= maxWidth? maxWidth : clientWidth;
	document.documentElement.style.fontSize = clientWidth / 7.2 + 'px';
}
</script>

