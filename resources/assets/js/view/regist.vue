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
		<router-link to="/user"><el-button class="full submit" round >登录</el-button></router-link>
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
			}
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