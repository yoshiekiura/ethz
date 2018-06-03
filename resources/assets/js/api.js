var host = hostUrl
export default {
	demo: 'demoUrl',
	user: host + '/api/v1/user',
	register:host+'/api/register',
	login: host + '/api/login',				//登录
	registUrl: host + '/regist',
	submitOrder: host + '/api/order',
	listProject: host + '/api/v1/guess',
	listAttendance: host + '/api/v1/guess/attendance',
	listFriends: host + '/api/v1/user/friends',
	depositsAddress: host + '/api/v1/deposits/address',
	depositsQrcode: host + '/api/v1/deposits/qrcode',
	passwordReset: host + '/api/v1/password/reset',
	withdraw: host + '/api/v1/withdraws',						//提币
	help: host + '/api/v1/news',								//帮助中心列表
	invite: host + '/api/v1/user/invite/email',					//邀请邮件发送
	connect: host + '/api/v1/contact',							//联系
	feedback: host + '/api/v1/feedback'							//反馈
}
