"use strict";(self.webpackChunktaier_website=self.webpackChunktaier_website||[]).push([[71],{3905:function(e,n,t){t.d(n,{Zo:function(){return p},kt:function(){return m}});var a=t(7294);function r(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function i(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);n&&(a=a.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,a)}return t}function o(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?i(Object(t),!0).forEach((function(n){r(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):i(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function c(e,n){if(null==e)return{};var t,a,r=function(e,n){if(null==e)return{};var t,a,r={},i=Object.keys(e);for(a=0;a<i.length;a++)t=i[a],n.indexOf(t)>=0||(r[t]=e[t]);return r}(e,n);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(a=0;a<i.length;a++)t=i[a],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(r[t]=e[t])}return r}var s=a.createContext({}),l=function(e){var n=a.useContext(s),t=n;return e&&(t="function"==typeof e?e(n):o(o({},n),e)),t},p=function(e){var n=l(e.components);return a.createElement(s.Provider,{value:n},e.children)},d={inlineCode:"code",wrapper:function(e){var n=e.children;return a.createElement(a.Fragment,{},n)}},u=a.forwardRef((function(e,n){var t=e.components,r=e.mdxType,i=e.originalType,s=e.parentName,p=c(e,["components","mdxType","originalType","parentName"]),u=l(t),m=r,k=u["".concat(s,".").concat(m)]||u[m]||d[m]||i;return t?a.createElement(k,o(o({ref:n},p),{},{components:t})):a.createElement(k,o({ref:n},p))}));function m(e,n){var t=arguments,r=n&&n.mdxType;if("string"==typeof e||r){var i=t.length,o=new Array(i);o[0]=u;var c={};for(var s in n)hasOwnProperty.call(n,s)&&(c[s]=n[s]);c.originalType=e,c.mdxType="string"==typeof e?e:r,o[1]=c;for(var l=2;l<i;l++)o[l]=t[l];return a.createElement.apply(null,o)}return a.createElement.apply(null,t)}u.displayName="MDXCreateElement"},4506:function(e,n,t){t.r(n),t.d(n,{frontMatter:function(){return c},contentTitle:function(){return s},metadata:function(){return l},toc:function(){return p},default:function(){return u}});var a=t(7462),r=t(3366),i=(t(7294),t(3905)),o=["components"],c={},s="docker \u90e8\u7f72",l={unversionedId:"quickstart/deploy/docker",id:"quickstart/deploy/docker",title:"docker \u90e8\u7f72",description:"\u6ce8\u610f\uff1ataier\u7684docker\u955c\u50cf\uff0c\u76ee\u524d\u662f\u901a\u8fc7\u76ee\u5f55\u6302\u8f7d\u7684\u53bb\u52a0\u8f7ddatasourcex\u548cchunjun\uff0c\u4ee5\u4e0b\u64cd\u4f5c\u9ed8\u8ba4\u63d2\u4ef6\u5305\u90fd\u5df2\u7ecf\u4e0b\u8f7d",source:"@site/docs/quickstart/deploy/docker.md",sourceDirName:"quickstart/deploy",slug:"/quickstart/deploy/docker",permalink:"/Taier/docs/quickstart/deploy/docker",editUrl:"https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/docs/quickstart/deploy/docker.md",tags:[],version:"current",frontMatter:{},sidebar:"docs",previous:{title:"\u524d\u7aef\u90e8\u7f72",permalink:"/Taier/docs/quickstart/deploy/web"},next:{title:"\u5feb\u901f\u4e0a\u624b",permalink:"/Taier/docs/quickstart/start"}},p=[{value:"1. \u4ec5\u4f7f\u7528taier\u7684web\u548cui\u955c\u50cf",id:"1-\u4ec5\u4f7f\u7528taier\u7684web\u548cui\u955c\u50cf",children:[],level:2},{value:"2. \u4f7f\u7528docker-compose",id:"2-\u4f7f\u7528docker-compose",children:[],level:2}],d={toc:p};function u(e){var n=e.components,t=(0,r.Z)(e,o);return(0,i.kt)("wrapper",(0,a.Z)({},d,t,{components:n,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"docker-\u90e8\u7f72"},"docker \u90e8\u7f72"),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"\u6ce8\u610f\uff1ataier\u7684docker\u955c\u50cf\uff0c\u76ee\u524d\u662f\u901a\u8fc7\u76ee\u5f55\u6302\u8f7d\u7684\u53bb\u52a0\u8f7ddatasourcex\u548cchunjun\uff0c\u4ee5\u4e0b\u64cd\u4f5c\u9ed8\u8ba4\u63d2\u4ef6\u5305\u90fd\u5df2\u7ecf\u4e0b\u8f7d"))),(0,i.kt)("p",null,"\u4ee5datasoucex\u4e3a\u4f8b \u89e3\u538b\u540e\u76ee\u5f55\u7ed3\u6784\u4e3a  "),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"/opt/dtstack/DTPlugin/InsightPlugin/dataSourcePlugin \n\u251c\u2500\u2500 aws_s3\n\u251c\u2500\u2500 clickhouse\n\u251c\u2500\u2500 db2\n\u251c\u2500\u2500 dmdb\n\u251c\u2500\u2500 doris\n\u251c\u2500\u2500 emq\n\u251c\u2500\u2500 es\n\u251c\u2500\u2500 es7\n\u251c\u2500\u2500 ftp\n\u251c\u2500\u2500 gbase\n\u251c\u2500\u2500 greenplum6\n\u251c\u2500\u2500 hbase\n\u251c\u2500\u2500 hbase2\n\u251c\u2500\u2500 hbase_gateway\n\u251c\u2500\u2500 hdfs\n\u251c\u2500\u2500 hive\n\u251c\u2500\u2500 hive1\n\u251c\u2500\u2500 hive3\n\u251c\u2500\u2500 impala\n\u251c\u2500\u2500 inceptor\n\u251c\u2500\u2500 influxdb\n\u251c\u2500\u2500 kafka\n\u251c\u2500\u2500 kingbase8\n\u251c\u2500\u2500 kudu\n\u251c\u2500\u2500 kylin\n\u251c\u2500\u2500 kylinrestful\n\u251c\u2500\u2500 libra\n\u251c\u2500\u2500 maxcompute\n\u251c\u2500\u2500 mongo\n\u251c\u2500\u2500 mysql5\n\u251c\u2500\u2500 mysql8\n\u251c\u2500\u2500 oceanbase\n\u251c\u2500\u2500 opentsdb\n\u251c\u2500\u2500 oracle\n\u251c\u2500\u2500 phoenix\n\u251c\u2500\u2500 phoenix4_8\n\u251c\u2500\u2500 phoenix5\n\u251c\u2500\u2500 postgresql\n\u251c\u2500\u2500 presto\n\u251c\u2500\u2500 redis\n\u251c\u2500\u2500 restful\n\u251c\u2500\u2500 s3\n\u251c\u2500\u2500 socket\n\u251c\u2500\u2500 solr\n\u251c\u2500\u2500 spark\n\u251c\u2500\u2500 sqlServer\n\u251c\u2500\u2500 sqlServer2017\n\u251c\u2500\u2500 vertica\n\u2514\u2500\u2500 websocket\n")),(0,i.kt)("h2",{id:"1-\u4ec5\u4f7f\u7528taier\u7684web\u548cui\u955c\u50cf"},"1. \u4ec5\u4f7f\u7528taier\u7684web\u548cui\u955c\u50cf"),(0,i.kt)("p",null,"\u4ec5\u4f7f\u7528taier\u7684web\u548cui\uff0c\u786e\u4fdd\u4ee5\u4e0b\u73af\u5883\u6b63\u5e38:"),(0,i.kt)("ul",{className:"contains-task-list"},(0,i.kt)("li",{parentName:"ul",className:"task-list-item"},(0,i.kt)("input",{parentName:"li",type:"checkbox",checked:!0,disabled:!0})," ","\u5916\u90e8\u7684mysql\uff0c\u521d\u59cb\u5316\u597dtaier\u7684\u6570\u636e\u5e93\u6570\u636e  "),(0,i.kt)("li",{parentName:"ul",className:"task-list-item"},(0,i.kt)("input",{parentName:"li",type:"checkbox",checked:!0,disabled:!0})," ","\u5916\u90e8\u7684zookeeper\uff0c\u53ef\u4ee5\u6b63\u5e38\u8fde\u63a5")),(0,i.kt)("p",null,"\u83b7\u53d6taier\u955c\u50cf "),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"$ docker pull dtopensource/taier:1.1\n$ docker pull dtopensource/taier-ui:1.1\n")),(0,i.kt)("p",null,"\u542f\u52a8web\u5bb9\u5668,mysql\u548czookeeper\u7684\u914d\u7f6e\u4fe1\u606f\u6839\u636e\u5b9e\u9645\u73af\u5883\u8c03\u6574"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"docker run -itd -p 8090:8090 --env ZK_HOST=172.16.85.111 \\\n--env ZK_PORT=2181 \\\n--env DB_HOST=172.16.101.187 \\\n--env DB_PORT=3306 \\\n--env DB_ROOT=root  \\\n--env DB_PASSWORD=123456 \\\n--env DATASOURCEX_PATH=/usr/taier/datasourcex \\\n-v /opt/dtstack/DTPlugin/InsightPlugin/dataSourcePlugin:/usr/taier/datasourcex \\\ndtopensource/taier:1.1\n")),(0,i.kt)("p",null,"\u542f\u52a8ui\u5bb9\u5668\nTAIER_IP \u4e3a\u542f\u52a8web\u5bb9\u5668ip"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"docker run -itd -p 80:80 --env TAIER_IP=172.16.100.38 \\\n--env TAIER_PORT=8090 \\\ndtopensource/taier-ui:1.1\n")),(0,i.kt)("p",null,"\u5f53\u547d\u4ee4\u6267\u884c\u5b8c\u6210\u540e\uff0c\u5728\u6d4f\u89c8\u5668\u4e0a\u76f4\u63a5\u8bbf\u95ee 127.0.0.1 \u5373\u53ef"),(0,i.kt)("div",{className:"admonition admonition-caution alert alert--warning"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",viewBox:"0 0 16 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"}))),"caution")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"\u8bbf\u95ee\u9875\u9762 \u5982\u679c\u6d4f\u89c8\u5668\u51fa\u73b0502\uff0c\u8bf7\u624b\u52a8\u786e\u8ba4ui\u5bb9\u5668\u662f\u5426\u548cweb\u5bb9\u5668\u7f51\u7edc\u662f\u5426\u4e92\u901a"))),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"\u5982\u679cweb\u5bb9\u5668\u548cui\u5bb9\u5668\u90fd\u540c\u53f0\u670d\u52a1\u5668\u4e0a\uff0cui\u5bb9\u5668\u9700\u8981\u8bbf\u95ee\u5bbf\u4e3b\u8ba5\u7f51\u7edc \u8bf7\u4fee\u6539\u9632\u706b\u5899\u7b56\u7565  "),(0,i.kt)("pre",{parentName:"div"},(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"firewall-cmd --zone=public --add-port=8090/tcp --permanent    \nfirewall-cmd --reload  \n")))),(0,i.kt)("h2",{id:"2-\u4f7f\u7528docker-compose"},"2. \u4f7f\u7528docker-compose"),(0,i.kt)("p",null,"\u83b7\u53d6Taier\u6700\u65b0\u7684docker-compose\u6587\u4ef6"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-yaml"},"version: '3'\nservices:\n  taier-db:\n    image: dtopensource/taier-mysql:1.1\n    environment:\n      MYSQL_DATABASE: taier\n      MYSQL_ROOT_PASSWORD: 123456\n  taier-zk:\n    image: zookeeper:3.4.9\n  taier-ui:\n    image: dtopensource/taier-ui:1.1\n    ports:\n      - 80:80\n    environment:\n      TAIER_IP: taier\n      TAIER_PORT: 8090\n  taier:\n    image: dtopensource/taier:1.1\n    environment:\n      ZK_HOST: taier-zk\n      ZK_PORT: 2181\n      DB_HOST: taier-db\n      DB_PORT: 3306\n      DB_ROOT: root\n      DB_PASSWORD: 123456\n      DATASOURCEX_PATH: /usr/taier/datasourcex\n    volumes:\n        - /data/datasourcex:/usr/taier/datasourcex\n")),(0,i.kt)("p",null,"\u8fdb\u5165docker-compose\u76ee\u5f55\uff0c\u6267\u884c"),(0,i.kt)("pre",null,(0,i.kt)("code",{parentName:"pre",className:"language-shell"},"$ docker-compose up -d\n")),(0,i.kt)("p",null,"\u5f53\u547d\u4ee4\u6267\u884c\u5b8c\u6210\u540e\uff0c\u5728\u6d4f\u89c8\u5668\u4e0a\u76f4\u63a5\u8bbf\u95ee 127.0.0.1 \u5373\u53ef"),(0,i.kt)("div",{className:"admonition admonition-tip alert alert--success"},(0,i.kt)("div",{parentName:"div",className:"admonition-heading"},(0,i.kt)("h5",{parentName:"div"},(0,i.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,i.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"12",height:"16",viewBox:"0 0 12 16"},(0,i.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z"}))),"tip")),(0,i.kt)("div",{parentName:"div",className:"admonition-content"},(0,i.kt)("p",{parentName:"div"},"\u5982\u679c\u6709\u4f7f\u7528\u5230chunjun\u63d2\u4ef6\u5305\uff0c\u53ef\u4ee5\u81ea\u884c\u6302\u8f7d\u76f8\u5173\u76ee\u5f55\uff0c\u5e76\u5728flink\u7ec4\u4ef6\u4e0a\u914d\u7f6e\u5bf9\u5e94\u76ee\u5f55"))))}u.isMDXComponent=!0}}]);