$.extend(ViewComponents, {
    LeftBar: {
			_mainBarDom: '#main-bar',
			_dynamicBarDom: '#dynamic-bar',
			
			initialize: function() {
				$(this._dynamicBarDom).css('left', '-230px');
				$(this._mainBarDom).css('left', '0px');
				this.colapsed = true;
			},
			
			expand: function() {
				if(this.colapsed) {
					$(this._dynamicBarDom).animate({
					    left: "+=230"
					  }, 700);
				
					$(this._mainBarDom).animate({
					    left: "-=260"
					  }, 500);
				}
				this.colapsed = false;
			},
			
			collapse: function(callback) {
				
				if(!this.colapsed) {
					$(this._dynamicBarDom).animate({
					    left: "-=230"
					  }, 500, callback);
				
					$(this._mainBarDom).animate({
					    left: "+=260"
					  }, 700);
				}
				this.colapsed = true;
			},
			
			setSectionSelected: function(section) {
				$('.menu .options #incidents-'+section).addClass('selected');
			},
			
			clearSelected: function() {
				$('.menu .options a').removeClass('selected');
			},
			
			reset: function() {
				$(this._dynamicBarDom).animate({
				    left: "-=230"
				  }, 500);
				$(this._mainBarDom).animate({
				    left: "-=250"
				  }, 700);
			}
		}
});