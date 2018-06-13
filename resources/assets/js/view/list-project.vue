<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		往期竞猜
	</mhead>
	<div class="ctninner isNavbar" v-loading="!isloaded">
		<div class="project-list" v-if="list.length > 0">
			<router-link :to="{ path: '/list_member', query:{pid: item.id} }" v-for="(item, index) in list" :key="index">
				<!--<div class="project-list-item panel mb20">
					<div class="panel-hd fs9">项目时间: {{item.startTime}} ~ {{item.endTime}}</div>
					<div class="panel-bd">
						<div class="fs14 mb10">
							<span class="color-light">项目名:</span>
							<span>{{item.name}}</span>
						</div>
						<div class="fs14 mb10">
							<span class="color-light">以太总额:</span>
							<span class="color-tip">{{item.sumAmount}}</span>
						</div>
						<div class="fs14">
							<span class="color-light">参与人数:</span>
							<span>{{item.number}}</span>
						</div>
					</div>
				</div>-->
				<div class="panel fs12">
					<div class="panel-hd text-center">{{item.title}}</div>
					<div class="panel-hd clearfix ">
						<div class="pull-left">开奖时间：{{item.open_time}}</div>
						<div class="pull-right">{{item.win_total}}人获奖</div>
					</div>
					<div class="panel-hd fs14">
						<div class="clearfix color-rise">
							<div class="pull-left">涨：{{item.user.rise}} <i class="fa fa-caret-up"></i></div>
							<div class="pull-right">投注：{{item.betting.rise}}{{code}}</div>
						</div>
						<div class="clearfix">
							<div class="pull-left">平：{{item.user.flat}} <i class="fa fa-minus"></i></div>
							<div class="pull-right">投注：{{item.betting.flat}}{{code}}</div>
						</div>
						<div class="clearfix color-fall">
							<div class="pull-left">跌：{{item.user.fall}} <i class="fa fa-caret-down"></i></div>
							<div class="pull-right">投注：{{item.betting.fall}}{{code}}</div>
						</div>
					</div>
					<div class="panel-hd clearfix">
						<div class="clum3 text-center">
							<h5 class="mb10">开盘价格</h5>
							<div>{{item.open_price || '--'}}</div>
						</div>
						<div class="clum3 text-center">
							<h5 class="mb10">开奖价格</h5>
							<div>{{item.last_price || '--'}}</div>
						</div>
						<div class="clum3 text-center">
							<h5 class="mb10">总注数</h5>
							<div>{{item.sum_amount || '--'}}</div>
						</div>
					</div>
					<div class="panel-bd text-center">
						<div v-if="item.state == 'coming_soon'">项目未开始</div>
						<div class="color-tip" v-if="item.state == 'in_progress'">项目进行中...</div>
						<div v-if="item.state == 'completed'">
							开奖结果：
							<span class="color-rise" v-if="item.betting_win == 'rise'">涨</span>
							<span v-if="item.betting_win == 'flat'">平</span>
							<span class="color-fall" v-if="item.betting_win == 'fall'">跌</span>
						</div>
					</div>
				</div>
			</router-link>
			<div @click="getItemList" class="handle text-center pt20 pb20" :class="handleStr=='加载更多'?'color-tip':'color-gray'" >{{handleStr}}</div>
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
	      	list:[],
	      	isloaded:true,
	      	code:'',
	      	last:null,
	      	handleStr:'加载更多'
	      }
	},
    activated(){
    	let vm = this;
    	vm.last = null;
    	vm.getItemList()
    },
	methods: {
    	getItemList(){
    		var vm = this;
    		vm.isloaded = false;
    		console.log(vm.isloaded)
    		vm.$http.get(vm.commonApi.listHistory, {params:{sinceId:vm.last}}).then(function(response){
    			vm.isloaded = true;
		 		if(response.body.code == 200) {
    				vm.code =  response.body.data.code;
//		 			vm.list = response.body.data.list;
		 			vm.list = vm.list.concat(response.body.data.list);
		 			vm.last = response.body.data.lastId;
		 			vm.handleStr = '加载更多';
		 		}else{
		 			vm.handleStr = '没有更多数据了';
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