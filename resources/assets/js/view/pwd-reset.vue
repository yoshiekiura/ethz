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
				oldpwd:'',
				newpwd: ''
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