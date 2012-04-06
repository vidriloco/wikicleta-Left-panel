//= require view_components/base.view

$.extend(ViewComponents, {
    Notification: {
			_rootDom: function() {
				return '#notification';
			},
			
			contents: "<div id='notification' class='rounded-bottom-5 shadow-lighter'>$content$</div>",
	
			append: function(dom, delay) {
				this.detach();
				this._replace_contents("");
				dom.appendTo(this._rootDom());
				this._apply_effects(delay);
			},
			// makes visible a layer wich blocks the main content from user interaction
			// replaces with a simple content string
			withContent : function(content, delay, blocking) {
				this.detach();
				if (blocking != undefined && blocking) {
					this._block_content();
				}
				this._replace_contents(content);
				this._apply_effects(delay);
			},
			
			detach : function() {
				if($.isDefined(this._rootDom())) {
					$(this._rootDom()).remove();
				}
			},
			
			_block_content : function() {
				$('body').append("<div class='blocking'></div>");
			},
			
			_replace_contents : function(content) {
				contents = this.contents.replace("$content$", content);
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