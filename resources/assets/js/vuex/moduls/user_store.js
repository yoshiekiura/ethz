import jwtToken from '../../helpers/jwt'
export default {
	state:{
		username:null,
		token:null,
		earnings:null,
		wins:null,
		avatar:null,
		wallet:null,
		friendsamount:null
	},
	mutations:{
		SET_USER_STATE(state, payload){
			for (let key in payload) {
				if(payload[key]){
					state[key] = payload[key]
				}
			}
		},
		CLEAR_USER_STATE(state){
			for (let key in state ) {
				state[key] = '';
			}
		}
		
	},
	getters:{
		user_state: (state,  getters) => {
			return state;
		}
	},
	actions:{
		setUserState(state, data) {
			state.commit('SET_USER_STATE', data);
			jwtToken.setUserState(data);
		},
		clearState(state) {
			state.commit('CLEAR_USER_STATE');
			jwtToken.removeToken();
		}
	}
}
