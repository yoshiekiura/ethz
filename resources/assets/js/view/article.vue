<template>
	<div class="container">
		<mhead>
			<div class="color-tip handler left">
				<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
			</div>
			<span if="title">{{title}}</span>
		</mhead>
		
		<div class="ctninner pl30 pr30" v-loading="!isloaded">
			<div v-if="ctn" class="article fs12" v-html="ctn"></div>
			<div v-else class="text-center mt40 color-gray">暂无该文章</div>
		</div>
	</div>
</template>

<script>
import mhead from '../components/head.vue'
import tipHc from '../components/tip_help_center.vue'
export default{
	components:{
		mhead,
		tipHc
	},
	data() {
      return {
      	title:'',
      	aid:'',
      	ctn:'',
      	isloaded:true
      }
    },
    methods: {
		goback(){
			this.$router.go(-1)
		}
    },
    activated(){
    	let vm = this;
    	vm.title = vm.$route.query.title;
    	vm.aid = vm.$route.query.aid;
    	
    	vm.isloaded = false;
    	vm.$http.get(vm.commonApi.help + '/' + vm.aid).then(function(response){
			let res = response.body;
			vm.isloaded = true;
			if(res.code == 200) {
				vm.ctn = res.data.content
			}else {
				this.$alert(res.message, { confirmButtonText: '确定' });
			}
		}).catch(function(){
			vm.isloaded = true;
		})
    }
}


</script>

























