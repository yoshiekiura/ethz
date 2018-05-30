<template>
<div class="container">
	<mhead>
		项目列表
	</mhead>
	<div class="ctninner" v-loading="!isloaded">
		<div class="project-list" v-if="list.length > 0">
			<router-link :to="{ path: '/list_member', query:{pid: item.id} }" v-for="item in list" :key="item.id">
				<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: {{item.startTime}} ~ {{item.endTime}}</div>
					<div class="panel-bd">
						<div class="fs16 mb10">
							<span class="fs12">{{item.name}}</span>
						</div>
						<div class="fs16 mb10">
							<span class="fs12">以太总额:</span>
							<span class="color-tip">{{item.sumAmount}}</span>
						</div>
						<div class="fs12">
							<span class="color-light">参与人数: {{item.number}}</span>
						</div>
					</div>
				</div>
			</router-link>
		</div>
	</div>
	<mnav></mnav>
</div>
</template>

<script>
import mhead from '../components/head.vue'
import mnav from '../components/unav.vue'
export default{
	mounted(){
//		console.log(this.$store.state.count)
	},
	components:{
		mhead,
		mnav
	},
	data(){
		return {
	      	list:'',
	      	isloaded:true
	      }
	},
    activated(){
    	var vm = this
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
    	}
    }
}
</script>

<style>
</style>