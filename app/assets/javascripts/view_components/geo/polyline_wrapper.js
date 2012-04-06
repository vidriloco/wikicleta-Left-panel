Geo.Wrappers.EditablePolyline = Backbone.Model.extend({
	defaults: {
		markerList: []
	},
	initialize: function() {
		
		var map = this.get("mapWrapper").get("currentMap");
		var polyline = this.get("polyLine");
		
		polyline.setMap(map);
		
		this.set({ ghostMarker : new google.maps.Marker({	map : map, visible : false }) });
		
		var theWrapper = this;
		
		// When a polyline is clicked we add a new marker in the click position
		google.maps.event.addListener(polyline, 'click', function(event) {			
			var clickCoord = event.latLng;
	
			var orderedMarkers = new Array();
	
			var markerList = theWrapper.get("markerList");
			var firstMarker = null;
			var secondMarker = null;
			// Traverse the list of markers set in the path
			for(var i = 0 ; i < markerList.length ; i++) {
				if(i+1 < markerList.length) {
		
					firstMarker = markerList[i];
					secondMarker = markerList[i+1];
			
					if(theWrapper.pointsAreAligned(firstMarker.getPosition(), secondMarker.getPosition(), clickCoord)) {
						break;
					}
				}
			}
	
			var index = theWrapper.get("markerList").indexOf(firstMarker);

			theWrapper.addMarker(new google.maps.Marker({
				position: clickCoord,
				map: map,
				draggable: true
			}), {index : index+1});
			
			theWrapper.geoFeaturesChanged();
		});
	
		var showMarker = function(event) {
			theWrapper.get("ghostMarker").setPosition(event.latLng);
			theWrapper.get("ghostMarker").setVisible(true);
		}
	
		google.maps.event.addListener(polyline, 'mouseover', showMarker);
		google.maps.event.addListener(polyline, 'mousemove', showMarker);
	
		google.maps.event.addListener(polyline, 'mouseout', function(event) {
			theWrapper.get("ghostMarker").setVisible(false);
		});
	},
	
	destroy: function() {
		var markerList = this.get("markerList");
		
		for(var idx in markerList) {
			markerList[idx].setMap(null);
		}
		
		if(this.get("polyLine") != null) {
			this.get("polyLine").setMap(null);
		}
		
		this.set({ polyLine : null, markerList : [] });
	},
	
	pointsAreAligned: function(a, b, c) {
		var crossproduct = (c.lng() - a.lng()) * (b.lat() - a.lat()) - (c.lat() - a.lat()) * (b.lng() - a.lng());
		if(Math.floor(Math.cos(crossproduct)) != 1) {
			return false;
		}
		var dotproduct = (c.lat() - a.lat()) * (b.lat() - a.lat()) + (c.lng() - a.lng())*(b.lng() - a.lng());
		if(dotproduct < 0) {
			return false;
		}
		
		var squaredlengthba = (b.lat() - a.lat())*(b.lat() - a.lat()) + (b.lng() - a.lng())*(b.lng() - a.lng())
		if(dotproduct > squaredlengthba) {
			return false;
		}

		return true;
	},
	
	geoFeaturesChanged: function() {
		this.get("mapWrapper").geoFeaturesToModel();
	},
	
	addMarker: function(marker, opts) {
		var theWrapper = this;
		var markerList = this.get("markerList");
		
		if(!opts) {
			markerList.push(marker);
			this.get("polyLine").getPath().push(marker.getPosition());
		} else {
			// Here we insert the marker on an specific index
			markerList.splice(opts["index"], 0, marker);
			var newPath = [];
			for(var i = 0 ; i < markerList.length ; i++) {
				newPath.push(markerList[i].getPosition());
			}
			this.get("polyLine").setPath(newPath);
		}
		// trigger an update on the model
		theWrapper.geoFeaturesChanged();
		
		// the following two listeners allow to delete and adjust the placement of markers along the map
		google.maps.event.addListener(marker, 'click', function() {
			var idx = markerList.indexOf(marker);
			marker.setMap(null);
			markerList.splice(idx, 1);
			theWrapper.get("polyLine").getPath().removeAt(idx);
			theWrapper.geoFeaturesChanged();
		});

		google.maps.event.addListener(marker, 'dragend', function(event) { 
			var idx = markerList.indexOf(marker);
			theWrapper.get("polyLine").getPath().setAt(idx, marker.getPosition());
			theWrapper.geoFeaturesChanged();
		});
	}
});