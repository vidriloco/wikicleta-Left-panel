 Geo.Wrappers.LightPolyline = Backbone.Model.extend({
	initialize: function() {
		var polyline = this.get("geoFeature");
		var localInstance = this;
		
		// Add event for seeing the details of the street mark
		google.maps.event.addListener(polyline, 'click', function(event) {
			window.location.hash = "/"+localInstance.id;
		});
	}, 
	
	centerOnMap: function() {
		var polyline = this.get("geoFeature");
		var map = polyline.getMap();
		// Center the map on the center of this line (Improve this to consider a km based metric)
		var path = polyline.getPath();
		var middleCoordinate = path.getAt(Math.floor(path.getLength()/2));
		
		map.setCenter(middleCoordinate);
		map.setZoom(zoomForDetails);
	}
});