//= require common/base
//= require view_components/left_bar.view
//= require view_components/geo/map
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
		
		var IncidentsRouter = Backbone.Router.extend({

			routes: {
				"search"					: "search",
				"new"							: "newIncident",
				"results"					: "results",
				".*"							: "index",
				":incidents/:id"	: "show",
				":incidents"			: "selectedIndex"
			},

			newIncident: 				Sections.Incidents.newIncident,
			index: 							Sections.Incidents.index,
			show: 							Sections.Incidents.loadIncident,
			selectedIndex: 			Sections.Incidents.incidents,
			search: 						Sections.Incidents.search,
			results: 						Sections.Incidents.results
		});
		window.router = new IncidentsRouter();
		Backbone.history.start();
	}
});