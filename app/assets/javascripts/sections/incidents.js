//= require sections/base
//= require view_components/counter.view
//= require view_components/floating.view
//= require view_components/form.validator

$('.item').live('click', function() {
	var incidentKind = $(this).parent().attr('class').split(" ")[0];
	var id = $(this).attr('id');
	$.visit($.buildUrlFrom(incidentKind, id));
});

$.extend(Sections.Incidents, {
	newIncident: function() {
		var domElement = '#new_incident';
		section._beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected('new');
		
		// Insert html form
		$(section._attachableDom).append($(domElement).html());
		ViewComponents.Counter.forDomElement('#incident_description', 250);

		section.map.setMapOptions({ isEditable : true, coordinatesDom : '#coordinates' });
		
		// bindings for form selectors
		
		$('#incident_kind').change(function() {
			var selected = $(this).val();
			var matchingString = ".incident-"+selected;
			$('.incident-selectable').hide();
			$(matchingString).toggle();
		});
		
		ViewComponents.ValidForm.set('.container '+domElement, [
			{id: '#incident_kind', condition: 'not_empty' }, 
			{id: '#incident_start_hour', respect: '#incident_final_hour', condition: 'before_than', special: true }, 
			{id: '#incident_description', condition: 'min', value: 60 },
			{id: '#coordinates_lat', anotherId: '#coordinates_lon', condition: 'both' }, 
			{id: '#incident_vehicle_identifier', condition: 'regexp', regexp: /^[^-]([A-Z0-9\-]){3,}[^-]$/ }]);
	},
	
	index: function() {	
		section._loadMainView();
		ViewComponents.LeftBar.collapse();
		
		section._loadIncidentsIfNeeded(function(msg) {	
			section.loadIncidentsOnMap($('#list_incidents .item'));			
			setTimeout('section._afterIndexLoaded();', 1000);
		}, true);
	},
	
	incidents: function(incidentKind) {
		section._beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected(incidentKind);
		
		var sectionDom = ' .'+incidentKind;
		section._loadIncidentsIfNeeded(function(msg) {	
			$(section._attachableDom).append($(section._incidentListDom+sectionDom).html());	
			section.loadIncidentsOnMap($('.kind-group .'+incidentKind+' .item'));

			$('.simplePagerNav').remove();
			// Paginate the results
			$("#paginated-"+incidentKind).quickPager({pageSize: 5});
		});
	},
	
	results: function() {
		if(!$.isDefined('#list_incidents')) {
			$.visit('#');
		}
		section._loadMainView();
		ViewComponents.LeftBar.collapse();
		section.loadIncidentsOnMap($('#list_incidents .item'));
		section._afterIndexLoaded();
	},
	
	loadIncidentsOnMap: function(items) {
		// Load all the incidents coordinates into the map
		for(var idx =0; idx < items.length; idx++) {
			var lat = $($(items[idx]).children('.lat')[0]).text();
			var lon = $($(items[idx]).children('.lon')[0]).text();
			var incidentKind = $(items[idx]).parent().attr('class');
			var id = $(items[idx]).attr('id');
			
			var itemDescription = $($(items[idx]).children('.extended-incident')[0]).html();
			
			var resourceUrl = $.buildUrlFrom(incidentKind, id);
			var options = {lat: lat, lon: lon, resourceUrl: resourceUrl, iconName: incidentKind};
			section.map.addCoordinatesAsMarkerToList(options, function(url) {
				$.visit(url);
			});
		}
	},
	
	loadIncident: function(incidentKind, id) {
		section._beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected(incidentKind);
		
		$.ajax({
	  	type: "GET",
	  	url: "/map/incidents/"+id+".js"
		}).done(function(msg) {
			var lat = $('#'+id+" .lat").text();
			var lon = $('#'+id+" .lon").text();
			section.map.placeMapOn({lat : lat, lon : lon, zoom : zoomForDetails, iconName: incidentKind });
		});
	},
	
	search: function() {
		var domElement = '#searching';
		section._beforeViewsLoaded();
		section.map.enableSearch("#coordinates");
		ViewComponents.LeftBar.setSectionSelected('search');
		
		// Insert html form
		$(section._attachableDom).append($(domElement).html());
	},
	
	_loadIncidentsIfNeeded: function(successCallback, reload) {
		if(!$.isDefined('#list_incidents') || reload) {
			$.ajax({
		  	type: "GET",
		  	url: "/map/incidents.js"
			}).done(successCallback);
		} else {
			successCallback();
		}
	},
	
	_beforeViewsLoaded: function() {
		section._loadMainView();
		ViewComponents.Floating.detach();
		ViewComponents.LeftBar.show();
		ViewComponents.LeftBar.expand();
	},
	
	_afterIndexLoaded: function() {
		var domElement = '#count_incidents';
		ViewComponents.LeftBar.hide();
		ViewComponents.Floating.append($(domElement).html());
		ViewComponents.Notification.detach();
	},
	
	_loadMainView: function() {
		$(section._attachableDom).empty();
		ViewComponents.LeftBar.clearSelected();
		
		if($.isDefined('#map')) {
			if(section.map === undefined) {
				section.map = new ViewComponents.Geo.Map(new google.maps.Map(document.getElementById(mapAtDom), mapOptions));
			} 
		} 
		
		section.map.resetMarkersList();
		section.map.reset();
	},
	
	_attachableDom: '#dynamic-bar .container',
	_incidentListDom: '#list_incidents'
});

var section = Sections.Incidents;
