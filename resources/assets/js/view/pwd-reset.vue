<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		修改密码
	</mhead>
	<div class="ctninner">
		<el-form ref="form" :model="form" class="color-tip fs12" >
			<el-form-item class="p20">
				<el-input v-model="form.oldpwd" type="password" placeholder="输入旧密码"></el-input>
			</el-form-item>
			<el-form-item class="p20 enctrl">
				<el-input v-model="form.newpwd" v-if="pwdview" placeholder="输入新密码"></el-input>
				<a class="handler color-link fs16" v-if="pwdview" @click="pwdview = !pwdview"><i class="fa fa-eye"></i></a>
				<el-input v-model="form.newpwd" v-if="!pwdview" type="password" placeholder="输入新密码"></el-input>
				<a class="handler color-link fs16" v-if="!pwdview" @click="pwdview = !pwdview"><i class="fa fa-eye-slash"></i></a>
			</el-form-item>
		</el-form>
		<el-button class="full submit" round type="tip" v-loading="!isloaded" @click="restpwd" >确定</el-button>
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
			form: {
				oldpwd:'',
				newpwd: ''
			},
			pwdview:false,
			is_post:false,
			isloaded:true
		}
	},
	methods:{
		restpwd(){
    		var vm = this;
    		if(vm.form.oldpwd == '') {
			vm.$alert('请输入密码', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.form.newpwd == '') {
			vm.$alert('请输入新密码', { confirmButtonText: '确定' });
    			return false;
    		}
    		if(vm.is_post == true) {
    			return false;
    		}
    		vm.is_post = true;
    		vm.isloaded = false;
    		vm.$http.post(vm.commonApi.passwordReset, {
    					'password_old':vm.form.oldpwd,
    					'password':vm.form.newpwd,
    					'password_confirmation':vm.form.newpwd,
    				})
    			 	.then(function(response){
    			 		vm.is_post = false;
    					vm.isloaded = true;
    			 		var _data = response.data;
						if(_data.code == 200){
							vm.$alert('密码修改成功', { confirmButtonText: '确定' }
							);
							vm.$router.push('/user');
	        			} else {
	        				this.$alert(response.message, { confirmButtonText: '确定' });
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