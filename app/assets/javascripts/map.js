//= require common/base
//= require view_components/left_bar.view
//= require view_components/geo/map
//= require sections/streets.js
//= require sections/incidents.js

var zoomForDetails = 16;
var defaultZoom=13;
var mapAtDom="map";
var searchCoords={lat:19.435672, lon: -99.133100 };
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
		
		section = new IncidentsSection();
		var IncidentsRouter = Backbone.Router.extend({

			routes: {
				"search"					: "search",
				"new"							: "newIncident",
				"results"					: "results",
				".*"							: "index",
				":incidents/:id"	: "show",
				":incidents"			: "selectedIndex"
			},

			newIncident: 				section.newIncident,
			index: 							section.index,
			show: 							section.loadIncident,
			selectedIndex: 			section.incidents,
			search: 						section.search,
			results: 						section.results
		});
		window.router = new IncidentsRouter();
		Backbone.history.start();
		
	} else if($.currentSectionIs('streets')) {
		section = new StreetsSection();	
		
		var StreetsRouter = Backbone.Router.extend({
			routes: {
				".*"							: "index"
			},

			index: 							section.index
		});
		
		window.router = new StreetsRouter();
		Backbone.history.start();	
		
	}
});