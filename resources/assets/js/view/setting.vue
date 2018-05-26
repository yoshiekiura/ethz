<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		设置
	</mhead>
	<div class="ctninner">
		<div class="panel color-tip">
			<div class="panel-bd">
				<router-link to="/pwd_reset" >
					<i class="fa fa-unlock-alt mr20"></i>
					修改密码
					<i class="fa fa-angle-right fs14 pull-right"></i>
				</router-link>
			</div>
			<div class="panel-bd">
				<i class="fa fa-commenting mr20"></i>
				推送提醒
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
		</div>
		<div class="panel color-tip">
			<div class="panel-bd">
				<router-link to="/help" >
					<i class="fa fa-question-circle-o mr20"></i>
					帮助中心
					<i class="fa fa-angle-right fs14 pull-right"></i>
				</router-link>
			</div>
			<div class="panel-bd">
				<i class="fa fa-envelope-open mr20"></i>
				意见反馈
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
			<div class="panel-bd">
				<i class="fa fa-exclamation-circle mr20"></i>
				关于
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
		</div>
		<el-button class="full submit" round type="tip" >退出登录</el-button>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	mounted(){
		
	},
	components:{
		mhead
	},
	data(){
		return {
		}
	},
	methods:{
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>