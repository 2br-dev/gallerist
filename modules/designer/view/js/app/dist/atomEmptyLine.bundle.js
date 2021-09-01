(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{366:function(t,e,s){"use strict";var i=s(7),a=s(156);s(1);e.a={data:()=>({body:null}),mounted(){this.body=document.querySelector("body")},methods:{getData(){return this.getAtomData(this.blockId,this.itemId)},getAttrs(){return this.getData().attrs},getAttrValue(t){let e=this.getAttrs()[t];try{return e||console.error(lang.t(`Не найден аттрибут "${t}" для атома c id ${this.itemId} в блоке ${this.blockId}`)),e.value}catch(s){console.info("name",t),console.info("attr",e),console.error(s)}},getCSSValue(t){return this.getData().css[t].value},getAdditionalClass(){return this.getData().additional_class},getAtomClass(){let t=this.getAdditionalClass();return this.getAtomIdByBlockId()+(t?" "+t:"")},getHiddenClasses(){let t=this.getData().hidden,e=[];return Object.keys(t).forEach(s=>{t[s]&&e.push("d-hidden-"+s)}),e},getAtomIdByBlockId(){return"d-atom-"+this.blockId+"-"+this.itemId},getAtomTagId(){return"d-atom-tag-"+this.itemId},getAtomChildren(){return this.getData().childs},openAtomParams(){let t=setTimeout(()=>{if(clearTimeout(t),sessionStorage.getItem("atom-dbl-click"))return;let e=this.getMenuStack;if(e.length){let t=e[e.length-1];if("atom"==t.data.type&&t.data.blockId==this.blockId&&t.data.id==this.itemId)return}a.designerLeftMenu.openMenuForAtom({blockId:this.blockId,id:this.itemId,type:"atom"})},250);setTimeout(()=>{this.setOpenHover()},50)},setOpenHover(){document.querySelectorAll(".d-atom.hover").forEach(t=>{t.classList.remove("hover")}),this.$refs.thisAtom.classList.add("hover")},contentForTiny(){let t=this.getData(),e=t.html,s=t.tag,i=this.getStyle,a=[],o=[];Object.keys(i).forEach(t=>{"padding-top"==t||"padding-bottom"==t?o.push(t+":"+i[t]):a.push(t+":"+i[t])});let r=this.getClass;return`<div style="${o.join(";")}"><${s} id="${this.getAtomTagId()}" class="${r} ${this.getAtomIdByBlockId()}" style="${a.join(";")}">${e}</${s}></div>`},removeFlagDoubleClick(){sessionStorage.removeItem("atom-dbl-click")},setFlagDoubleClick(){sessionStorage.setItem("atom-dbl-click",1)},setCSSParamValue(t,e){let s=this.getData();s.css[t].value=e,this.setAtomData(s)},addRowEditClass(){this.body.classList.add("d-row-edit")},removeRowEditClass(){this.body.classList.remove("d-row-edit")},disableEditModeModules(){let t=this.body.querySelectorAll(".module-wrapper");t&&t.forEach(t=>{t.classList.add("disabled")}),this.$el.closest(".module-wrapper").classList.remove("disabled")},enableEditModeModules(){let t=document.querySelector("body").querySelectorAll(".module-wrapper");t&&t.forEach(t=>{t.classList.remove("disabled")})},setColumnDraggable(t){let e=new CustomEvent("atom-image-set-column-draggable",{detail:{enabled:t}});document.dispatchEvent(e)},setRedrawAtomListener(t){document.addEventListener("designer.redraw-atom."+this.itemId,t)},removeRedrawAtomListener(t){document.removeEventListener("designer.redraw-atom."+this.itemId,t)},...Object(i.b)(["closeLastPanel"]),...Object(i.b)("blocks",["setAtomData"])},computed:{getHtml(){return this.getData().html},content(){let t=this.getData(),e=t.html,s=t.tag;return`<${s} class="${this.getAtomIdByBlockId()}">${e}</${s}>`},contentWithoutClass(){let t=this.getData(),e=t.html,s=t.tag,i="";return this.getSpecialStyles&&(i="style='"+this.getSpecialStyles()+"'"),`<${s} ${i}>${e}</${s}>`},...Object(i.c)("blocks",["getAtomData"]),...Object(i.c)(["getMenuStack"])}}},410:function(t,e,s){"use strict";s.r(e);var i=function(){var t=this,e=t.$createElement,s=t._self._c||e;return s("div",{class:t.getHiddenClasses()},[s("AtomMarginZone",{attrs:{"block-id":t.blockId,"item-id":t.itemId}}),t._v(" "),s("div",{ref:"thisAtom",staticClass:"d-atom d-atom-emptyline",attrs:{id:t.getAtomIdByBlockId()},on:{click:function(e){return e.preventDefault(),e.stopPropagation(),t.openAtomParams(e)}}},[s("div",{staticClass:"d-atom-emptyline-zone",style:t.getWidthAlignData()},[s("div",{staticClass:"d-atom-instance"},[s("div",{ref:"atomItem",staticClass:"d-atom-item",class:t.getAtomClass()},[s("WidthResize",{attrs:{"block-id":t.blockId,"item-id":t.itemId}}),t._v(" "),s("div",{staticClass:"d-round-handler d-black",on:{mousedown:function(e){return!e.type.indexOf("key")&&t._k(e.keyCode,"left",37,e.key,["Left","ArrowLeft"])?null:"button"in e&&0!==e.button?null:(e.stopPropagation(),t.startDragHeight(e))},touchstart:function(e){return e.stopPropagation(),t.startDragHeight(e)}}},[s("span",{staticClass:"d-blow-pixels-wrapper"},["0px"!=t.pixels?s("span",{staticClass:"d-blow-pixels"},[t._v(t._s(t.pixels))]):t._e()])])],1)])])])],1)};i._withStripped=!0;var a=s(366),o=s(1),r={data:()=>({atom:null,pixels:"0px",marginTop:"0px",current_unit:"vh",marginTopStartY:0}),methods:{convertPixelsToVH:t=>t/window.innerHeight*100,getWidthAlignData(){let t=this.getData();return{width:t.css["max-width"].value?t.css["max-width"].value:"100%","align-self":this.getCSSValue("align-self")}},addDragClasses(){this.body.classList.add("designer-drag-mode")},removeDragClasses(){this.body.classList.remove("designer-drag-mode")},mouseDragHeightMove(t){let e=o.b.getMouseOrTouchMoveCoordinate(t,"y")-this.marginTopStartY;e<=20&&(e=20),e=Math.round(e),e-=e%10,e>1?(e*=2,this.pixels=e+"px"):this.pixels="0px",e=this.convertPixelsToVH(e)+this.current_unit,this.getData().css.height.value=e},prepareDragging(t){this.addDragClasses(),this.$refs.thisAtom.classList.add("drag-resize"),this.body.addEventListener(this.$mouseup,this.stopDrag)},startDragHeight(t){this.setColumnDraggable(!1),this.atom=document.getElementById(this.getAtomIdByBlockId()),this.prepareDragging(t),this.marginTopStartY=this.$refs.atomItem.getBoundingClientRect().top,this.body.addEventListener(this.$mousemove,this.mouseDragHeightMove),o.b.closeAllPanels(),t.preventDefault(),t.stopPropagation()},stopDrag(t){this.setColumnDraggable(!0),this.removeDragClasses();let e=this.getData();this.setAtomData(e),this.$refs.thisAtom.classList.remove("drag-resize"),this.body.removeEventListener(this.$mouseup,this.stopDrag),this.body.removeEventListener(this.$mousemove,this.mouseDragHeightMove)}},computed:{getMarginTopHeight(){let t=this.getData().css["margin-top"].value;return{height:t,"margin-bottom":"-"+t}}}},l=s(100),d=s(99),n={name:"AtomEmptyLine",mixins:[a.a,d.a,l.a,r],props:{itemId:{type:String,required:!0},colIndex:{type:Number,required:!0},blockId:{type:String,required:!0}},components:{AtomMarginZone:()=>s.e(21).then(s.bind(null,421)),WidthResize:()=>s.e(74).then(s.bind(null,422))}},m=s(98),h=Object(m.a)(n,i,[],!1,null,null,null);h.options.__file="-readyscript/modules/designer/view/js/app/src/components/designerblock/atoms/emptyline/emptyline.vue";e.default=h.exports}}]);