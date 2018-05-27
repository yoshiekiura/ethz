<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		注册
		<div class="color-tip handler right">
			<router-link  to="/login">登录</router-link>
		</div>
	</mhead>
	<div class="ctninner">
		<el-form ref="form" :model="form" class="color-tip fs12" >
			<el-form-item class="p20">
				<label class="el-form-item__label">
					<i class="fa fa-envelope-o"></i>
				</label>
				<el-input v-model="form.mail" placeholder="输入邮箱"></el-input>
			</el-form-item>
			<el-form-item class="p20">
				<label class="el-form-item__label"><i class="fa fa-lock"></i></label>
				<el-input v-model="form.pwd" placeholder="输入密码"></el-input>
			</el-form-item>
			<el-form-item class="p20">
				<label class="el-form-item__label"><i class="fa fa-lock"></i></label>
				<el-input v-model="form.repwd" placeholder="再次输入密码"></el-input>
			</el-form-item>
			<el-form-item class="p20">
				<label class="el-form-item__label"><i class="fa fa-mars"></i></label>
				<el-input v-model="form.invite" placeholder="邀请码"></el-input>
			</el-form-item>
		</el-form>
		<el-button class="full submit" round type="tip" v-loading="!isloaded" @click="regist" >确认注册</el-button>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	mounted(){
		console.log(this.$store.state.count)
	},
	components:{
		mhead
	},
	data(){
		return {
			form: {
				mail:'',
				pwd: '',
				repwd: '',
				invite: ''
			},
			isloaded:true
		}
	},
	methods:{
		regist(){
    		var vm = this;
    		if(vm.form.mail == '') {
				vm.$alert('请输入注册账号', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.form.pwd == '') {
			vm.$alert('请输入密码', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.form.repwd == '') {
			vm.$alert('请输入确认密码', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.form.repwd != vm.form.pwd) {
			vm.$alert('两次密码输入不正确', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.is_post == true) {
    			return false;
    		}
    		vm.is_post = true;
    		vm.isloaded = false;
    		vm.$http.post(vm.commonApi.register, {
    					'email':vm.form.mail,
    					'password':vm.form.pwd,
    					'password_confirmation':vm.form.repwd,
    					'invite':vm.invite,
    				})
    			 	.then(function(response){
    			 		vm.is_post = false;
    					vm.isloaded = true;
    			 		var _data = response.data;
						if(_data.code == 200){
							vm.$alert('注册成功', { confirmButtonText: '确定' });
							vm.user_state = es.data.token
							vm.$router.push('/user');
	        			} else {
	        				this.$alert(_data.message, { confirmButtonText: '确定' });
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
	}
}
</script>

<style>
</style>