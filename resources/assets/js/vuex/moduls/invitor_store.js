export default {
	state:{
		invitor:null,
	},
	mutations:{
		SET_INVITOR_STATE(state, payload){
			state.invitor = payload
		}
	},
	getters:{
		invitor_state: (state,  getters) => {
			return state;
		}
	},
	actions:{
		setInvitorState(state, str) {
			state.commit('SET_INVITOR_STATE', str);
		}
	}
}
