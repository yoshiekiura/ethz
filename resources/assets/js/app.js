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

var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImJmNmMyM2IxZWZhZWEwMzM0NGRmMDJkYjlhNWQwNWM4NzBiZjQwMGViMzFmZDVkYzFmZWU2ZDFhM2Q4OGM4N2ViMDM1ZGI3MjNlMzNhMmNmIn0.eyJhdWQiOiIyIiwianRpIjoiYmY2YzIzYjFlZmFlYTAzMzQ0ZGYwMmRiOWE1ZDA1Yzg3MGJmNDAwZWIzMWZkNWRjMWZlZTZkMWEzZDg4Yzg3ZWIwMzVkYjcyM2UzM2EyY2YiLCJpYXQiOjE1MjczOTgwOTYsIm5iZiI6MTUyNzM5ODA5NiwiZXhwIjoxNTI4Njk0MDk2LCJzdWIiOiIxMCIsInNjb3BlcyI6W119.kj2cOqOAXYrJCqSmh_V1xCxuQu3xjxOSiCMx2sH83zJsgOiiYYbvtbH11B3VZclvwfC86O20bJyaEBLvGSS-Spy1twStg1bToTW_N8Pjdugo_T6NScSNhoFRvcUtAITQ8lWczzTRZeZ-ePhcTmLwZEI_5hu_wHh4zDiRFVi-qujWJxB6roIuWZVT0AS01iixtV_DYmUZCQm6Coj4DlMjHcgnzKsb-sW-01rWsHm7x9haGvZx5_8yUvwtwjpf8hBKEDVuON6g4stoYdCm4C35IdExuenWbtdeM8Yi27RUSGrNxvNGBH7F2Vh4hrAlCOQRtfbR0PkGIxv4fPPmQJOPy0aIhQgjM5BKWxdlhs_gOKKzTMcatq_7YQkPEY-4Br3WLxN1TCkRn2Jckd9GQ-P9Q_vddVx5QSnmJ0vofkRfTijgWxZH5HtAlHmMbrToNgKUT1hEn6Tbz0m0uMe6yqIuioSi1BPzzM8AV3ukqGnHBY0Cf9uKDmMaA5G_MWV3V4H5UdF5I19hsWegOCRvrPOmMORcLXk7FzDEwK2QvjDTIx8qvqhm5yaL8EadrbDkW_n_cIESgQWp-L9H4J5_r-luEIyYik1E_ZV-10J1osemfFq-9iNqXP1jUPxCqn9420oDwhrso_WOAbBhzWrC83VeZAxx9nbx2f6nhJh_Vj83YwU';
Vue.http.headers.common['Authorization'] = 'Bearer ' + token;
// Vue.http.headers.common['Authorization'] = 'Bearer ' + jwtToken.getToken();
Vue.http.interceptors.push((request, next) => {
   request.headers.set('Authorization', 'Bearer ' + token)
   // request.headers.set('Authorization', 'Bearer ' + jwtToken.getToken())
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



