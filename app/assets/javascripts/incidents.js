var defaultZoom=13;

var mapIncidents = function() {
	mapWrap.resetMarkersList();
	// Load all the incidents coordinates into the map
	var items = $('#itemlist .kind-group').children('.item');

	for(var idx =0; idx < items.length; idx++) {
		var lat = $($(items[idx]).children('.lat')[0]).text();
		var lon = $($(items[idx]).children('.lon')[0]).text();
	
		var itemDescription = $($(items[idx]).children('.extended-incident')[0]).html();
	
		mapWrap.addCoordinatesAsMarkerToList(lat, lon, itemDescription, function(content) {
			if($('#itemlist').is(':visible')) {
				$('#itemlist').toggle();
				$('#submenu').toggle();
			}
			if(!$('#itemdetails').is(':visible')) {
				$('#submenu').toggle();
				$('#itemdetails').toggle();
			}
			$('#itemdetails').html(content);
		});
	}
}

$(document).ready(function(){
	
	// map to zoom
	mapWrap.placeViewportAt({zoom: defaultZoom});
	mapIncidents();
	
	$('#incident_kind').change(function() {
		var selected = $(this).val();
		var matchingString = "incident-"+selected;
		$('.incident-selectable').hide();
		$('.'+matchingString).toggle();
	});
	
	$('.itemlist-toggle').live('click', function() {
		$('#submenu').toggle();
		$("#itemlist").toggle();
		$('#'+$('#default-group').text()).click();
	});
	
	$('.group-toggle').live('click', function() {
		var group = $(this).attr('id');
		$('.kind-group').hide();
		$('.'+group).toggle();
		$('.group-toggle').removeClass('selected');
		$(this).addClass('selected');
	});
	
	$('.itemdetails-toggle').live('click', function() {
		$('#itemlist').toggle();
		$('#itemdetails').toggle();
		$('#itemdetails').html($(this).siblings('.extended-incident').html());
	});
	
	$('.itemsfiltering-toggle').live('click', function() {
		$('#submenu').toggle();
		$('#itemsfiltering').slideToggle();
	});
	
	$('#itemsfiltering .close-button').live('click', function() {
		$('#itemsfiltering').slideToggle();
		$('#submenu').show(600);
	});
	
	$('#filtering-start').live('click', function() {
		var kinds = $('#filtering-kind-list').children(":checkbox:checked");
		return kinds.length>0;
	})
	
	$('#itemdetails .close-button').live('click', function() {
		mapWrap.placeViewportAt({zoom: defaultZoom});
		$('#itemdetails').toggle();
		$('#itemdetails').empty();
		$('#submenu').toggle();
	});
	
	$('#itemdetails .back-button').live('click', function() {
		$('#itemdetails').toggle();
		$('#itemdetails').empty();
		$('#itemlist').toggle();
	});
	
	$('#itemlist .close-button').live('click', function() {
		mapWrap.placeViewportAt({zoom: defaultZoom});
		$('#itemlist').toggle();
		$('#submenu').toggle();
	});
	
	$('.status').hide().delay(1500).fadeIn(1500);
	
	if(!$.isBlank('#notifications')) {
		$("#submenu").hide();
		$('#notifications').fadeIn().delay(3000).fadeOut(2000);
		$("#submenu").delay(5000).fadeIn(500);
	} 
	
	
	$('#itemlist').draggable({cursor: 'move'});
	$('#itemdetails').draggable({cursor: 'move'});
	$('#newitem').draggable({cursor: 'move'});

	// go to the location this incident took place
	$('.show-on-map').live('click', function() {
		var lat = $($(this).siblings('.lat')[0]).text();
		var lon = $($(this).siblings('.lon')[0]).text();
		mapWrap.placeViewportAt({lat: lat, lon: lon, zoom:19});
	});
	
});