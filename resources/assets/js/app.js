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
import VueAwesomeSwiper from 'vue-awesome-swiper'

import App from './App.vue'

Vue.use(resource)
Vue.config.productionTip = false;
Vue.prototype.commonApi = commonApi;

Vue.use(VueAwesomeSwiper)
Vue.use(ElementUI)

Vue.http.headers.common['Authorization'] = 'Bearer ' + jwtToken.getToken();
Vue.http.interceptors.push((request, next) => {
   request.headers.set('Authorization', 'Bearer ' + jwtToken.getToken())
    next(response => {
    // if(response.status == '401' && response.statusText == 'Unauthorized'){
    //   window.location.href = '/wechat/authorize';
    // }
      return response
  })
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App },
  store:store
});



