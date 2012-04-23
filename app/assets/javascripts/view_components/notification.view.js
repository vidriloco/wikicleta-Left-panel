//= require view_components/base.view

$.extend(ViewComponents, {
    Notification: {
			_rootDom: function() {
				return '#notification';
			},
			
			contents: "<div id='notification' class='rounded-bottom-5 shadow-lighter'>$content$</div>",
			
			detach : function() {
				if($.isDefined(this._rootDom())) {
					$(this._rootDom()).remove();
				}
			},
			
			append: function(domElement) {
				this.put("");
				domElement.appendTo($(this._rootDom()));
			},
			
			put: function(content, opts) {
				this.detach();
				
				this._replace_contents(content);
				
				if (opts) {
					if(opts.blocking != undefined && opts.blocking) {
						this._block_content();
					}
					
					if(opts.delay != undefined) {
						this._apply_effects(opts.delay);
					}
				}
				this._apply_effects();
			},
			
			_block_content : function() {
				// TODO when needed
			},
			
			_replace_contents : function(content) {
				contents = this.contents.replace("$content$", content);
				$('body').append(contents);
			},
			
			_apply_effects : function(delay) {
				if(delay === undefined) {
					delay = 4000;
				}
				$(this._rootDom()).slideToggle(300).delay(delay).slideToggle(300);
			}
		}
});