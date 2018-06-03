<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-angle-left fs18"></i></a>
		</div>
		联系我们
	</mhead>
	<div class="ctninner">
		<div class="panel">
			<div class="panel-bd">
				<el-form class="mb20" ref="form" :model="form" >
					<div class="mb40 fs14">若是您有什么意见或建议, 可以在这里留言:</div>
					<el-form-item class="p20">
						<label class="el-form-item__label">
							<i class="fa fa-phone"></i>
						</label>
						<el-input class="fs14" placeholder="请留下您的联系方式" v-model="form.contact"></el-input>
					</el-form-item>
					<el-form-item class="textarea">
						<el-input class="fs14" placeholder="请留下您的问题" type="textarea" v-model="form.ontent"></el-input>
					</el-form-item>
				</el-form>	
				<div v-loading="!isloaded">
					<el-button class="full submit" round type="tip" @click="submit" >提交</el-button>
				</div>
			</div>
		</div>
		<div class="p20 mt40 fs14" v-if="connectlist">
			<p class="lh15 mb20">若是您遇到什么问题,可以通过以下方式找到我们:</p>
			
			<p v-for="item in connectlist" class="mb15">
				<span class="mr10">{{item.name}}:</span><span class="color-tip">{{item.value}}</span>
			</p>
		</div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	components:{
		mhead
	},
	data(){
		return {
			connectlist:'',
			form:{
				ontent:'',
				contact:''
			},
			isloaded:true
		}
	},
	methods:{
		submit(){
			let vm = this;
			if(!vm.form.ontent){
				vm.$alert('请留下您的问题', { confirmButtonText: '确定' });
				return false;
			}
			
			if(!vm.form.contact){
				vm.$alert('请留下您的联系方式', { confirmButtonText: '确定' });
				return false;
			}
			
			vm.isloaded = false;
			vm.$http.post(vm.commonApi.feedback, vm.form).then(function(response){
				vm.isloaded = true;
				let res = response.body;
				this.$alert(res.message, { confirmButtonText: '确定' });
			}).catch(function(err){
				vm.isloaded = true;
				console.log(err)
			})
		},
		goback(){
			this.$router.go(-1)
		}
	},
	mounted(){
		let vm = this;
		vm.$http.get(vm.commonApi.connect).then(function(response){
			let res = response.body;
			if(res.code == 200) {
				vm.connectlist = res.data.list
			}else {
				this.$alert(res.message, { confirmButtonText: '确定' });
			}
		}).catch(function(err){
			console.log(err)
		})
	},
}
</script>
