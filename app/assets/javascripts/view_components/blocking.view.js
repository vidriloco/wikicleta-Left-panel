//= require view_components/base.view

$.extend(ViewComponents, {
    Blocking: {
			_rootDom: 		"body",
			contents: 		"<div id='blocking'></div>",
			blockingDiv: 	"#blocking",
			
			append: function(style) {
				this.detach();
				
				$(this._rootDom).append(this.contents);
				$(this.blockingDiv).addClass(style);
			},
			
			detach: function() {
				$(this.blockingDiv).remove();
			}
		}
});