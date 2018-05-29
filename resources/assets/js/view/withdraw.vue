<template>
<div class="container">
	<mhead>
		<div class="color-tip handler left">
			<a @click="goback"><i class="fa fa-close fs18"></i></a>
		</div>
		 提币申请
	</mhead>
	<div class="ctninner">
		<div class="project-list">
			<div class="panel mb20">
				<div class="panel-hd fs9">请填写提币地址</div>
				<div class="panel-bd">
					<el-form ref="form" :model="form" class="color-tip fs12" >
						<el-form-item class="p20">
							<label class="el-form-item__label">
								<i class="fa fa-square"></i>
							</label>
							<el-input v-model="form.adrs" placeholder="例如 0x01231ad234adf0232f32rfasdf"></el-input>
						</el-form-item>
					</el-form>
				</div>
			</div>
			
			<div class="project-list-item panel mb20">
				<div class="panel-hd fs9">提币金额量</div>
				<div class="panel-bd">
					<el-form ref="form" :model="form" class="color-tip fs12" >
						<el-form-item class="p20">
							<label class="el-form-item__label">
								<i class="fa fa-circle"></i>
							</label>
							<el-input v-model="form.amount" placeholder="请输入金额量"></el-input>
						</el-form-item>
					</el-form>
				</div>
			</div>
			
			<div class="submit-wrap" v-loading="!isloaded">
				<el-button @click="submit" class="full submit" round type="tip">确认</el-button>
			</div>
		</div>
	</div>
</div>
</template>

<script>
import mhead from '../components/head.vue'
export default{
	mounted(){
		
	},
	components:{
		mhead,
	},
	data(){
		return {
			code:'',
			form:{
				adrs:null,
				amount:null
			},
			isloaded:true
		}
	},
	methods:{
		submit(){
			let vm = this;
			if(!vm.form.adrs) {
				this.$alert('请填写提币地址', { confirmButtonText: '确定' });
				return;
			}
			
			if(!vm.form.amount) {
				this.$alert('请输入金额量', { confirmButtonText: '确定' });
				return;
			}
			
			vm.isloaded = false;
			vm.$http.post(vm.commonApi.withdraw ,{
				code:vm.code,
    			address:vm.form.adrs,
    			amount:vm.form.amount
    		}).then( response => {
    			vm.isloaded = true;
    			let res = response.body;
    			if(res.code == 200) {
    				this.$alert('体现成功', { confirmButtonText: '确定' });
    			}else {
    				this.$alert(res.message, { confirmButtonText: '确定' });
    			}
    		})
			
			
		},
		goback(){
			this.$router.go(-1)
		}
	},
	activated(){
		let vm = this;
		vm.code = vm.$route.query.code;
		console.log(vm.code)
		
		
		
	}
}
</script>

<style>
</style>