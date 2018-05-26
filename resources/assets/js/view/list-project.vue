<template>
<div class="container">
	<mhead>
		项目列表
	</mhead>
	<div class="ctninner">
		<div class="project-list">
			<router-link to="/list_member">
				<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: 2018-05-30 ~ 2018-06-01</div>
					<div class="panel-bd">
						<div class="fs16 mb10">
							<span class="fs12">以太总额:</span>
							<span class="color-tip">100000</span>
						</div>
						<div class="fs12">
							<span class="color-light">参与人数: 9999/10000</span>
						</div>
					</div>
				</div>
			</router-link>
			<router-link to="/list_member">
				<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: 2018-05-30 ~ 2018-06-01</div>
					<div class="panel-bd">
						<div class="fs16 mb10">
							<span class="fs12">以太总额:</span>
							<span class="color-tip">100000</span>
						</div>
						<div class="fs12">
							<span class="color-light">参与人数: 9999/10000</span>
						</div>
					</div>
				</div>
			</router-link>
			<router-link to="/list_member">
				<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: 2018-05-30 ~ 2018-06-01</div>
					<div class="panel-bd">
						<div class="fs16 mb10">
							<span class="fs12">以太总额:</span>
							<span class="color-tip">100000</span>
						</div>
						<div class="fs12">
							<span class="color-light">参与人数: 9999/10000</span>
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
			
		}
	},
	methods:{
	
	}
}
</script>

<style>
</style>