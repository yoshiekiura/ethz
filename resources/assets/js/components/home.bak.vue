<template>
	<section>
		<!--<swiper class="home_poster" :options="homePosterOption" rel="homePoster">
			<swiper-slide><a class="img-box"><img src="/static/img/temp/1.jpg" /></a></swiper-slide>
			<swiper-slide><a class="img-box"><img src="/static/img/temp/2.jpg" /></a></swiper-slide>
			<swiper-slide><a class="img-box"><img src="/static/img/temp/5.jpg" /></a></swiper-slide>
		</swiper>-->
		
		<!--<div class="floor">
			<div class="tl">本周排行</div>
			<div class="itemwrap">
				<div class="itembox">
					<div class="album"><img src="/static/img/temp/album2.jpg" /></div>
					<div class="info">
						<p>放 &amp; 披风</p>
						<p>陈奕迅</p>
					</div>
				</div>
				<div class="itembox">
					<div class="album"><img src="/static/img/temp/album2.jpg" /></div>
					<div class="info">
						<p>放 &amp; 披风</p>
						<p>陈奕迅</p>
					</div>
				</div>
			</div>
		</div>-->
		
	</section>	
</template>
<script>
import swiper from 'vue-awesome-swiper'
export default{
	data(){
		return {
			homePosterOption:{
				notNextTick: true
			}
		}
	},
	computed:{
		hposter(){
        	return this.$refs.homePoster.swiper
		}
	}
}
</script>