function MapFactory(currentSection)
{
	var map = null;
	
	this.initialize = function() {
		if($.isDefined('#map')) {
			map = new ViewComponents.Geo.Map(new google.maps.Map(document.getElementById(mapAtDom), mapOptions));
		} 

		map.resetMarkersList();
		map.reset();
	}
	
	this.initialize();
	return map;
}