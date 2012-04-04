//= require view_components/base.view
//= require jquery.charcounter

$.extend(ViewComponents, {
    Counter: {
			forDomElement: function(dom, chars) {
				if(chars === undefined) {
					chars = this._maxCharacters();
				}
				$(dom).charCounter(chars, $.extend(this._format(), {
					container: dom+"_count",
				}));
			},
			_maxCharacters: function() {
				return 130;
			},
			_format: function() {
				return {format: "%1 caracteres restantes"};
			}
		}
});
