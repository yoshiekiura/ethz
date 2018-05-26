<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		帮助中心
	</mhead>
	<div class="ctninner">
		<div class="panel color-tip">
			<div class="panel-hd fs14">
				产品说明
			</div>
			<div class="panel-bd">
				<router-link :to="{path:'/article', query:{title:'一点投'}}">
					一点投
					<i class="fa fa-angle-right fs14 pull-right"></i>
				</router-link>
			</div>
			<div class="panel-bd">
				美股易股
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
			<div class="panel-bd">
				礼金钱包
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
		</div>
		<div class="panel color-tip">
			<div class="panel-hd fs14">
				常见问题
			</div>
			<div class="panel-bd">
				叮咚易投
				<i class="fa fa-angle-right fs14 pull-right"></i>
			</div>
		</div>
		<el-button class="full submit" round type="tip" ><i class="fa fa-headphones mr10 fs16" style="vertical-align: -2px;"></i>问客服</el-button>
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
		submit(){
			var	that = this;
		},
		goback(){
			this.$router.go(-1)
		}
	}
}
</script>

<style>
</style>