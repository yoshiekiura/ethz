<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		好友列表
	</mhead>
	<div class="ctninner">
		<div class="panel" v-loading="!isloaded">
			<div class="panel-bd">
				<div class="memberList" v-if="list">
					<ul>
						
						<li v-for="item in list.list">
							<div class="avatar img-box"><img :src="item.avatar" /></div>
							<div class="info">
								<span class="fs12">{{item.name}}</span>
								<span class="fs9 pull-right color-light">{{item.createdAt}}</span>
							</div>
						</li>
						
					</ul>
				</div>
				<div class="text-center fs14" v-else>
					<div class="pt40 pb40">
						快去邀请好友吧!
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	mounted(){
//		console.log(this.$store.state.count)
	},
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
		goback(){
			this.$router.go(-1)
		}
	},
	activated(){
		let vm = this;
		
		vm.isloaded = false;
		vm.list = '';
		vm.$http.get(vm.commonApi.listFriends).then(function(response){
			let res = response.body;
			vm.isloaded = true;
			if(res.code == 200) {
				vm.list = res.data
			}
		}).catch(function(){
			vm.isloaded = true;
		})
	}
}
</script>

<style>
</style>