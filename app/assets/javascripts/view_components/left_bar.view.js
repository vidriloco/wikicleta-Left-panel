$.extend(ViewComponents, {
    LeftBar: {
			initialize: function() {
				var mainBar = this.widthForBar('main');
				var dynBar = this.widthForBar('dyn');
				var instance = this;

				$(this._dynamicBarDom()).draggable({
					revert: function(opt) {
						return instance.colapsed = false;
					},
					handle: '.handle',
					cursor: 'move', 
					axis: 'x', 
					containment: [mainBar-dynBar+20,0,dynBar/2,0]
				});
				
				$(this._handle()).click(function() {
					
					var dynBarPosX = instance._dinBarXPos();
					if(instance.lastXPos == dynBarPosX) {
						if(instance.colapsed) {
							instance.expand();
						} else {
							instance.collapse();
						}
						return true;
					}
					
					// expand or collapse the bar depending on it's position
					// relative to it's own width/2 and main bar width (when dragging)
					if(dynBarPosX > dynBar/2-mainBar) {
						// expand the bar
						instance.expand();
					} else {
						// collapse the bar
						instance.collapse();
					}

				});
				this.reset();
			},
			
			expand: function() {
				var movement="+="+(this.widthForBar('dyn')/2-this._dinBarXPos());
				this._animateBarWith(movement);
				this.colapsed = false;
			},
			
			collapse: function() {
				var movement="+="+(this.widthForBar('main')-this.widthForBar('dyn')+20-this._dinBarXPos());
				this._animateBarWith(movement);
				this.colapsed = true;
			},
			
			setSectionSelected: function(section) {
				$('.menu .options #incidents-'+section).addClass('selected');
			},
			
			hide: function() {
				$(this._dynamicBarDom()).hide();
			},
			
			show: function() {
				$(this._dynamicBarDom()).fadeIn();
			},
			
			clearSelected: function() {
				$('.menu .options a').removeClass('selected');
			},
			
			_dinBarXPos: function() {
				var parent = $($(this._handle()).parent());
				return parent.offset().left;
			},
			
			_animateBarWith:function(movement) {
				var instance = this;
				var parent = $($(this._handle()).parent());
				parent.animate({
				    left: movement
				  }, 700, function() {
					instance._setLastXPosition();
				});
			},
			
			_mainBarDom: function() {
				return '#main-bar';
			},
			
			_dynamicBarDom: function() {
				return '#dynamic-bar';
			},
			
			_handle: function() {
				return '.handle';
			},
			
			_setLastXPosition: function() {
				this.lastXPos = $($(this._handle()).parent()).offset().left;
			},
			
			widthForBar: function(bar) {
				if(bar=="main") {
					return $(this._mainBarDom()).width();
				} else if(bar=="dyn") {
					return $(this._dynamicBarDom()).width();
				}
			},
			
			reset: function() {
				this.colapsed = true;
				var left=(this.widthForBar('main')-20)*-1;
				$(this._dynamicBarDom()).hide();
				$(this._dynamicBarDom()).css({left: left});
				$(this._dynamicBarDom()).fadeIn(600);
				this._setLastXPosition();
			}
		}
});
