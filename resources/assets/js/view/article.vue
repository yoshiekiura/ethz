<template>
	<div class="container">
		<mhead>
			<div class="color-tip handler left">
				<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
			</div>
			<span if="title">{{title}}</span>
		</mhead>
		
		<div class="ctninner pl30 pr30">
			<div class="article fs12">
				文章测试
			</div>
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
      	title:this.$route.query.title
      }
    },
    methods: {
		goback(){
			this.$router.go(-1)
		}
    }
}


</script>

























