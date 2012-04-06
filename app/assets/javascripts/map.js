//= require common/base
//= require view_components/left_bar.view
//= require view_components/geo/map
//= require sections/incidents.js

var zoomForDetails = 16;
var defaultZoom=13;
var mapAtDom="map";
var mapOptions = {
	center: new google.maps.LatLng(parseFloat(19.434780), parseFloat(-99.133072)),
	zoom: zoomForDetails,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
	streetViewControl: true,
	mapTypeControl: false,
	navigationControl: false,
	navigationControlOptions: {
		position: google.maps.ControlPosition.TOP_RIGHT
	},
	zoomControlOptions: { style: google.maps.ZoomControlStyle.SMALL }
};

$(document).ready(function() {
	
	ViewComponents.LeftBar.initialize();
	
	if($.currentSectionIs('incidents'))  {
		Path.map("#/").to(Sections.Incidents.index);
		Path.map("#/new").to(Sections.Incidents.new);
		Path.map("#/:incidents(/:id)").to(Sections.Incidents.incidents);		
		Path.listen();
	}
	

});