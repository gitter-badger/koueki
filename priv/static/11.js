(this.webpackJsonp=this.webpackJsonp||[]).push([[11],{767:function(t,e,n){"use strict";Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var o,r=(o=n(0))&&o.__esModule?o:{default:o},u=n(190),i=n(256),c=n(255),s=n(85),a=n(135);function f(t){return(f="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t})(t)}function p(t,e,n,o,r,u,i){try{var c=t[u](i),s=c.value}catch(t){return void n(t)}c.done?e(s):Promise.resolve(s).then(o,r)}function l(t,e){for(var n=0;n<e.length;n++){var o=e[n];o.enumerable=o.enumerable||!1,o.configurable=!0,"value"in o&&(o.writable=!0),Object.defineProperty(t,o.key,o)}}function y(t,e){return!e||"object"!==f(e)&&"function"!=typeof e?function(t){if(void 0===t)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return t}(t):e}function h(t){return(h=Object.setPrototypeOf?Object.getPrototypeOf:function(t){return t.__proto__||Object.getPrototypeOf(t)})(t)}function b(t,e){return(b=Object.setPrototypeOf||function(t,e){return t.__proto__=e,t})(t,e)}var v=function(t){function e(){return function(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}(this,e),y(this,h(e).apply(this,arguments))}var n,o,c;return function(t,e){if("function"!=typeof e&&null!==e)throw new TypeError("Super expression must either be null or a function");t.prototype=Object.create(e&&e.prototype,{constructor:{value:t,writable:!0,configurable:!0}}),e&&b(t,e)}(e,r.default.Component),n=e,(o=[{key:"componentDidMount",value:function(){var t,e=(t=regeneratorRuntime.mark(function t(){return regeneratorRuntime.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:return console.log(this.props),i.toast.info("Logging out..."),this.props.setLoginStatus(!1),t.next=5,(0,u.post)("/auth/logout");case 5:i.toast.success("Logged out"),this.props.history.push("/web/");case 7:case"end":return t.stop()}},t,this)}),function(){var e=this,n=arguments;return new Promise(function(o,r){var u=t.apply(e,n);function i(t){p(u,o,r,i,c,"next",t)}function c(t){p(u,o,r,i,c,"throw",t)}i(void 0)})});return function(){return e.apply(this,arguments)}}()},{key:"render",value:function(){return""}}])&&l(n.prototype,o),c&&l(n,c),e}(),d={setLoginStatus:a.setLoginStatus},g=(0,c.withRouter)((0,s.connect)(null,d)(v));e.default=g}}]);
//# sourceMappingURL=11.js.map