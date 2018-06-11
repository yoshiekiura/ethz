<template>
<div class="container home-page">
	<mhead>有奖竞猜</mhead>
	<div class="ctninner ">
		<div class="logs">
			<h2>有奖竞猜</h2>
			<p>享受丰厚收益</p>
		</div>
		<div class="panel">
			<div class="panel-bd color-tip">
				<span>所选币种</span>
				<span class="pull-right">
					<font class="color-link mr10">{{project.code}}</font>
					
					<i class="fa fa-caret-left"></i>
				</span>
			</div>
		</div>
		
		<div class="panel">
			<div class="panel-hd">
				<div class="clearfix mb10">
					<span class="pull-left">总投注</span>
					<span class="pull-right">期数</span>
				</div>
				<div class="clearfix mb10">
					<span class="pull-left"><font class="fs16 color-tip">{{project.sumAmount}}</font><font>{{project.code}}</font></span>
					<span class="pull-right">{{project.name}}</span>
				</div>
			</div>
			<div class="panel-bd">
				<div class="mb20">
					开盘价格：${{project.open || '--'}}
				</div>
				<div class="mb40">
					当前价格：${{lastPrice.last || '--'}}
				</div>
				<div class="bg-gray p20 clearfix fs9 mb40 text-center">
					<!--<span class="pull-left">场次：{{project.expect || '--'}}</span>-->
					<span v-if="state == 'coming_soon'" >
						离开始时间还剩：<font class="color-tip">{{et.day}}天{{et.hour}}时{{et.min}}分{{et.sec}}秒</font>
					</span>
					<span v-else-if="state == 'in_progress'">
						离开结束间还剩：<font class="color-tip">{{et.day}}天{{et.hour}}时{{et.min}}分{{et.sec}}秒</font>
					</span>
					<span v-else>在<font class="color-tip">{{project.openTime}}</font>开奖</span>
				</div>
				<div class="clearfix bet-wrap text-center">
					<div class="item pull-left raise" @click="pour('rise')">
						<i class="fa fa-caret-up"></i>
						涨 {{project.rise}}
					</div>
					<div class="item pull-left" @click="pour('flat')">
						<i class="fa fa-minus"></i>
						平{{project.flat}}
					</div>
					<div class="item pull-left fall" @click="pour('fall')">
						<i class="fa fa-caret-down"></i>
						跌{{project.fall}}
					</div>
				</div>
			</div>
		</div>
	</div>
	<mnav></mnav>
	
	<el-dialog :visible.sync="dialogFormVisible" title="输入下注金额"> 
		<!--<div class="color-rise" v-if="bettingType == 'rise'">买涨</div>
		<div  class="color-gray" v-if="bettingType == 'flat'">买平</div>
		<div class="color-fall" v-if="bettingType == 'fall'">买跌</div>-->
		<el-form v-loading="!dailogload">
			<div class="fs12 color-gray mb5">购买数量 :</div>
			<el-form-item class="mb20">
				<el-input class="text-center" type="text" v-model="dailogForm.amount" pattern="[0-9]*"  auto-complete="off"></el-input>
			</el-form-item>
			<div class="fs12 color-gray mb5">登录密码 :</div>
			<el-form-item class="mb20">
				<el-input class="text-center" v-model="dailogForm.password" type="password" auto-complete="off"></el-input>
			</el-form-item>
			<el-button class="full mt40" round @click.prevent = "dialogSubmit">确认下注</el-button>
		</el-form>
	</el-dialog>
	
</div>
</template>

