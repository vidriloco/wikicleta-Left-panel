$.extend({
	isDefined: function(dom) {
		return $(dom).length;
	},
	
	rad: function(x) {
		return x*Math.PI/180;
	},
	
	distanceBetween: function(coord1, coord2) {
		var R = 6371; // km
		var dLat = $.rad((coord2.lat()-coord1.lat()));
		var dLon = $.rad((coord2.lng()-coord1.lng()));
		var lat1 = $.rad(coord1.lat());
		var lat2 = $.rad(coord2.lat());

		var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
		        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
		return R * c;
	},
	
	collinear: function(a, b, c) {
		return (b.lat() - a.lat()) * (c.lng() - a.lng()) == (c.lat() - a.lat()) * (b.lng() - a.lng());	
	},
	
	withinLine: function(p, q, r) {
		return p <= q <= r || r <= q <= p;
	}
	
});

var PolyLineWrapper = Backbone.Model.extend({
	initialize: function(polyline, mapWrapper) {
		var map = mapWrapper.get("currentMap");
		polyline.setMap(map);
		
		this.set({ mapWrapper : mapWrapper });
		this.set({ ghostMarker : new google.maps.Marker({	map : map, visible : false }) });
		this.set({ polyLine : polyline, markerList : [] });
		var theWrapper = this;
		
		if(this.get("mapWrapper").isEditable()) {
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
			
				map.writeCurrentLineToDom();
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
		}
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
		
		// the following two listeners allow to delete and adjust the placement of markers along the map
		google.maps.event.addListener(marker, 'click', function() {
			var idx = markerList.indexOf(marker);
			marker.setMap(null);
			markerList.splice(idx, 1);
			theWrapper.get("polyLine").getPath().removeAt(idx);
			theWrapper.get("mapWrapper").writeCurrentLineToDom();
		});

		google.maps.event.addListener(marker, 'dragend', function(event) { 
			var idx = markerList.indexOf(marker);
			theWrapper.get("polyLine").getPath().setAt(idx, marker.getPosition());
			theWrapper.get("mapWrapper").writeCurrentLineToDom();
		});
	}
});

/*
 * Model MapWrapper
 * This model wraps a map providing a set of related functions common on a Google Map
 *
 * Some default in-DOM configs (on any DOM):
 *  - .hide-address-on-load : if present, it will prevent the map from loading the geolocated address from the map's current position
 *
 */

var MapWrapper = Backbone.Model.extend({
	
  initialize: function(map, interactionOpts, callback) {
		this.set({ currentMap : map, lastMarker : null });
		
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
		
		if("linesMode" in interactionOpts) {
			this.set({ linesMode : interactionOpts["linesMode"] });
		}
		
		if("searchMode" in interactionOpts) {
			
			this.set({ searchMode : interactionOpts["searchMode"] })
			
			if("swDOM" in interactionOpts && "neDOM" in interactionOpts) {
				this.set({southWestDom : interactionOpts["swDOM"]});
				this.set({northEastDom : interactionOpts["neDOM"]});
				var theWrapper = this;
				google.maps.event.addListener(map, "drag", function(event) {
					if(theWrapper.has("southWestDom") && theWrapper.has("northEastDom") && $.isDefined(theWrapper.get("searchMode"))) {
						theWrapper.setSearchMapParams();
						return true;
					}
				});
			}
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
					} else if(theWrapper.has("linesMode") && $.isDefined(theWrapper.get("linesMode"))) {
						
						// Add a new marker to the polyline
						theWrapper.get("line").addMarker(new google.maps.Marker({
							position: event.latLng,
							map: map,
							draggable: true
						}));
						
						theWrapper.writeCurrentLineToDom();
					}
				});
	    }
		}
		
		if(!$.isDefined(".hide-address-on-load")) {
			if(this.has("domAddress") && $.isDefined(this.get("domAddress"))) {
				this.writeAddressOn();
			}
		}
		
		// This has to be moved so it can be started from a button
		if($.isDefined(this.get("linesMode"))) {
			var pl = new PolyLineWrapper(new google.maps.Polyline({ 
				strokeWeight : 3, 
				strokeColor: '#000000' }), this);
			this.set({ line: pl });
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
						this.get("line").addMarker(new google.maps.Marker({
							position: new google.maps.LatLng(lat, lng),
							map: map,
							draggable: true
						}));
					} else {
						this.get("line").get("polyLine").getPath().push(new google.maps.LatLng(lat, lng));
					}
					

				}
				
			}
		}
		
		// Issue a callback after map initialization
		if(callback) {
			callback();
		}
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
		$(linesFromDom).val(this.get("line").get("polyLine").getPath().getArray());
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
	
	setSearchMapParams: function() {
		var map = this.get("currentMap");
		var limites = map.getBounds();
		var ne = limites.getNorthEast();
		var sw = limites.getSouthWest();
		
		$(this.get("southWestDom")).val(sw.lat() + "," + sw.lng());
		$(this.get("northEastDom")).val(ne.lat() + "," + ne.lng());
		return true;
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
