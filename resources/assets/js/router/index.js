import Vue from 'vue'
import Router from 'vue-router'
//import Hello from '../components/Hello'
//import adrsinfo from '../view/addressinfo'
import star from '../view/star'
import home from '../view/home'
import login from '../view/login'
import regist from '../view/regist'
import user from '../view/user'
import setting from '../view/setting'
import help from '../view/help'
import pwdreset from '../view/pwd-reset'
import code from '../view/code'
import article from '../view/article'
import listProject from '../view/list-project'
import listMember from '../view/list-member'
import address from '../view/address'
Vue.use(Router)

const routes = [
   	{
   		path: '/',
   		component: home
   	},
   	{
   		path: '/star',
   		component: star
   	},
		{
    	path:'/login',
    	component: login
   	},
		{
    	path:'/regist',
    	component: regist
   	},
   	{
   		path: '/pwd_reset',
   		component: pwdreset
   	},
   	{
   		path: '/user',
   		component: user
   	},
   	{
   		path: '/setting',
   		component: setting
   	},
   	{
   		path: '/help',
   		component: help
   	},
   	{
   		path: '/code',
   		component: code
   	},
   	{
   		path: '/article',
   		component: article
   	},
   	{
   		path: '/list_project',
   		component: listProject
   	},
   	{
   		path: '/list_member',
   		component: listMember
   	},
   	{
   		path: '/address',
   		component: address
   	}
];

const _router_ = new Router({
  routes
});


export default _router_;












