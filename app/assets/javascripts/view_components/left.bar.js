$(document).ready(function() {
	var colapsed=false;
	
	if($.isDefined('#dynamic-bar')) {
		var mainBarWidth = $('#main-bar').width();
		var dynBarWidth = $('#dynamic-bar').width();
		$('#dynamic-bar').draggable({
			revert: function(opt) {
				return colapsed;
			},
			handle: '.handle',
			cursor: 'move', 
			axis: 'x', 
			containment: [mainBarWidth-dynBarWidth+20,0,dynBarWidth/2,0]
		});


		$('.handle').click(function() {
			var parent = $($('.handle').parent());
			var increment = null;
			var movement="+="+(parent.offset().left-mainBarWidth)*-1;
			if(!colapsed) {
				increment = parent.offset().left+dynBarWidth-mainBarWidth-20;
				movement="-="+increment+"";
			}
			colapsed = !colapsed;


			parent.animate({
			    left: movement
			  }, 1000, function() {
			    // Animation complete.
			  });
		});

		var reset = function() {
			colapsed = true;
			var left=(mainBarWidth-20)*-1;
			$('#dynamic-bar').hide();
			$('#dynamic-bar').css({left: left});
			$('#dynamic-bar').fadeIn(600);
		}
		reset();

	}
});
