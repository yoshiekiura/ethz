import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex);
import userstore from './moduls/user_store'
export default new Vuex.Store({
	modules:{
		userstore
	}
})


