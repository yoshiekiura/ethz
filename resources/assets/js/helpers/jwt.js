export default {
    setToken(token) {
    	
//  	console.log(token)
        window.localStorage.setItem('jwt_token',token);
    },
    getToken() {
//  	console.log(window.localStorage.getItem('jwt_token'))
        return window.localStorage.getItem('jwt_token');
    },
    removeToken() {
        window.localStorage.removeItem('jwt_token');
        window.localStorage.removeItem('user_state');
    },
    setUserState (data) {
    	let localstate = this.getUserState('user_state');
//  	console.log(localstate, data)
    	if(localstate) {
    		for (let key in data) {
    			localstate[key] = data[key]
    		}
    	} else {
    		localstate = data;
    	}
    	
    	localstate = JSON.stringify(localstate);
    	
    	try{
    		window.localStorage.setItem('user_state',localstate)
    	} 
    	catch(err){
    		this.removeToken();
    		console.log(err);
    	}
    	
    },
    getUserState () {
    	return JSON.parse(window.localStorage.getItem('user_state'));
    }
}