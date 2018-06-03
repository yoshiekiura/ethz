import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);
import userstore from './moduls/user_store'
import invitorstore from './moduls/invitor_store'
export default new Vuex.Store({
	modules:{
		userstore,
		invitorstore
	}
})


