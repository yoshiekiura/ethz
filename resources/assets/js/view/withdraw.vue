<template>
<div class="container">
	<mhead>
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
							<el-input v-model="form.count" placeholder="请输入金额量"></el-input>
						</el-form-item>
					</el-form>
				</div>
			</div>
			
			
			<el-button @click="submit" class="full submit" round type="tip">确认</el-button>
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
			form:{
				adrs:'',
				count:''
			}
		}
	},
	methods:{
	
	}
}
</script>

<style>
</style>