<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		帮助中心
	</mhead>
	<div class="ctninner">
		<!--<div class="panel color-tip">
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
		</div>-->
		<div class="panel color-tip">
			<div class="panel-hd fs14">
				产品说明
			</div>
			<div v-if="list">
				<div class="panel-bd fs12" v-for="item in list.list">
					<router-link :to="{path:'/article', query:{title:item.title, aid:item.id}}">
						{{item.title}}
						<i class="fa fa-angle-right fs14 pull-right"></i>
					</router-link>
				</div>
			</div>
		</div>
		<div class="submit-wrap">
			<el-button class="full submit" round type="tip" ><i class="fa fa-headphones mr10 fs16" style="vertical-align: -2px;"></i>问客服</el-button>
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
			list:'',
			isloaded:true
		}
	},
	methods:{
		submit(){
			var	that = this;
		},
		goback(){
			this.$router.go(-1)
		}
	},
	mounted(){
		let vm = this;
		vm.$http.get(vm.commonApi.help).then(function(response){
			let res = response.body;
			vm.isloaded = true;
			if(res.code == 200) {
				vm.list = res.data
			}else {
				this.$alert(res.message, { confirmButtonText: '确定' });
			}
		}).catch(function(){
			vm.isloaded = true;
		})
	},
}
</script>

<style>
</style>