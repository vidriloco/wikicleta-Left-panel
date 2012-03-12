/*
 * Model MapWrapper
 * This model wraps a map providing a set of related functions common on a Google Map
 *
 * Some default in-DOM configs (on any DOM):
 *  - .hide-address-on-load : if present, it will prevent the map from loading the geolocated address from the map's current position
 *
 */

Geo.Wrappers.Map = Backbone.Model.extend({
	
  initialize: function(map, interactionOpts, callback) {
		this.set({ currentMap : map, lastMarker : null, markerList : [], lineList : [], lastLine : null });
		
		if("pointsMode" in interactionOpts) {
			this.set({pointsMode : interactionOpts["pointsMode"] });
		}
		
		if("domPoint" in interactionOpts) {
			this.set({domPoint : interactionOpts["domPoint"] });
			// Set marker on center map
			var coordsTo = this.get("domPoint");
			
			if($.isDefined(coordsTo+"_lat") && $.isDefined(coordsTo+"_lon")) {					
				var lat = $(coordsTo+"_lat").val();
				var lon = $(coordsTo+"_lon").val();
				
				// check if latitude and longitude on field are not empty
				if(lat && lon) {
					this.placeViewportAt({zoom: 15, lon: lon, lat : lat});
					this.setMarkerOnCenter();
				}
			}
			
		}
		
		if("domAddress" in interactionOpts) {
			this.set({domAddress : interactionOpts["domAddress"] });
		}
		
		if("domEditable" in interactionOpts) {
			this.set({domEditable : interactionOpts["domEditable"] });

			if(this.isEditable()) {
				var theWrapper = this;
				// Adding listener for click on map. Depending on the mode, it will be draw a line or a point
				google.maps.event.addListener(map, "click", function(event) {
					if(theWrapper.has("pointsMode") && $.isDefined(theWrapper.get("pointsMode"))) {
						
						theWrapper.writePointToDom(event);
						theWrapper.setMarkerOnCenter();

						if(theWrapper.has("domAddress") && $.isDefined(theWrapper.get("domAddress"))) {
							theWrapper.writeAddressOn();
						}
					} 
				});
	    }
		}
		
		if(!$.isDefined(".hide-address-on-load")) {
			if(this.has("domAddress") && $.isDefined(this.get("domAddress"))) {
				this.writeAddressOn();
			}
		}
		
		if("domLines" in interactionOpts) {
			this.set({domLines : interactionOpts["domLines"] });
			
			var lineTo = this.get("domLines");
			
			// Here we draw the line from a dom element with the polyline data
			if($.isDefined(lineTo)) {					
				var coords1stSwap = $(lineTo).val().substring(1, $(lineTo).val().length-1);

				var splittedCoords = coords1stSwap.split("),(");
				for(var coord in splittedCoords) {
					var splittedComp = splittedCoords[coord].split(",");
					var lat = splittedComp[0];
					var lng = splittedComp[1];
					
					
					// If map is editable, marker is editable then
					if(this.isEditable()) {
						// Add a new marker to the polyline
						this.get("lastLine").addMarker(new google.maps.Marker({
							position: new google.maps.LatLng(lat, lng),
							map: map,
							draggable: true
						}));
					} else {
						this.get("lastLine").get("polyLine").getPath().push(new google.maps.LatLng(lat, lng));
					}
					

				}
				
			}
		}
		
		// Issue a callback after map initialization
		if(callback) {
			callback();
		}
	},
	
	geoFeaturesToModel: function() {
		if(this.get("lastLine") != null) {
			var lineMarked = this.retrieveLineMarked();
			
			this.get("geoModel").setLineFeature(lineMarked);
		}
	},
	
	clearLines: function() {
		if(this.get("polylineLayer")) {
			this.get("polylineLayer").destroy();
			this.set({ polylineLayer: null });
		}
	},
	
	// Receives the unique id and the list of coordinates that constitute the new polyline
	pushLine: function(lineId, lineCoords) {
		var polylineLayer = this.get("polylineLayer");
		if(polylineLayer == null) {
			polylineLayer = new Geo.Layers.Polyline([]);
			this.set({ polylineLayer : polylineLayer });
		}
		// passing the current map 
		return polylineLayer.loadPath(lineId, lineCoords, this.get("currentMap"));
	},
	
	retrieveLineMarked: function() {
		return this.get("lastLine").get("polyLine").getPath().getArray();
	},
	
	stopLineMarking: function() {
		google.maps.event.clearListeners(this.get("currentMap"), 'click');
		if(this.get("lastLine") != null) {
			this.get("lastLine").destroy();	
		}
	},
	
	startLineMarking: function(view) {
		this.set({ geoModel : view.model });
		
		var pl = this._buildPolyline();
		this.set({ lastLine: pl });
		
		var theWrapper = this;
		var map = theWrapper.get("currentMap");
		
		google.maps.event.addListener(map, "click", function(event) {
			// Add a new marker to the polyline
			theWrapper.get("lastLine").addMarker(new google.maps.Marker({
				position: event.latLng,
				map: map,
				draggable: true
			}));
		});
	},
	
	
	enableSearch: function(ne, sw) {
		var map = this.get("currentMap");
		this.set({southWestDom : ne});
		this.set({northEastDom : sw});
		var theWrapper = this;
		google.maps.event.addListener(map, "drag", function(event) {
			theWrapper.setSearchMapParams();
			return true;
		});
		// will execute an action only the first time the map loads
		google.maps.event.addListenerOnce(map, 'idle', function(){
		  theWrapper.setSearchMapParams();
			return true; 
		});
	},
	
	setSearchMapParams: function() {
		var map = this.get("currentMap");
		var limits = map.getBounds();
		var ne = limits.getNorthEast();
		var sw = limits.getSouthWest();
		
		$(this.get("southWestDom")).val(sw.lat() + "," + sw.lng());
		$(this.get("northEastDom")).val(ne.lat() + "," + ne.lng());
		return true;
	},
	
	_buildPolyline: function() {
		var polyline = new google.maps.Polyline({ 
			strokeWeight : 5, 
			strokeColor: '#000000' });
		
		return new Geo.Wrappers.EditablePolyline({ mapWrapper : this, polyLine : polyline });
	},
	
	simulatePinPointSearch: function(opts) {
		this.placeViewportAt(opts);
		this.setSearchMapParams();
	},
	
	simulatePinPoint: function(lat, lon) {
		// this blocks mimics what method writePointToDom does
		this._coordsToMap(new google.maps.LatLng(lat, lon));
		this.writeAddressOn();
		this.setMarkerOnCenter();
	},
	
	writePointToDom: function(event) {
		this._coordsToMap(event.latLng);
	},
	
	writeCurrentLineToDom: function() {
		var linesFromDom = this.get("domLines");
		$(linesFromDom).val(this.get("lastLine").get("polyLine").getPath().getArray());
	},
	
	placeViewportAt: function(opts) {
		var map = this.get("currentMap");
		if(("lat" in opts) && ("lon" in opts)) {
			map.setCenter(new google.maps.LatLng(parseFloat(opts.lat), parseFloat(opts.lon)));
		}
		
		if("zoom" in opts) {
			map.setZoom(opts.zoom);
		}
	},
	
	setMarkerOnCenter: function() {
		var marker = this.get("lastMarker");
		
		if(marker != null) {
			marker.setMap(null);
		} 
		
		var map = this.get("currentMap");
		marker = new google.maps.Marker({
		  position: map.getCenter(), 
			map: map
		});
		
		this.set({ lastMarker : marker });
	},
	
	addCoordinatesAsMarkerToList: function(lat, lon, content, action) {
		if(lat=="" || lon=="") {
			return false;
		}
		
		var map = this.get("currentMap");
		var marker = new google.maps.Marker({
			position: new google.maps.LatLng(lat, lon),
			map: map
		});
		
		google.maps.event.addListener(marker, 'click', function() {
			action(content);
		});
		this.get("markerList").push(marker);
	},
	
	resetMarkersList: function() {
		var markersList = this.get("markerList");
		if (markersList) {
			for (i in markersList) {
				markersList[i].setMap(null);
			}
		}
	},
	
	writeAddressOn: function() {
		var map = this.get("currentMap");
		
		var geocoder = new google.maps.Geocoder();
		var theWrapper = this;
		
		geocoder.geocode({'location': map.getCenter()}, function(results, status) {        
			if (status == google.maps.GeocoderStatus.OK) {
				var address = results[0].formatted_address;
				$(theWrapper.get("domAddress")).html(""+address+"");
			} 
		});
	},
	
	isEditable: function() {
		return $.isDefined(this.get("domEditable"));
	},
	
	_coordsToMap: function(coordinates) {
		var coordsFromDom = this.get("domPoint");
    $(coordsFromDom+"_lat").val(coordinates.lat());
    $(coordsFromDom+"_lon").val(coordinates.lng());

		this.placeViewportAt({
			lat: coordinates.lat(),
			lon: coordinates.lng()
		});
	}
	
});
