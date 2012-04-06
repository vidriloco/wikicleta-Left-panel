var mapIncidents = function() {
	mapWrap.resetMarkersList();
	// Load all the incidents coordinates into the map
	var items = $('#itemlist .kind-group div').children('.item');

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

var fetchFromItemListAndZoomToMap = function(id, kind) {
	var postedItem = $($($('#itemlist').children(kind)[0]).children()[0]).children(id)[0];
	var lat = $($(postedItem).children('.lat')[0]).text();
	var lon = $($(postedItem).children('.lon')[0]).text();
	mapWrap.placeViewportAt({lat: lat, lon: lon, zoom:19});
}

$(document).ready(function(){
	// map to zoom
	map.placeViewportAt({zoom: defaultZoom});
	mapIncidents();
	
	var id = $('#just-posted .id').text();
	var kind = $('#just-posted .kind').text();
	if(id != "" && kind != "") {
		fetchFromItemListAndZoomToMap("#"+id, "."+kind);
	}
	
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
		$('#'+$(this).attr('id').split("-")[0]).click();
	});
	
	$('#itemlist .close-button').live('click', function() {
		mapWrap.placeViewportAt({zoom: defaultZoom});
		$('#itemlist').toggle();
		$('#submenu').toggle();
	});
	
	$('.status').hide().delay(1500).fadeIn(1500);
	
	$('#itemlist').draggable({cursor: 'move'});
	$('#itemdetails').draggable({cursor: 'move'});
	$('#newitem').draggable({cursor: 'move'});

	// go to the location this incident took place
	$('.show-on-map').live('click', function() {
		var lat = $($(this).siblings('.lat')[0]).text();
		var lon = $($(this).siblings('.lon')[0]).text();
		mapWrap.placeViewportAt({lat: lat, lon: lon, zoom:19});
	});
	
	var opts = {
		format: "%1 caracteres restantes"
	}
	
	$("#incident_description").charCounter(130, $.extend(opts, {
		container: "#incident_description_count",
	}));
	
	$("#incident_bike_description").charCounter(130, $.extend(opts, {
		container: "#incident_bike_description_count"
	}));
	
});