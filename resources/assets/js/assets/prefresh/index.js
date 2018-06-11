import Vue from 'vue'
import Handle from './prefresh.vue'

const Handler = Vue.extend(Handle);

const hasClass = (el, cls) => {
	if (!el || !cls) return false;
	if (cls.indexOf(' ') !== -1) throw new Error('className should not contain space.');
	if (el.classList) {
		return el.classList.contains(cls);
	} else {
		return (' ' + el.className + ' ').indexOf(' ' + cls + ' ') > -1;
	}
};

const addClass = (el, cls) => {
	if (!el) return;
	var curClass = el.className;
	var classes = (cls || '').split(' ');

	for (var i = 0,
	j = classes.length; i < j; i++) {
		var clsName = classes[i];
		if (!clsName) continue;

		if (el.classList) {
			el.classList.add(clsName);
		} else if (hasClass(el, clsName)) {
			curClass += ' ' + clsName;
		}
	}
	if (!el.classList) {
		el.className = curClass;
	}
};

const removeClass = (el, cls) => {
	if (!el || !cls) return;
	var classes = cls.split(' ');
	var curClass = ' ' + el.className + ' ';

	for (var i = 0,
	j = classes.length; i < j; i++) {
		var clsName = classes[i];
		if (!clsName) continue;

		if (el.classList) {
			el.classList.remove(clsName);
		} else if (hasClass(el, clsName)) {
			curClass = curClass.replace(' ' + clsName + ' ', ' ');
		}
	}
	if (!el.classList) {
		el.className = trim(curClass);
	}
};

const getStyle = (element, styleName) => {
	if (!element || !styleName) return null;
	if (styleName === 'float') {
		styleName = 'cssFloat';
	}
	try {
		var computed = document.defaultView.getComputedStyle(element, '');
		return element.style[styleName] || computed ? computed[styleName] : null;
	} catch(e) {
		return element.style[styleName];
	}
};

const getDocumentTop = () => {
	var scrollTop = 0, 
		bodyScrollTop = 0, 
		documentScrollTop = 0;
    if (document.body) {
        bodyScrollTop = document.body.scrollTop;
    }
    if (document.documentElement) {
        documentScrollTop = document.documentElement.scrollTop;
    }
    return (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;
}

const install = Vue => {
	let params = {
		top: 0,
        state: 0,
        startY: 0,
        touching: false,
        infiniteLoading: false,
        downFlag: false, //用来显示是否加载中
	}
	
	const methods = {
		touchstart(e){
//			params.startY = 
		},
		touchmove(e){
//			console.log(getDocumentTop());
		},
		touchend(e){
			e.target.removeEventListener('touchmove', methods.touchmove, false);
		}
	}
	
	
	const pullRefresh = (el, binding) => {
//		console.log(el,binding)
//		el.addEventListener('touchstart',  => {
//			
//			let touchmoveEvent;
//			el.addEventListener('touchmove', e => {
//				touchmoveEvent = e;
//				console.log(getDocumentTop());
//			});
//			
//			el.addEventListener('touchend', e => {
//				el.removeEventListener('touchmove',touchmoveEvent.type.);
//				el.removeEventListener('touchend', function(){
//					console.log(333)
//				})
//			})
//			
//		}, false)
		el.addEventListener('touchstart', methods.touchstart, false);
		el.addEventListener('touchmove', methods.touchmove, false);
		el.addEventListener('touchend', methods.touchend, false);
	}
	
	Vue.directive('pfresh', {
		bind(el, binding, vnode) {
//			console.log(el)
//			console.log( binding)
//			console.log(vnode)
			
			const handler = new Handler({
				el:document.createElement('div'),
				data:{
					text:'hahah',
					shifting:''
				}
			});
			
			el.handler = handler.$el;
//			el.appendChild(handler.$el)
			
			pullRefresh(el, binding)
		}
	})
}

export default {
	install
}

