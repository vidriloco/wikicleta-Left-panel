var mapWrap;
var zoomForDetails = 16;
var defaultZoom=13;

$(document).ready(function() {
	/* Map initialization BEGIN */  
	var mapDefaultOpts = {
		center: new google.maps.LatLng(parseFloat(19.434780), parseFloat(-99.133072)),
		zoom: 16,
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		streetViewControl: true,
		mapTypeControl: false,
		navigationControl: false,
		navigationControlOptions: {
			position: google.maps.ControlPosition.TOP_RIGHT
		},
		zoomControlOptions: { style: google.maps.ZoomControlStyle.SMALL }
	};

	// domPoint will be appended with "_lat" and "_lon" 
	var mapInteractionOpts = {
		"domEditable" : ".is-editable",
		"domAddress" : "p.address",
		"pointsMode" : ".displays-points",
		"domPoint" : "#coordinates"
	}

	mapWrap = new Geo.Wrappers.Map(new google.maps.Map(document.getElementById("map"), mapDefaultOpts), mapInteractionOpts);
	
	if(!$.isBlank('#messages')) {
		$("#submenu").hide();
		$('#messages').fadeIn().delay(3000).fadeOut(2000);
		$("#submenu").delay(5000).fadeIn(500);
	}
	
	if(!$.isBlank('#notifications')) {
		$("#submenu").hide();
		$('#notifications').fadeIn().delay(3000).fadeOut(2000);
		$("#submenu").delay(5000).fadeIn(500);
	}
	
	if(!$.isBlank('#alerts')) {
		$("#submenu").hide();
		$('#alerts').fadeIn().delay(3000).fadeOut(2000);
		$("#submenu").delay(5000).fadeIn(500);
	}
	
});