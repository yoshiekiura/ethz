<template>
<div class="container">
	<mhead>
		参与项目
	</mhead>
	<div class="ctninner">
		<div class="project-list">
			<div class="project-list-item panel mb20">
				<div class="panel-hd fs9">
					项目名XXX
					<em class="tag">获奖</em>
				</div>
				<div class="panel-bd fs9">
					<div class="mb10">
						<span class="color-gray">竞猜时间:</span>
						<span class="color-tip">2018-05-28</span>
					</div>
					<div class="mb10">
						<span class="color-gray">竞猜价格:</span>
						<span class="color-tip">¥ 5000</span>
					</div>
					<div class="mb10">
						<span class="color-gray">竞猜额度:</span>
						<span class="color-tip">1.34 eth</span>
					</div>
				</div>
			</div>
			
			<div class="project-list-item panel mb20">
				<div class="panel-hd fs9">
					项目名XXX
				</div>
				<div class="panel-bd fs9">
					<div class="mb10">
						<span class="color-gray">竞猜时间:</span>
						<span class="color-tip">2018-05-28</span>
					</div>
					<div class="mb10">
						<span class="color-gray">竞猜价格:</span>
						<span class="color-tip">¥ 5000</span>
					</div>
					<div class="mb10">
						<span class="color-gray">竞猜额度:</span>
						<span class="color-tip">1.34 eth</span>
					</div>
				</div>
			</div>
			
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
			
		}
	},
	methods:{
	
	}
}
</script>

<style>
</style>