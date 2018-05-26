export default {
	state:{
		username:null,
		statius:null
	},
	mutations:{
		SET_USER_STATE(state, payload){
			state.username = payload.username;
			state.statius = true;
		},
		CLEAR_USER_STATE(state){
			state.username = null;
			state.statius = null;
		}
		
	},
	getters:{
		user_state: (state, getters) => {
			return state;
		}
	},
	actions:{
		setUserState({commit}, data) {
//			console.log(data)
			commit('SET_USER_STATE', data);
		}
	}
}