<script>
import mhead from '../components/head.vue'
import mnav from '../components/unav.vue'
import {mapGetters} from 'vuex'	
export default{
	components:{
		mhead,
		mnav
	},
	computed:{
		...mapGetters(['user_state']),
	},
	data(){
		return {
			project:'',
			members:'',
			isloaded:true,
			listload:true,
			state:null,
			lastPrice:'',
			timer:'',
			timerTicker:null,
			bettingType:'',
			et:{
				day:'--',
				hour:'--',
				min:'--',
				sec:'--'
			},
			dailogForm:{
				amount:'',
				password:'',
			},
			dailogload:true,
			dialogFormVisible:false
		}
	},
	watch:{
		state(n,o){
			var vm = this;
			if(o == 'coming_soon' && n == 'in_progress') {
				clearInterval(vm.timer);
				vm.countTime(vm.project.endTime);
			}else if(o == 'in_progress' && n == 'completed'){
				clearInterval(vm.timer);
				vm.countTime(vm.project.endTime);
			}
		}
	},
	methods:{
		countTime(end){
			let vm = this;
			vm.timer = setInterval(function(){
				vm.etTime(end);
			}, 1000)
		},
		etTime(end){
			let vm = this;
			let startTime = new Date();
			let endTime = this.strTimeTrans(end);
	        if(parseInt(( endTime.getTime() - startTime.getTime())/1000)>0){
	            var leftsecond = parseInt((endTime.getTime() - startTime.getTime())/1000);
	            var day = Math.floor(leftsecond/(60*60*24));
	            var hour = Math.floor((leftsecond-day*24*60*60)/3600);
	            var minute = Math.floor((leftsecond-day*24*60*60-hour*3600)/60);
	            var secont = Math.floor(leftsecond-day*24*60*60-hour*3600-minute*60);
	            this.et.day = this.addZero(day);
	            this.et.hour = this.addZero(hour);
	            this.et.min = this.addZero(minute);
	            this.et.sec = this.addZero(secont);
	            return false;
	        } else{
	        	switch(vm.state){
	        		case 'coming_soon':
	        			vm.state = 'in_progress';
	        			break;
	        		case 'in_progress':
	        			vm.state = 'completed';
	        			break;
	        		default:
	        			break;
	        	}
	        }
	    },
	    strTimeTrans(str){
	    	var regEx = new RegExp("\\-","gi");
	    	if(str){
	    		return new Date((str).replace(regEx,"/"));
    		}
	    },
	    addZero(m) {
            return m < 10 ? '0' + m : m
      	},
        amountValidate(value){
        	let val = value;
       		val = val.replace(/[^\d\.]/g,'');
			val = val.replace(/^\./g,'');
			val = val.replace('.','###').replace(/\./g,'').replace('###','.');
			return val;
       	},
       	dialogSubmit(){
       		var vm = this;
       		if(vm.dailogForm.amount == ''){
    			this.$alert('请填写下注数量', { confirmButtonText: '确定' });
    			return;
    		}
       		
       		if(vm.dailogForm.password == ''){
    			this.$alert('请填写登录密码', { confirmButtonText: '确定' });
    			return;
    		}
       		
       		vm.dailogload = false;
       		vm.$http.post(vm.commonApi.betting + '/' + vm.project.id, {
       			guessid: vm.project.id,
       			amount: vm.dailogForm.amount,
       			betting: vm.bettingType,
       			password: vm.dailogForm.password
       		}).then(response => {
       			vm.dailogload = true;
       			vm.dailogForm.password = '';
       			let res = new Object(response.body);
       			if(res.code == 200) {
       				vm.dialogFormVisible = false;
       			}
       			vm.listAttendance();
       			this.$alert(res.message, { confirmButtonText: '确定' });
       		}).catch(err => {
       			vm.dailogload = true;
       			console.log(err)
       		})
       	},
       	ticker() {
       		let vm = this;
       		vm.$http.get(vm.commonApi.ticker).then(response => {
				let res = new Object(response.body);
				if(res.code == 200) {
					vm.lastPrice = res.data;
				}
			}).catch(err => {
				console.log(err)
			});
       	},
       	cleanTimers(){
       		var vm = this;
       		clearInterval(vm.timerTicker)
       	},
       	pour(str){
       		var vm = this;
       		if(!vm.user_state.token) {
       			this.$alert('请先登录', { confirmButtonText: '确定' });
       		}else {
       			vm.bettingType = str;
       			vm.dialogFormVisible = !vm.dialogFormVisible;
       		}
       	},
       	listAttendance(){
       		let vm = this;
       		vm.listload = false;
			vm.$http.get(vm.commonApi.listAttendance, {params:{guess_id:'current',limit:5}}).then(response =>{
				vm.listload = true;
				let res = new Object(response.body);
				if(res.code == 200) {
					vm.members = res.data.list;
				}
			}).catch(err => {
				vm.listload = true;
				console.log(err)
			});
       	}
	},
	activated(){
		let vm = this;
		vm.isloaded = false;
		vm.$http.get(vm.commonApi.listProject + '/current').then(response => {
			vm.isloaded = true;
			let res = new Object(response.body);
			if(res.code == 200) {
				vm.state = res.data.state;
				if(new Date() < vm.strTimeTrans(res.data.startTime)) {
					vm.countTime(res.data.startTime)
				}else if(new Date() < vm.strTimeTrans(res.data.endTime)){
					vm.countTime(res.data.endTime)
				}
				vm.project = res.data;
			}
		}).catch(err => {
			vm.isloaded = true;
			console.log(err)
		});

		vm.listAttendance();

		vm.timerTicker = setInterval(function(){
			vm.ticker();
		}, 5000);
	},
	deactivated(){
		var vm = this;
		vm.cleanTimers();
	}
}
</script>

<style>
/*.list-enter-active, .list-leave-active {
  transition: all 1s;
}

.list-enter, .list-leave-to {
  transform: translateY(-30px);
  opacity: 0;
}	*/
</style>