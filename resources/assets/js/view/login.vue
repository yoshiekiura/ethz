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
		<el-button @click="submit" class="full submit" round >登录</el-button>
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
				mail:'',
				pwd: ''
			}
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
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>