<template>
<div class="container">
	<mhead>
		{{project.name}}
	</mhead>
	<div class="ctninner">
		<div class="timecount mb30">
			<div class="text-center">
				<p class="fs9 clearfix pl20 pr20 mb20 text-center">
					<span>本期开始时间: <font class="color-tip ml5">{{project.startTime}}</font></span>
					<!--<span class="pull-right">:<font class="color-rise ml5"></font></span>-->
				</p>
				<div class="tc mb20">
					<div class="num" v-if="project.isReward == 1 && state == 'completed'">
						￥{{project.endPrice}}
					</div>
					<div class="num" v-else>
						{{et.day}}<span class="fs9">天</span>
						{{et.hour}}<span class="fs9">时</span>
						{{et.min}}<span class="fs9">分</span>
						{{et.sec}}<span class="fs9">秒</span>
					</div>
				</div>
				<el-button v-if="state == 'coming_soon'" round ><span>准备中...</span></el-button>
				<el-button  v-if="state == 'in_progress'" @click="pour" type="tip" round>马上抢注</el-button>
				<el-button  v-if="state == 'completed' || !state " type="disable" round>已结束</el-button>
			</div>
		</div>
		<div class="panel">
			<div class="panel-bd clearfix text-center">
				<div class="labtb">	
					<div class="tr-item">
						<div class="tb-item">
							<div class="lab-item fs12 text-left p0">
								<p class="color-link fs9">当前人数</p>
								<p class="fs18"><span class="color-tip mr5">{{project.number}}</span><span class="fs9">人</span></p>
							</div>
						</div>
						<div class="tb-item">
							<div class="lab-item fs12 text-left p0">
								<p class="color-link fs9">当前以太数</p>
								<p class="fs18"><span class="color-tip mr5">{{project.sumAmount}}</span><span class="fs9">eth</span></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel">
			<div class="panel-bd clearfix text-center">
				<div class="labtb">	
					<div class="tr-item">
						<div class="tb-item">
							<div class="lab-item fs12 text-left p0">
								<p class="color-link fs9">当前Eth价格</p>
								<p class="fs18"><span class="fs9 mr10">{{sign || '¥'}}</span><span class="color-rise mr5">{{lastPrice || project.price}}</span></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel">
			<div class="panel-hd fs9">
				<span >参与用户列表</span>
				<router-link :to="{path:'/list_member', query:{pid:project.id}}" class="pull-right">更多<i class="fa fa-angle-right ml5"></i></router-link>
			</div>
			<div class="panel-bd">
				<div class="memberList" v-loading="!listload">
					
					<transition-group  tag="ul" name="mlist">
						<li v-for="(item, index) in members" :key="index">
							<div class="avatar img-box"><img :src="item.avatar" /></div>
							<div class="info">
								<div class="r">
									<span class="fs14">{{item.name}}</span>
									<span class="color-light fs9 pull-right">买入价格:{{item.price}}</span>
								</div>
								<div class="r fs9">
									<span class="color-light">{{item.createdAt}}</span>
									<span class="color-light pull-right">买入数量:{{item.amount}}</span>
								</div>
							</div>
						</li>
					</transition-group>
					
				</div>
			</div>
		</div>
	</div>
	<mnav></mnav>
	
	<el-dialog :visible.sync="dialogFormVisible">
		<el-form v-loading="!dailogload">
			<div class="fs12 color-gray">eth价格 :</div>
			<el-form-item>
				<!--v-model="dialogPrice"-->
				<el-input class="text-center" type="text" v-model="dailogForm.price" pattern="[0-9]*"  auto-complete="off"></el-input>
			</el-form-item>
			<div class="fs12 color-gray">登录密码 :</div>
			<el-form-item>
				 <!--v-model="dialogAmount"-->
				<el-input class="text-center" v-model="dailogForm.password" type="password" auto-complete="off"></el-input>
				<!-- <el-input class="text-center" v-model="dailogForm.amount" type="text" pattern="[0-9]*" auto-complete="off"></el-input> -->
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
			sign:'',
			timer:'',
			timerTicker:null,
			et:{
				day:'--',
				hour:'--',
				min:'--',
				sec:'--'
			},
			dailogForm:{
				price:'',
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
       		if(vm.dailogForm.price == ''){
    			this.$alert('请填写下注金额', { confirmButtonText: '确定' });
    			return;
    		}
       		
       		if(vm.dailogForm.password == ''){
    			this.$alert('请填写登录密码', { confirmButtonText: '确定' });
    			return;
    		}
       		
       		vm.dailogload = false;
       		vm.$http.post(vm.commonApi.listProject + '/' + vm.project.id, {
       			guessid: vm.project.id,
       			price: vm.dailogForm.price,
       			password: vm.dailogForm.password
       		}).then(response => {
       			vm.dailogload = true;
       			let res = new Object(response.body);
       			if(res.code == 200) {
       				vm.dialogFormVisible = false;
       			}
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
					vm.lastPrice = res.data.ethusd;
					vm.sign = '$';
				}
			}).catch(err => {
				console.log(err)
			});
       	},
       	cleanTimers(){
       		var vm = this;
       		clearInterval(vm.timerTicker)
       	},
       	pour(){
       		var vm = this;
       		if(!vm.user_state.token) {
       			this.$alert('请先登录', { confirmButtonText: '确定' });
       		}else {
       			vm.dialogFormVisible = !vm.dialogFormVisible;
       		}
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
		
		vm.listload = false;
		vm.$http.get(vm.commonApi.listAttendance, {params:{guess_id:'current',limit:5}}).then(response =>{
			vm.listload = true;
			let res = new Object(response.body);
			if(res.code == 200) {
				vm.members = res.data.list;
				console.log(vm.members)
			}
		}).catch(err => {
			vm.listload = true;
			console.log(err)
		});
		
		vm.timerTicker = setInterval(function(){
			vm.ticker();
		}, 5000);
		
//		var testData = { amount:'1', avatar:'/avatars/avatar_4.png', createdAt:"2011-02-03-11:22:33", id:'3', is_win:'0', name:'saf', price:'234', uid:'12' }		
//		setInterval(function(){
//			vm.members.splice(0, 0, testData);
//			vm.members.splice(vm.members.length - 1, 1)
//		}, 5000)
		
	},
	deactivated(){
		var vm = this;
		vm.cleanTimers();
	}
}
</script>

<style>
.list-enter-active, .list-leave-active {
  transition: all 1s;
}

.list-enter, .list-leave-to {
  transform: translateY(-30px);
  opacity: 0;
}	
/*.mlist-move {
	transition: transform 1s;
}*/
</style>