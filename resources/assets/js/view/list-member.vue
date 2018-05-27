<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		项目列表
	</mhead>
	<div class="ctninner">
		<div class="rank">
		</div>
		<div class="panel">
			<div class="panel-bd">
				<div class="memberList">
					<ul  v-if="list.length > 0">
						<li v-for="item in list">
							<div class="avatar img-box"><img :src="item.avatar" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">{{item.name}}</span>
									<span class="color-light fs9 pull-right">买入价格:{{item.price}}</span>
								</div>
								<div class="r fs9">
									<span class="color-light">{{item.createdAt}}</span>
									<span class="color-light pull-right">买入数量:{{item.amount}}{{item.code}}</span>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
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
			id:'',
	      	list:[]
	      }
	},
    activated(){
    	var vm = this
    	vm.getMemberList()
    },
	methods:{
		getMemberList(){
    		var vm = this
    		vm.id = vm.$route.query.id;
    		vm.$http.get(
    			vm.commonApi.listAttendance,
    			{params:{guess_id:vm.id}}
    			).then(function(response){
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