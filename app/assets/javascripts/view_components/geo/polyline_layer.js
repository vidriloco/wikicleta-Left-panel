Geo.Layers.Polyline = Backbone.Collection.extend({
	model: Geo.Wrappers.Segment,

	initialize: function() {
	},
	
	// Loads a path on the map as a Polyline using the given coordinates
	// Stores the polyline 
	loadPath: function(segmentId, coords, map) {
		
		// Create Google maps polyline geographic object
		// assign random color to line
		var polyline = new google.maps.Polyline({ 
			strokeWeight : 5, 
			strokeColor: '#'+Math.floor(Math.random()*16777215).toString(16) });
			
		// transform coordinates of line to Google maps coordinate geographic object
		var coordsArray = [];
		_.each(coords, function(coord) {
			coordsArray.push(new google.maps.LatLng(coord.Ua, coord.Va));
		});
		
		polyline.setPath(coordsArray);
		polyline.setMap(map);
		
		// Add to this collection a new segment 
		var lightPolyline = new Geo.Wrappers.LightPolyline({ geoFeature: polyline, id : segmentId });
		this.add(lightPolyline);
		return lightPolyline;
	},
	
	destroy: function() {
		this.models.forEach(function(polyline) {
			polyline.get("geoFeature").setMap(null);
		});
	}
	
});