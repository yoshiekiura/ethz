<template>
<div class="container">
	<mhead>
		以太竞猜
	</mhead>
	<div class="ctninner">
		<div class="timecount mb30">
			<div class="text-center">
				<p class="fs9 clearfix pl40 pr40 mb20 text-left">
					<span>本期开始时间</span>
					<span class="pull-right">当前Eth价格:<font class="color-rise">5900.00</font></span>
				</p>
				<div class="tc mb20">
					<div class="num">00:00:00</div>
				</div>
				<el-button type="tip" round>准备中...</el-button>
			</div>
		</div>
		<div class="panel">
			<div class="panel-bd clearfix text-center">
				<div class="labtb">	
					<div class="tr-item">
						<div class="tb-item">
							<div class="lab-item fs12 text-left p0">
								<p class="color-link fs9">当前人数</p>
								<p class="fs18"><span class="color-tip">8888</span><span class="fs9">人</span></p>
							</div>
						</div>
						<div class="tb-item">
							<div class="lab-item fs12 text-left p0">
								<p class="color-link fs9">当前以太数</p>
								<p class="fs18"><span class="color-tip">100000.00</span></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel">
			<div class="panel-hd fs9">
				<span >参与用户列表</span>
				<router-link to="/list_member" class="pull-right">更多<i class="fa fa-angle-right ml5"></i></router-link>
			</div>
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
			form: {
				name:'',
				mobile: ''
			}
		}
	},
	methods:{
		submit(){
			var	that = this;
//			that.$emit('lgn-smt',true);
		}
	}
}
</script>

<style>
</style>