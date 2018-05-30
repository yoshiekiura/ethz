<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		项目列表
	</mhead>
	<div class="ctninner" v-loading="!isloaded">
		<div class="project-list" v-if="list.length > 0">
			<router-link :to="{ path: '/list_member', query:{pid: item.id} }" v-for="item in list" :key="item.id">
				<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: {{item.startTime}} ~ {{item.endTime}}</div>
					<div class="panel-bd">
						<div class="fs14 mb10">
							<span class="fs12 color-light">项目名:</span>
							<span>{{item.name}}</span>
						</div>
						<div class="fs16 mb10">
							<span class="fs12 color-light">以太总额:</span>
							<span class="color-tip">{{item.sumAmount}}</span>
						</div>
						<div>
							<span class="fs12 color-light">参与人数:</span>
							<span class="fs14">{{item.number}}</span>
						</div>
					</div>
				</div>
			</router-link>
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
		mhead,
	},
	data(){
		return {
	      	list:'',
	      	isloaded:true
	      }
	},
    activated(){
    	let vm = this;
    	vm.getItemList()
    },
	methods: {
    	getItemList(){
    		var vm = this;
    		vm.isloaded = false;
    		vm.$http.get(vm.commonApi.listProject).then(function(response){
    			vm.isloaded = true;
		 		if(response.body.code == 200) {
		 			vm.list = response.body.data.list
		 		}
        	})
    	},
		goback(){
			this.$router.go(-1)
		}
    }
}
</script>

<style>
</style>