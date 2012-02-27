$(document).ready(function(){
	
	$('#incident_kind').change(function() {
		var stolenBike = $('#stolen-activators').text().split("-");
		var problemWithVehicle = $('#vehicle-activators').text().split("-");
		var selected = $(this).val();
		$(".selectable").addClass("hidden");
		
		for(idx in stolenBike) {
			if(selected == stolenBike[idx]) {
				$("#stolen").removeClass("hidden");
			}
		}
		
		for(idx in problemWithVehicle) {
			if(selected == problemWithVehicle[idx]) {
				$("#vehicle").removeClass("hidden");
			}
		}
	});
	
	$('.itemlist-toggle').click(function() {
		$('#submenu').toggle();
		$("#itemlist").toggle();
		$('#'+$('#default-group').text()).click();
	});
	
	$('.group-toggle').click(function() {
		var group = $(this).attr('id');
		$('#itemlist .item').hide();
		$('.'+group).toggle();
		$('.group-toggle').removeClass('selected');
		$(this).addClass('selected');
	});
	
	$('.itemdetails-toggle').click(function() {
		$('#itemlist').toggle();
		$('#itemdetails').toggle();
		$('#itemdetails').html($(this).siblings('.extended-incident').html());
	});
	
	$('#itemdetails .close-button').live('click', function() {
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
		$('#itemlist').toggle();
		$('#submenu').toggle();
	});
	
	$('.status').delay(5000).fadeOut(1500);
	
	$('#itemlist').draggable({cursor: 'move'});
	$('#itemdetails').draggable({cursor: 'move'});
	
	var items = $('#itemlist').children('.item');
	
	for(var idx =0; idx < items.length; idx++) {
		var lat = $($(items[idx]).children('.lat')[0]).text();
		var lon = $($(items[idx]).children('.lon')[0]).text();
		
		var itemDescription = $($(items[idx]).children('.extended-incident')[0]).html();
		
		mapWrap.addCoordinatesAsMarkerToList(lat, lon, itemDescription, function(content) {
			if(!$('#itemdetails').is(':visible')) {
				$('#submenu').toggle();
				$('#itemdetails').toggle();
			}
			$('#itemdetails').html(content);
		});
	}
	
});