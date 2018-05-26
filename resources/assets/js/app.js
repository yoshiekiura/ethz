// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import router from './router';
import resource from 'vue-resource';


import ElementUI from 'element-ui'
import 'element-ui/lib/theme-chalk/index.css';

import store from './vuex'
import VueAwesomeSwiper from 'vue-awesome-swiper'

import App from './App.vue'

Vue.use(resource)
Vue.config.productionTip = false;

Vue.use(VueAwesomeSwiper)
Vue.use(ElementUI)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App },
  store:store
});



