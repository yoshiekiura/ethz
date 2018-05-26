<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		获取验证码
		<a class="color-tip handler right">登录</a>
	</mhead>
	<div class="ctninner">
		<el-form ref="form" :model="form" class="color-tip fs12" >
			<el-form-item class="p20 enctrl">
				<label class="el-form-item__label">
					<i class="fa fa-mobile"></i>
					<span>+86</span>
				</label>
				<el-input v-model="form.mobile" placeholder="输入密码"></el-input>
				<a class="handler color-link">获取验证码</a>
			</el-form-item>
		</el-form>
		<router-link to="/user"><el-button class="full submit" round >确定</el-button></router-link>
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
				name:'',
				mobile: ''
			},
			pwdview:false
		}
	},
	methods:{
		submit(){
			var	that = this;
//			that.$emit('lgn-smt',true);
		},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>