var mapWrap;

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
		"domPoint" : "#coordinates",
		"searchMode" : ".selectable-for-search",
		"neDOM" : "#coordinates_ne",
		"swDOM" : "#coordinates_sw"
	}

	mapWrap = new MapWrapper(new google.maps.Map(document.getElementById("map"), mapDefaultOpts), mapInteractionOpts);
});