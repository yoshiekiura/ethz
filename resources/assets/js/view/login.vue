<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		登录
		<div class="color-tip handler right">
			<router-link  to="/regist">注册</router-link>
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
			<el-form-item class="p20 enctrl">
				<label class="el-form-item__label"><i class="fa fa-lock"></i></label>
				<el-input v-model="form.pwd" placeholder="输入密码"></el-input>
				<a class="handler color-link">忘记密码</a>
			</el-form-item>
		</el-form>
		<div class="submit-wrap mt200 mb10 plr20" v-loading="!isloaded" ><el-button @click="loginSubmit" class="full submit fs14" type="primary">登录</el-button></div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
import jwtToken from '../helpers/jwt'
export default{
	components:{
		mhead,
		jwtToken
	},
	data(){
		return {
			form: {
				mail:'',
				pwd: ''
			},
			isloaded:true
		}
	},
	methods:{
		submit(){
			var	vm = this;

	    	vm.$store.dispatch('setUserState', {
	    		username:'hahahah',
				statius:1,
				cc:'hhh'
	    	});

	    	vm.$router.push('/user');
		},
		loginSubmit(){
    		var vm = this;
    		if(vm.form.mail == ''){
    			this.$alert('请填写用登录邮箱', { confirmButtonText: '确定' });
    			return;
    		}

    		if(vm.form.pwd == ''){
    			this.$alert('请填写用登录密码', { confirmButtonText: '确定' });
    			return;
    		}
    		vm.isloaded = false;
    		this.$http.post(vm.commonApi.login ,{
    			account:vm.form.mail,
    			password:vm.form.pwd
    		}).then(function(response){
    			var res = response.body;
    			vm.isloaded = true;
    			if(res.data.token){
    				jwtToken.setToken(res.data.token);
                    vm.$router.push('/user');
    			}else{
    				this.$alert(res.message, { confirmButtonText: '确定' });
    			}
    		}).catch(function(){
    			vm.isloaded = true;
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