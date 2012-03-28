//= require jquery
//= require jquery_ujs
//= require jquery-ui-min
//= require modernizr-transitions
//= require jquery.masonry.min
//= require geo/base
//= require view_components/left.bar

$(document).ready(function() {
	
  $('#container').masonry({
    itemSelector : '.bike',
    columnWidth : 160,
		isAnimated: true,
	  animationOptions: {
	    duration: 750,
	    easing: 'linear',
	    queue: false
	  }
  });
	
});