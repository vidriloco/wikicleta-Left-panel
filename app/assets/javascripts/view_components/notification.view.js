//= require view_components/base.view

var contents="<div id='notification' class='rounded-bottom-5 shadow-lighter'>$content$</div>";

$.extend(ViewComponents, {
    Notification: {
			_rootDom: function() {
				return '#notification';
			},
	
			append: function(dom, delay) {
				this._clear_previous();
				this._replace_contents("");
				dom.appendTo(this._rootDom());
				this._apply_effects(delay);
			},
			
			withContent : function(dom, delay, blocking) {
				this._clear_previous();
				if (blocking != undefined && blocking) {
					this._block_content();
				}
				this._replace_contents(dom);
				this._apply_effects(delay);
			},
			
			_clear_previous : function() {
				if($.isDefined(this._rootDom())) {
					$(this._rootDom()).remove();
				}
			},
			
			_block_content : function() {
				$('body').append("<div class='blocking'></div>");
			},
			
			_replace_contents : function(dom) {
				contents = contents.replace("$content$", dom);
				$('body').append(contents);
			},
			
			_apply_effects : function(delay) {
				if(delay === undefined) {
					delay = 4000;
				}
				$(this._rootDom()).slideToggle(300).delay(delay).slideToggle();
			}
		}
});