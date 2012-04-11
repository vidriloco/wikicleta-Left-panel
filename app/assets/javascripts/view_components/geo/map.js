//= require view_components/geo/base

/*
 * Model MapWrapper
 * This model wraps a map providing a set of related functions common on a Google Map
 *
 * Some default in-DOM configs (on any DOM):
 *  - .hide-address-on-load : if present, it will prevent the map from loading the geolocated address from the map's current position
 *
 */


ViewComponents.Geo.Map = function(gMap, opts, callback) {
	var obj = {
		initialize: function(googleMap, opts, callback) {
			this.map = googleMap;
			this.lastMarker = null;
			this.markerList = [];
			this.lineList = [];
			this.lastLine = null;
			this.editable = false;
			this.mode = 'points';
			
			// Setting options
			this.setMapOptions(opts);
			
			var instance = this;
			// predefined events binding 
			google.maps.event.addListener(this.map, "click", function(event) {
				if(instance.pointsModeEnabled() && instance.isEditable()) {
					instance.propagateClickEvent(event.latLng);
				} 
			});
			
			return this;
		},
		
		setMapOptions: function(opts) {
			if(opts != undefined) {
				
				if(opts.isEditable != undefined) {
					this.editable = opts.isEditable;
				}
				
				if(opts.addressDom != undefined) {
					this.domElementForAddress = opts.addressDom;
				}
				
				if(opts.coordinatesDom != undefined) {
					this.domElementForCoordinates = opts.coordinatesDom;
				}
			}
		},
		
		// using the convention for dom_lat and dom_lon retrieve
		// the coordinates components for setting them on the map
		setCoordinatesFromDom: function(coordinates) {
			var latitude = coordinates+"_lat";
			var longitude = coordinates+"_lon";
			if($.isDefined(latitude) && $.isDefined(longitude)) {	
				var lat = $(latitude).val();
				var lon = $(longitude).val();
				
				this.setCoordinatesFromPair(lat, lon);
			}
		},
		
		setCoordinatesFromPair: function(latitude, longitude) {
			this.placeViewportAt({ lat: latitude, lon: longitude });
		},
		
		placeMapOn: function(opts) {
			this.placeViewportAt(opts);
			if(opts.iconName) {
				this.setMarkerOnPosition(this.map.getCenter(), opts.iconName);
			} else {
				this.setMarkerOnPosition(this.map.getCenter());
			}
		},
		
		placeViewportAt: function(opts) {
			if(("lat" in opts) && ("lon" in opts)) {
				this.map.setCenter(new google.maps.LatLng(parseFloat(opts.lat), parseFloat(opts.lon)));
			}

			if("zoom" in opts) {
				this.map.setZoom(opts.zoom);
			}
		},
		
		simulatePinPointSearch: function(opts) {
			this.placeViewportAt(opts);
			this.setSearchMapParams();
		},

		simulatePinPoint: function(lat, lon, zoom) {
			if(zoom != undefined) {
				this.placeViewportAt({zoom : zoom});
			}
			// this blocks mimics what method writePointToDom does
			this.propagateClickEvent(new google.maps.LatLng(lat, lon));
		},
		
		enableSearch: function(baseDom) {
			var instance = this;
			this.southWestDom = baseDom+"_sw";
			this.northEastDom = baseDom+"_ne";
			
			google.maps.event.addListener(this.map, "bounds_changed", function() {
				instance.setSearchMapParams();
				return true;
			});
			// will execute an action only the first time the map loads
			google.maps.event.addListenerOnce(this.map, 'drag', function(event){
			  instance.setSearchMapParams();
				return true; 
			});
		},

		setSearchMapParams: function() {
			var limits = this.map.getBounds();
			var ne = limits.getNorthEast();
			var sw = limits.getSouthWest();

			$(this.southWestDom).val(sw.lat() + "," + sw.lng());
			$(this.northEastDom).val(ne.lat() + "," + ne.lng());
			return true;
		},
		
		propagateClickEvent: function(latLng) {
			this.writeCoordinatesToDom(latLng);
			this.setMarkerOnPosition(latLng);
			this.writeAddressOn(latLng);
		},
		
		setMarkerOnPosition: function(latLng, iconName) {
			var marker = this.lastMarker;

			if(marker != null) {
				marker.setMap(null);
			} 
			
			var opts = { position: latLng, map: this.map };
			if(iconName) {
				opts = $.extend(opts, {icon: $.assetsURL+iconName+'.png'});
			}
			
			marker = new google.maps.Marker(opts);
			this.lastMarker = marker;
		},
		
		writeCoordinatesToDom: function(latLng) {
			if(this.domElementForCoordinates) {
				$(this.domElementForCoordinates+"_lat").val(latLng.lat());
				$(this.domElementForCoordinates+"_lon").val(latLng.lng());
			}
		},
		
		writeAddressOn: function(latLng) {
			if(this.domElementForAddress) {
				var geocoder = new google.maps.Geocoder();
				var instance = this;

				geocoder.geocode({'location': latLng}, function(results, status) {        
					if (status == google.maps.GeocoderStatus.OK) {
						var address = results[0].formatted_address;
						$(instance.domElementForAddress).html(""+address+"");
					} 
				});
			}
		},
		
		addCoordinatesAsMarkerToList: function(opts, callback) {
			if(opts.lat=="" || opts.lon=="") {
				return false;
			}

			var map = this.map;
			var marker = new google.maps.Marker({
				position: new google.maps.LatLng(opts.lat, opts.lon),
				map: map,
				icon: $.assetsURL+opts.iconName+'.png'
			});

			google.maps.event.addListener(marker, 'click', function() {
				callback(opts.resourceUrl);
			});
			this.markerList.push(marker);
		},

		resetMarkersList: function() {
			var markers = this.markerList;
			if (markers) {
				for (i in markers) {
					markers[i].setMap(null);
				}
			}
		},
		
		reset: function() {
			this.resetMarkersList();
			if(this.lastMarker != null) {
				this.lastMarker.setMap(null);
			}
			this.lastMarker = null;
			
			this.setEditableTo(false);
			this.placeViewportAt({zoom: defaultZoom });
		},
		
		isEditable: function() {
			return this.editable;
		},

		setEditableTo: function(status) {
			this.editable = status;
		},
		
		setLinesModeOn: function() {
			this.mode = 'lines';
		},
		
		setPointsModeOn: function() {
			this.mode = 'points';
		},
		
		pointsModeEnabled: function() {
			return this.mode == 'points';
		},
		
		linesModeEnabled: function() {
			return this.mode == 'lines';
		}
	}
	return obj.initialize(gMap, opts, callback);
}


/*$.extend(ViewComponents.Geo, { 
	Map : {
		forGoogleMap: function(map, interactionOpts, callback) {
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

		_buildPolyline: function() {
			var polyline = new google.maps.Polyline({ 
				strokeWeight : 5, 
				strokeColor: '#000000' });

			return new Geo.Wrappers.EditablePolyline({ mapWrapper : this, polyLine : polyline });
		},

		writeCurrentLineToDom: function() {
			var linesFromDom = this.get("domLines");
			$(linesFromDom).val(this.get("lastLine").get("polyLine").getPath().getArray());
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
		}
	}
});
*/
