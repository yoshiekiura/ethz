<template>
<div class="container invite-page">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		<span>邀请好友</span>
	</mhead>
	<div class="ctninner">
		<div class="logs">
			<span class="s">一夜致富</span>
			<span class="l">不是梦</span>
		</div>
		<div class="tips text-center color-lighter mb40">
			<p class="fs18 mb15">邀请你好友一同加入</p>
			<p class="fs12">填写你好友的<span class="color-tip">邮箱</span>地址</p>
		</div>
		<el-form ref="form" :model="form" class="color-tip fs12" >
			<el-form-item class="p20">
				<label class="el-form-item__label">
					<i class="fa fa-envelope-open-o"></i>
				</label>
				<el-input v-model="form.count" placeholder="请填写邮箱"></el-input>
			</el-form-item>
		</el-form>
		
		<div class="submit-wrap">
			<el-button @click="submit" class="full submit" round type="tip">确认</el-button>
		</div>
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
		
		},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>