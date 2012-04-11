//= require common/base
//= require modernizr-transitions
//= require jquery.masonry.min
//= require view_components/counter.view
//= require comments
//= require jquery.popover

$(document).ready(function() {
	// TODO: Make it work with pathjs
	var hashId = 'bike-'+window.location.hash.split("#")[1];
	if ( $.isDefined("#"+hashId) ) {
		document.getElementById(hashId).scrollIntoView();
	}
	
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
	
	ViewComponents.Counter.forDomElement('#bike_description');
	//$('.requires_login')
	$('.heart').live('click', function() {
		$('.tipsy').fadeOut();
		if($(this).hasClass('requires_login')) {
			return false;
		}
		var id = $(this).attr('id');
		
		var type = "POST";
		if($(this).hasClass('strong')) {
			type = "DELETE";
		}
		
		$.ajax({
		  type: type,
		  url: "/bikes/"+id+"/like",
		  data: { format : "js" }
		});
	});
	
	$('.heart').tipsy({gravity: 'n', live: true, fade: true, delayIn: 100, delayOut: 500 });
	$('.contact').tipsy({gravity: 's', live: true, fade: true, delayIn: 100, delayOut: 500 });

	if($.isDefined('#bike_frame_number')) {
		$('#bike_frame_number').popover({ content: $('.frame_number_help').text(), title: 'Ayuda', position: 'right' });
	}
	
	$('#submit-with-photo').click(function() {
		ViewComponents.Notification.put("<p class='success'>Espera por favor, guardando bici ... </p>", {delay: 60000, blocking: true});
	});
	
});