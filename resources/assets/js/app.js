// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import router from './router';
import jwtToken from './helpers/jwt'
import resource from 'vue-resource';
import utils from './helpers/utils'


import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css';

import commonApi from './api.js'
import store from './vuex'

import App from './App.vue'


Vue.use(resource)
Vue.config.productionTip = false;
Vue.prototype.commonApi = commonApi;

Vue.use(ElementUI)

//var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjI5ZjdlMDNiNjY0NzZmN2MwNDlhZDUwYWNmOWE2ZjI3YmQwYzU2M2ViMWZiYjQzZDFmY2I2NGJkZjI3OWRlYTE5ZjA5NjNhMjQwYzQ5NmQyIn0.eyJhdWQiOiIyIiwianRpIjoiMjlmN2UwM2I2NjQ3NmY3YzA0OWFkNTBhY2Y5YTZmMjdiZDBjNTYzZWIxZmJiNDNkMWZjYjY0YmRmMjc5ZGVhMTlmMDk2M2EyNDBjNDk2ZDIiLCJpYXQiOjE1Mjc0MDU1ODMsIm5iZiI6MTUyNzQwNTU4MywiZXhwIjoxNTI4NzAxNTgzLCJzdWIiOiIxMCIsInNjb3BlcyI6W119.UkwnQRKB6o8TrRiZ715mx46zDnFmm6Faj0ElBvjGzbyXyBugnp2C1BRXR4VYxcb7niaUAU_6WAdZwSB8KieWHRvTF2b3zmgy2PyhO4o-0tXS4PscRclAXTjL-Hg4RUZhQkiqFM9ligBQGRazSs7ZQ919AiaXZ24CK6thCFZapIlQ-d_mtS9NdSc8Hh1VeMIfkswAp74CljR7zbRd1pDwbW2n111lCAbKhqitUXrMKLRhrv7qNF4Bfn97PHm8bKVgt5VpUCQEJpGtxftFoqvwAYbqS4nQX_GAjzSfM3Ll0y0zYvD7AbkKMtV3gG2hNUTEhpQeRizWG4E4gOSiRf_XcG_PnBI0ijOJosnIiFLfS9WhGv-qL3vwgAY6GoxNCmbTHncbAoHubDHPcM2oPw-qu1CspMQkfFx9LBz_uWGiyK9WWTrAiUFlsqKI62jR0OjELQNae1RUhWx-sx0Q18kGCuTn3LrXVqrAhmHbNWiXHj2VVWaUHB5UwVSPIRhvdIi8XKki9Tm0DNDsFdYd0ojgPYKYDmkzcR6d2t_ZjW4l61MTOMUcEpwyIBFsbIFWv7lnfoOTB4dHo21N5h_qjoNJtcKI6b75yNYzeibSPySNg-MNPPsNsO15BjIawSIzg5kqpGTmgOtuXJoHz9coFIdxvrz8YmCffkuoSljaWeSurfA';
//console.log(jwtToken.getUserState(), 123)
//if(jwtToken.getUserState()) {
//	Vue.http.headers.common['Authorization'] = 'Bearer ' + jwtToken.getUserState().token;
//	Vue.http.interceptors.push((request, next) => {
//	   request.headers.set('Authorization', 'Bearer ' + jwtToken.getUserState().token)
//	    next(response => {
//	    // if(response.status == '401' && response.statusText == 'Unauthorized'){
//	    //   window.location.href = '/wechat/authorize';
//	    // }
//	      return response
//	  })
//	})
//}

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App },
  store:store
});



