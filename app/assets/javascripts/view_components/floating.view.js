//= require view_components/base.view

$.extend(ViewComponents, {
    Floating: {
			_rootDom: '#floating',
			contents: "<div id='floating' class='rounded-5 shadow-lighter'></div>",
			
			append: function(dom, delay) {
				this.detach();
				
				$('body').append(this.contents);
				$(this._rootDom).append(dom);
				this._apply_effects(delay);
			},
			
			// makes visible a layer wich blocks the main content from user interaction
			// replaces with a simple content string
			/*withContent : function(content, delay, blocking) {
				this._clear_previous();
				if (blocking != undefined && blocking) {
					this._block_content();
				}
				this._replace_contents(content);
				this._apply_effects(delay);
			},*/
			
			detach : function() {
				if($.isDefined(this._rootDom)) {
					$(this._rootDom).remove();
				}
			},
			
			_block_content : function() {
				$('body').append("<div class='blocking'></div>");
			},
			
			_apply_effects : function(delay) {
				if(delay === undefined) {
					delay = 300;
				}
				$(this._rootDom).fadeIn(delay);
			}
		}
});