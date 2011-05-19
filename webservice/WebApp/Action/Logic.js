var WebApp=(function(){var A_=setTimeout;var B_=setInterval;var L2R=+1;var R2L=-1;var HEAD=0;var HOME=1;var BACK=2;var LEFT=3;var RIGHT=4;var TITLE=5;var _def,_headView,_head;var _webapp,_group,_bdo,_bdy;var _maxw,_maxh;var _KK=-1;var _LL=-1;var _MM=[];var _NN=[];var _OO=[];var _PP=[];var _QQ=[];var _RR=[];var _SS=[];var _TT=history.length;var _UU=0;var _VV=false;var _WW="";var _XX="";var _YY=0;var _ZZ=0;var _aa=0;var _bb=1;var _cc=null;var _dd=!(!document.getElementsByClassName)&&_H("WebKit",navigator.userAgent);var _ee=false;var _ff="";var _gg={}
_gg.load=[];_gg.beginslide=[];_gg.endslide=[];_gg.error=[];_gg.success=[];_gg.orientationchange=[];_gg.tabchange=[];__p={Proxy:function(url){_ff=url},HideBar:function(){window.scrollTo(0,1);return false},Header:function(show,what){_D(show);_W(_headView,0);_headView=$(what);_W(_headView,!show);return false},Tab:function(id,active){var o=$(id);_m(o,$$("li",o)[active])},AddEventListener:function(evt,handler){if(typeof _gg[evt]!="undefined")if(_gg[evt].indexOf(handler)==-1)_gg[evt].push(handler)},Toggle:function(){if(_NN.length>1){if(_LL==_NN.length-1){_z();history.back()}else{_z();history.forward()}}return false},Back:function(){if(_VV)return(_VV=false);if(history.length-_TT==_LL){_z();history.back()}else{_z();location=_MM[_LL-1]||"#"}return false},Home:function(){if(history.length-_TT==_LL){_z();history.go(-_LL)}else{_z();location="#"}return(_VV=false)},Form:function(frm){var s,a,b,c,o,k,f;a=$(frm);b=$(_NN[_LL]);s=(a.style.display!="block");f=_L(a)=="form"?a:_R(a,"form");k=f.onsubmit;if(!s){f.onsubmit=f.onsubmit(null,true)}else{a.style.top=_group.offsetTop-2+"px";f.onsubmit=function(e,b){if(b)return k;if(k)k(e);e.preventDefault();__p.Submit(this)}}
_z();_Z(s,_group.offsetTop);_W(a,s);o=$$("legend",a)[0];_v(s&&o?o.innerHTML:null);_cc=(s)?a:null;if(s){c=a;a=b;b=c}
_F(a);_E(b,s);if(s)__p.Header(s);else _D(!s);return false},Submit:function(frm){var a=arguments[1];var e=arguments[2];var f=$(frm);if(f&&_L(f)!="form")f=_R(f,"form");if(f){var _=function(i,f){var q="";for(var n=0;n<i.length;n++)if(i[n].name&&!i[n].disabled&&(f?f(i[n]):1))q+="&"+i[n].name+"="+encodeURIComponent(i[n].value);return q}
var q=_($$("input",f),function(i){with(i)return((_H(type,["text","password","hidden","search"])||(_H(type,["radio","checkbox"])&&checked)))}
);q+=_($$("select",f));q+=_($$("textarea",f));e=e||event;a=!a?_K(e.target):a;if(!a)_C();q+="&"+(a&&a.id?a.id:"__submit")+"=1";q=q.substr(1);_7(f.action||self.location.href,null,q);if(_cc)__p.Form(_cc)}return false},Postable:function(keys,values){var q="";for(var i=1;i<values.length&&i<=keys.length;i++)q+="&"+keys[i-1]+"="+encodeURIComponent(values[i]);return q.replace(/&=/g,"&").substr(1)},Request:function(url,prms,cb,async,loader){cb=cb==-1?_8():cb;var o=new XMLHttpRequest();var c=function(){_CC(o,cb,loader)}
var m=prms?"post":"get";async=!!async;if(loader)__p.Loader(loader,true);_SS[_SS.length]=[o,url,prms,arguments[5]];url=_6(url,"__async","true");url=_6(url,"__source",_NN[_LL]);url=_4(url);o.open(m,url,async);if(prms)o.setRequestHeader("Content-Type","application/x-www-form-urlencoded");o.onreadystatechange=(async)?c:null;o.send(prms);if(!async)c()},Loader:function(obj,show){var o=obj;var h=_N(o,"__lod");if(h==show)return h;if(show){_P(o,"__lod");_PP.push(o)}else _Q(o,"__lod");_B(o);return h},Player:function(src){src=src||_K(event.target).href;if(!_h()){window.open(src)}else{if(_dd)location="#"+Math.random();var w=$("__wa_media");var o=_J("iframe");o.id="__wa_media";o.src=src;_webapp.appendChild(o);if(w)_webapp.removeChild(w)}return false}}
function _A(s,w,dir,step,mn){s+=Math.max((w-s)/step,mn||4);return[s,(w+w*dir)/2-Math.min(s,w)*dir]}
function _B(o){if(_N(o,"iMore")){var a=$$("a",o)[0];if(a&&a.title){o=a.innerHTML;a.innerHTML=a.title;a.title=o}}
}
function _C(){var i=_J("input");_group.appendChild(i);i.type="text";i.focus();_W(i,0);A_(_group.removeChild,5,i)}
function _D(s){if(_head){for(var i=1;i<_RR.length;i++)_W(_RR[i],s);_W(_RR[BACK],s&&!_RR[LEFT]&&_LL);_W(_RR[HOME],s&&!_RR[RIGHT]&&!_VV&&_LL>1)}}
function _E(lay,ignore){if(_head){var a=$$("a",lay);var p=RIGHT;for(var i=0;i<a.length&&p>=LEFT;i++){if(_RR[p]&&!ignore){i--;p--;continue}if(_M(a[i].rel,"action")||_M(a[i].rel,"back")){_P(a[i],p==RIGHT?"iRightButton":"iLeftButton");_W(a[i],1);_RR[p--]=a[i];_head.appendChild(a[i--])}}
}}
function _F(lay){if(_head){for(var i=LEFT;i<=RIGHT;i++){var a=_RR[i];if(a&&(_M(a.rel,"action")||_M(a.rel,"back"))){_W(a,0);_Q(a,i==RIGHT?"iRightButton":"iLeftButton");lay.insertBefore(a,lay.firstChild)}}
_RR[RIGHT]=$("waRightButton");_RR[LEFT]=$("waLeftButton")}}
function _G(s){return s.replace(/<.+?>/g,"").replace(/^\s+|\s+$/g,"").replace(/\s{2,}/," ")}
function _H(o,a){return a.indexOf(o)!=-1}
function _I(o){return _M(o.rev,"async")||_M(o.rev,"async:np")}
function $(i){return typeof i=="string"?document.getElementById(i):i}
function $$(t,o){return(o||document).getElementsByTagName(t)}
function _J(t){return document.createElement(t)}
function _K(o){return _L(o)=="a"?o:_R(o,"a")}
function _L(o){return o.localName.toLowerCase()}
function _M(o,t){return o&&_H(t,o.toLowerCase().split(" "))}
function _N(o,c){return o&&_H(c,_O(o))}
function _O(o){return o.className.split(" ")}
function _P(o,c){var h=_N(o,c);if(!h)o.className+=" "+c;return h}
function _Q(o){var c=_O(o);var a=arguments;for(var i=1;i<a.length;i++){var p=c.indexOf(a[i]);if(p!=-1)c.splice(p,1)}
o.className=c.join(" ")}
function _R(o,t){while((o=o.parentNode)&&(o.nodeType!=1||_L(o)!=t));return o}
function _S(o,c){while((o=o.parentNode)&&(o.nodeType!=1||!_N(o,c)));return o}
function _T(o){var o=o.childNodes;for(var i=0;i<o.length;i++)if(o[i].nodeType==3)return o[i].nodeValue.replace(/^\s+|\s+$/g,"");return null}
function _U(){if(!_webapp||!_group){_webapp=$("WebApp");_group=$("iGroup")}}
function _V(){_U();_RR[HEAD]=$("iHeader");_RR[BACK]=$("waBackButton");_RR[HOME]=$("waHomeButton");_RR[RIGHT]=$("waRightButton");_RR[LEFT]=$("waLeftButton");_RR[TITLE]=$("waHeadTitle");_bdy=document.body;_bdo=(_bdy.dir=="rtl")?-1:+1}
function _W(o,s){if(o)o.style.display=s?"block":"none"}
function _X(o){_W(o,1);o.style.width="100%"}
function _Y(o){o=o||$(_3());if(o){var z=$$("div",o);if(z[0]&&_N(z[0],"iList")){_P(o,"__lay");o.style.minHeight=parseInt(_webapp.style.minHeight)-_group.offsetTop+"px"}else _Q(o,"__lay")}}
function _Z(s,p){var o=$("__wa_shadow");o.style.top=p+"px";_W(o,s)}
function _a(){if(!_YY++)_W($("__wa_noclick"),1)}
function _b(){if(!--_YY)_W($("__wa_noclick"),0)}
function _c(o,l){if(o){_NN.splice(++_LL,_NN.length);_NN.push(o);_MM.splice(_LL,_MM.length);_MM.push(l?location.hash:null);_OO.splice(_LL,_OO.length);_OO.push(_bb)}}
function _d(){var s,i,c;while(s=_PP.pop())__p.Loader(s,0);s=$$("li");for(i=0;i<s.length;i++)if(_N(s[i],"__sel"))_Q(s[i],"__sel")}
function _e(s,np){var ed=s.indexOf("#_");if(ed==-1)return null;var rs="";var bs=_5(s);if(!np)for(var i=0;i<bs[1].length;i++)rs+="/"+bs[1][i].split("=").pop();return bs[2]+rs}
function _f(o,cb){A_(function(){if(_QQ.indexOf(o)!=-1)_f(o,cb);else cb()},5)}
function _g(o,show,cb,sp,nx){if(!nx){if(!o){if(cb)cb();return}else if(_QQ.indexOf(o)!=-1)return;else _QQ.push(o)}if(!sp)sp=0.5;with(o.style){if((!show&&opacity>0)||(show&&opacity<1)){if(show)display="block";opacity=parseFloat(opacity)+(show?+sp:-sp);A_(_g,0,o,show,cb,sp,1)}else{display=(opacity==0)?"none":"block";_QQ.splice(_QQ.indexOf(o),1);if(cb)cb()}}
}
function _h(){with(navigator.userAgent)return(indexOf("iPhone")+indexOf("iPod")+indexOf("Aspen")>-3)}
function _i(){_U();if(_UU||!_webapp||!_group)return;var w=(window.innerWidth>=_maxh)?_maxh:_maxw;if(w!=_ZZ){_ZZ=w;_webapp.className=(w==_maxw)?"portrait":"landscape";_Y();_k("orientationchange")}
var h=window.innerHeight;var m=((_ZZ==_maxw)?416:268);h=(h<m)?m:h;if(h!=_aa){_aa=h;_webapp.style.minHeight=(1+h)+"px"}}
function _j(){if(_UU||_VV==location.href)return;_VV=false;var act=_3();if(act==null)if(location.hash.length>0)return;else act=_NN[0];var pos=_NN.indexOf(act);var cur=_NN[_LL];if(act==cur)return;if(pos!=-1&&pos<_LL){_LL=pos+1;_q(cur,act,L2R)}else{_p(act)}}
function _k(evt,ctx,obj){var l=_gg[evt].length;if(l==0)return true;var e={}
e.type=evt;e.target=obj||null;e.context=ctx||_0(_MM[_LL]);e.windowWidth=_ZZ;e.windowHeight=_webapp.offsetHeight;var k=true;for(var i=0;i<l;i++)k=k&&(_gg[evt][i](e)==false?false:true);return k}
function _l(){_V();_JJ();_FF();_EE();_DD();_II("div","__wa_noclick");_II("div","__wa_shadow");var l=$("iLoader");if(l)_W(l,0);_maxw=screen.width;_maxh=screen.height;if(_maxw>_maxh){l=_maxh;_maxh=_maxw;_maxw=l}
_def=_1()[0].id;_c(_def);var a=_3();if(a!=_def)_c(a,true);if(!a)a=_def;_X($(a));_E($(a));_W(_RR[BACK],(!_RR[LEFT]&&_LL));_W(_RR[HOME],(!_RR[RIGHT]&&_LL>1&&a!=_def));if(_RR[BACK])_XX=_RR[BACK].innerHTML;if(_RR[TITLE]){_WW=_RR[TITLE].innerHTML;_RR[TITLE].innerHTML=_2($(a))}
B_(_j,100);A_(_k,100,"load");A_(_z,500)}
function _m(ul,li,h,ev){var c,s,al=$$("li",ul);for(var i=0;i<al.length;i++){c=(al[i]==li);if(c)s=i;_W($(ul.id+i),(!h&&c));_Q(al[i],"__act")}
_P(li,"__act");if(ev)_k("tabchange",[s],ul)}
function _n(e,b){if(_UU){e.preventDefault();return}
var o=e.target;var n=_L(o);if(n=="label"){var f=$(o.getAttribute("for"));if(_N(f,"iToggle"))A_(_y,1,f.previousSibling.childNodes[1],true);return}
var li=_R(o,"li");if(li&&_N(li,"iRadio")){_P(li,"__sel");_HH(li);return}
var ul=_R(o,"ul");var pr=!ul?null:ul.parentNode;var a=_K(o);var ax=a&&_I(a);if(ul&&_N(pr,"iTab")){var h=$(ul.id+"-loader");_W(h,0);if(ax){_W(h,1);_7(a,function(o){_W(h,0);_W($(_AA(o)[0]),1);_m(ul,li,null,1)}
)}else{h=null}
_m(ul,li,h,!ax);e.preventDefault();return}if(a&&!a.onclick&&_H(a.id,["waBackButton","waHomeButton"])){if(a.id=="waBackButton")__p.Back();else __p.Home();e.preventDefault();return}if(ul&&_N(ul,"iCheck")){var al=$$("li",ul);for(var i=0;i<al.length;i++)_Q(al[i],"__act","__sel");_P(li,"__act __sel");A_(_Q,1000,li,"__sel");e.preventDefault();return}if(ul&&!_N(li,"iMore")&&((_N(ul,"iMenu")||_N(pr,"iMenu"))||(_N(ul,"iList")||_N(pr,"iList")))){if(a&&!_N(a,"iButton")){var c=_P(li,"__sel");if(ax){if(!c)_7(a);e.preventDefault();return}}
}
var dv=_S(o,"iMore");if(dv){if(!__p.Loader(dv,1)&&_I(a))_7(a);e.preventDefault();return}if(a&&_cc&&!a.onclick){if(_M(a.rel,"back"))__p.Form(_cc,a);if(_M(a.rel,"action"))__p.Submit(_cc,a);e.preventDefault();return}if(a&&_M(a.rev,"media")){__p.Player(a.href);_o(li);e.preventDefault();return}if(ax){_7(a);e.preventDefault()}else if(a){var l=_H("#_",a.href);if(li||l){_z();A_(function(){location=a.href},li?1000:0);if(!l)_o(li);e.preventDefault()}}
}
function _o(li){if(li)A_(_Q,500,li,"__sel")}
function _p(to){if(_NN[_LL]!=to)_q(_NN[_LL],to);return false}
function _q(src,dst,dir){if(_UU)return;_a();if(dst==_NN[0])_TT=history.length;dir=dir||R2L;src=$(src);dst=$(dst);_Y(dst);_W($("iFooter"),0);_UU=1;_w(0,function(){_s(src,dst,dir)}
)}
function _r(d){return[_0(_MM[_KK]),_0(location.hash),d]}
function _s(src,dst,dir){_k("beginslide",_r(dir));_KK=_LL;_F(src);_E(dst);_JJ(dst);_FF(dst);var w=src.offsetWidth;var c,b=_bdy;_X(src);_P(b,"__wa_slideV1");if(dir*_bdo==L2R){A_(window.scrollTo,5,w,window.pageYOffset);c=src.cloneNode(true);_group.appendChild(c)}else if(_bdo==R2L){_X(dst)}
A_(function(){_X(dst);if(c){_group.removeChild(c)}if(dir==R2L){_group.insertBefore(src,dst);_c(dst.id,true)}else{_group.insertBefore(dst,src);while(_LL&&_NN[--_LL]!=dst.id){}}
A_(function(){var s=0;var i=B_(function(){if(s<=w){var z=_A(s,w,dir*_bdo,6,2);s=z[0];window.scrollTo(z[1],1);return}
clearInterval(i);c=dst.cloneNode(true);_group.insertBefore(c,dst.nextSibling);_W(src,0);A_(function(){_group.removeChild(c);_t(src,dst,dir)},5)},5)},5)},5)}
function _t(src,dst,dir){_d();if(_RR[BACK]){var txt;if(dir==R2L)txt=(_VV?"":_G(src.title))||_XX;else if(_LL)txt=_G($(_NN[_LL-1]).title)||_XX;if(txt)_RR[BACK].innerHTML=txt}
_W($("iFooter"),1);_v(_VV?dst.title:null);_Q(_bdy,"__wa_slideV1");_X(dst);_x(null,function(){_u(dir);_k("endslide",_r(dir));_KK=-1}
)}
function _u(dir){_b();A_(_z,0,(dir==L2R)?_OO[_LL+1]:null);_UU=0}
function _v(title){var o;if(o=_RR[TITLE]){o.innerHTML=title||_2($(_3()))||_WW}}
function _w(s,cb){_g(_head,0,function(){if(cb)cb();if(_cc)__p.Form(_cc);_W(_headView,0)},s?1:null)}
function _x(s,cb){_f(_head,function(){_W(_RR[BACK],!_RR[LEFT]&&_LL);_W(_RR[HOME],!_RR[RIGHT]&&_LL>1);_W(_RR[LEFT],1);_W(_RR[RIGHT],1);_D(1);_g(_head,1,cb,s?1:null)}
)}
function _y(o,dontChange){var i=$(o.parentNode.title);var txt=i.title.split("|");if(!dontChange)i.click();with(o.nextSibling){innerHTML=txt[i.checked?0:1];if(i.checked){o.style.left="";o.style.right="-1px";o.parentNode.className="iToggleOn";style.left=0;style.right=""}else{o.style.left="-1px";o.style.right="";o.parentNode.className="iToggle";style.left="";style.right=0}}
}
function _z(to){_bb=window.pageYOffset;var h=to?to:Math.min(50,_bb);var s=to?Math.max(1,to-50):1;var d=to?-1:+1;while(s<=h){var z=_A(s,h,d,6,2);s=z[0];window.scrollTo(0,z[1])}if(!to)__p.HideBar()}
function _0(loc){if(loc){var pos=loc.indexOf("#_");var vis=[];if(pos!=-1){loc=loc.substring(pos+2).split("/");vis=_1().filter(function(l){return l.id=="wa"+loc[0]}
)}if(vis.length){loc[0]=vis[0].id;return loc}}return[]}
function _1(){var lay=[];var src=_group.childNodes;for(var i=0;i<src.length;i++)if(src[i].nodeType==1&&_N(src[i],"iLayer"))lay.push(src[i]);return lay}
function _2(o){return(!_LL&&_WW)?_WW:o.title}
function _3(){var h=location.hash;return!h?_def:_0(h)[0]}
function _4(url){var d=url.match(/[a-z]+:\/\/(.+:.*@)?([a-z0-9-\.]+)((:\d+)?\/.*)?/i);return(!_ff||!d||d[2]==location.hostname)?url:_6(_ff,"__url=",url)}
function _5(u){var s,q,d;s=u.replace(/&amp;/g,"&");d=s.indexOf("#");d=s.substr(d!=-1?d:s.length);s=s.substr(0,s.length-d.length);q=s.indexOf("?");q=s.substr(q!=-1?q:s.length);s=s.substr(0,s.length-q.length);q=!q?[]:q.substr(1).split("&");return[s,q,d]}
function _6(u,k,v){u=_5(u);var q=u[1].filter(function(o){return o&&o.indexOf(k+"=")!=0}
);q.push(k+"="+encodeURIComponent(v));return u[0]+"?"+q.join("&")+u[2]}
function _7(item,cb,q){var h,o,u,i;i=(typeof item=="object");u=(i?item.href:item);o=_R(item,"li");if(!cb)cb=_8(u,_M(item.rev,"async:np"));__p.Request(u,q,cb,true,o,(i?item:null))}
function _8(i,np){return function(o){var u=i?_e(i,np):null;var g=_AA(o);if(g&&(g[1]||u)){_z();location=g[1]||u}else{A_(_d,250)}return null}}
function _9(o){var nds=o.childNodes;var txt="";for(var y=0;y<nds.length;y++)txt+=nds[y].nodeValue;return txt}
function _AA(o){if(o.responseXML){o=o.responseXML.documentElement;var s,t,k,a=_3();var g=$$("go",o);g=(g.length!=1)?null:g[0].getAttribute("to");var f,p=$$("part",o);if(p.length==0)p=[o];for(var z=0;z<p.length;z++){var dst=$$("destination",p[z])[0];if(!dst)break;var mod=dst.getAttribute("mode");var txt=_9($$("data",p[z])[0]);var i=dst.getAttribute("zone");if(dst.getAttribute("create")=="true"&&i.substr(0,2)=="wa"&&!$(i)){var n=_J("div");n.className="iLayer";n.id=i;_group.appendChild(n)}
f=f||i;g=g||dst.getAttribute("go");i=$(i||dst.firstChild.nodeValue);if(!k&&a==i.id){_w(1);_F(i);k=i}
_BB(i,txt,mod)}if(t=$$("title",o)[0]){var s=t.getAttribute("set");$(s).title=_9(t);if(a==s)_v(null,1)}if(k){_E(k);_x(1)}
var e=$$("script",o)[0];if(e)eval(_9(e));return[f,g?"#_"+g.substr(2):null]}
throw "Invalid asynchronous response received."}
function _BB(o,c,m){if(m=="append"){o.innerHTML+=c}else if(m=="replace"){o.innerHTML=c}else{var p=o.parentNode;var a=(m=="self")?o:_J("div");a.innerHTML=c;if(m!="self")p.insertBefore(a,m=="after"?o.nextSibling:o);while(a.hasChildNodes())p.insertBefore(a.firstChild,a);p.removeChild(a)}}
function _CC(o,cb,lr){if(o.readyState!=4)return;var er,ld,ob;er=(o.status!=200&&o.status!=0);if(!er){try{if(cb)ld=cb(o,lr)}
catch(ex){er=ex;console.error(er)}}if(lr){__p.Loader(lr,0);if(er)_Q(lr,"__sel")}if(ob=_SS.filter(function(a){return o==a[0]}
)[0]){_k(er?"error":"success",ob,ob.pop());_SS.splice(_SS.indexOf(ob),1)}}
function _DD(){var hd=_RR[HEAD];if(hd){var dv=_J("div");dv.style.opacity=1;while(hd.hasChildNodes())dv.appendChild(hd.firstChild);hd.appendChild(dv);_head=dv}}
function _EE(){var o=$$("ul");for(var i=0;i<o.length;i++){var p=o[i].parentNode;if(p&&_N(p,"iTab")){_P($$("li",o[i])[0],"__act");if(p=$(o[i].id+"0"))_W(p,1)}}
}
function _FF(p){var s="wa__radio";var o=$$("li",p);for(var i=0;i<o.length;i++){if(_N(o[i],"iRadio")&&!_N(o[i],"__done")){var lnk=_J("a");var sel=_J("span");var cpy=o[i].childNodes;var inp=$$("input",o[i]);for(var j=0;j<inp.length;j++){with(inp[j])if(type=="radio"&&checked){sel.innerHTML=_T(parentNode);break}}
lnk.appendChild(sel);while(o[i].hasChildNodes())lnk.appendChild(o[i].firstChild);o[i].appendChild(lnk);lnk.href="#";lnk.onclick=function(){_VV=location.href;return _p(s)}
_P(o[i],"__done")}}if(!$(s)){var d=_J("div");d.className="iLayer";d.id=s;_group.appendChild(d)}}
function _GG(a,p,u){var x=$$("input",p);var y=$$("a",u);var b;for(var i=0;i<y.length;i++)if(y[i]==a){x[i].checked=true;$$("span",p)[0].innerHTML=_T(x[i].parentNode);b=p.getAttribute("value");if(b&&b.toLowerCase()=="autoback")A_(__p.Back,0);break}}
function _HH(p){var o=$$("input",p);var dv=_J("div");var ul=_J("ul");ul.className="iCheck";for(var i=0;i<o.length;i++){if(o[i].type=="radio"){var li=_J("li");var a=_J("a");a.innerHTML=o[i].nextSibling.nodeValue;a.href="#";a.onclick=function(){_GG(this,p,ul)}
li.appendChild(a);ul.appendChild(li);if(o[i].checked)li.className="__act"}}
dv.className="iMenu";dv.appendChild(ul);o=$("wa__radio");if(o.firstChild)o.removeChild(o.firstChild);o.title=_T(p.firstChild);o.appendChild(dv)}
function _II(t,i){var o=_J(t);o.id=i;_webapp.appendChild(o);return o}
function _JJ(p){var o=$$("input",p);for(var i=0;i<o.length;i++){if(o[i].type=="checkbox"&&_N(o[i],"iToggle")&&!_N(o[i],"__done")){if(!o[i].id)o[i].id="__"+Math.random();if(!o[i].title)o[i].title="ON|OFF";var txt=o[i].title.split("|");var b1=_J("b");var b2=_J("b");var i1=_J("i");b1.className="iToggle";b1.title=o[i].id;b1.innerHTML="&nbsp;";i1.innerHTML=txt[1];b1.appendChild(b2);b1.appendChild(i1);o[i].parentNode.insertBefore(b1,o[i]);b2.onclick=function(){_y(this)}
_y(b2,true);_P(o[i],"__done")}}
}
B_(_i,100);addEventListener("load",_l,true);addEventListener("click",_n,true);return __p}
)();var WA=WebApp;