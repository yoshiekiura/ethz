import Vue from 'vue'
import Vuex from 'vuex'

import * as actions from './actions'

Vue.use(Vuex)
export default new Vuex.Store({
	 state:{
	 	user_name:'',
	 	count:1
	 },
	 mutations:{
	 	login (state, name) {
	 		state.user_name = name;
	 	},
	 	increment: state => state.count++
	 }
})

























