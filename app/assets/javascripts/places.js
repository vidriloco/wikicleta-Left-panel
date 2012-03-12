$(document).ready(function() {
	
	var requestPlaces = function() {
		var orderValue = $("#l-params").val();
		var selectedCategories = [];

		$(".cats").children('li').each(function(index) {
			var item = $($(this).children("input:checked")[0]);
			if(item.attr('class') == 'item') {
		  	selectedCategories.push(item.attr('id').split("-")[1]);
			}
		});
		// Response is yielded at index.js.erb (listings#places)		
		$.ajax({
		  type: "GET",
		  url: "places",
		  data: { filtered: true, ordered_by: orderValue, format : "js", categories: selectedCategories }
		});
	}
	
  $("#l-params").change(requestPlaces);
  $(".cats input").change(requestPlaces);
	
	$('.form-show-trigger').live('click', function() {
		if($('.form-area').hasClass('hidden')) {
			$('.form-area').removeClass('hidden');
		} 
	});
	
	$('.form-hide-trigger').live('click', function() {
		if(!$('.form-area').hasClass('hidden')) {
			$('.form-area').addClass('hidden');
		} 
	});

	$('.display-js-notification').live('click', function() {
		$('#messages').html($('#message').html());
		$('#messages').fadeIn(100).delay(4000).fadeOut(400);
	});
	
	if($.isDefined('.selectable-for-search')) {
		mapWrap.enableSearch("#coordinates_ne", "#coordinates_sw");
	}

	if($.isDefined('.search-box')) {
		$('.search-box').slideToggle();
	}

});