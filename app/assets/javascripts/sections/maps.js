function MapFactory(currentSection)
{
	var map = null;
	
	this.initialize = function(currentSection) {
		if($.isDefined('#map')) {
			if(currentSection.map === undefined) {
				map = new ViewComponents.Geo.Map(new google.maps.Map(document.getElementById(mapAtDom), mapOptions));
			} 
		} 

		map.resetMarkersList();
		map.reset();
	}
	
	this.initialize(currentSection);
	return map;
}