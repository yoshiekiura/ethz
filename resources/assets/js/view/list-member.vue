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
					<ul>
						<li>
							<div class="avatar img-box"><img src="/img/album1.jpg" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">Ession1</span>
									<span class="color-light fs9 pull-right">买入价格:455**</span>
								</div>
								<div class="r fs9">
									<span class="color-light">1992-02-03</span>
									<span class="color-light pull-right">买入数量:1</span>
								</div>
							</div>
						</li>
						<li>
							<div class="avatar img-box"><img src="/img/album1.jpg" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">Ession4</span>
									<span class="color-light fs9 pull-right">买入价格:455**</span>
								</div>
								<div class="r fs9">
									<span class="color-light">1992-02-03</span>
									<span class="color-light pull-right">买入数量:1</span>
								</div>
							</div>
						</li>
						<li>
							<div class="avatar img-box"><img src="/img/album1.jpg" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">Ession2</span>
									<span class="color-light fs9 pull-right">买入价格:455**</span>
								</div>
								<div class="r fs9">
									<span class="color-light">1992-02-03</span>
									<span class="color-light pull-right">买入数量:1</span>
								</div>
							</div>
						</li>
						<li>
							<div class="avatar img-box"><img src="/img/album1.jpg" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">Ession3</span>
									<span class="color-light fs9 pull-right">买入价格:455**</span>
								</div>
								<div class="r fs9">
									<span class="color-light">1992-02-03</span>
									<span class="color-light pull-right">买入数量:1</span>
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
			
		}
	},
	methods:{
		getMemberList(){
    		var vm = this
    		console.log(vm.commonApi.listProject)
    		vm.$http.get(vm.commonApi.listProject).then(function(response){
		 		if(response.body.code == 200) {
		 			vm.list = response.body.data.list
		 		}
				console.log(vm.list)
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