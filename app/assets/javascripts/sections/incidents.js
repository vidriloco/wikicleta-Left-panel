//= require sections/maps
//= require view_components/counter.view
//= require view_components/floating.view
//= require view_components/form.validator

$('.item').live('click', function() {
	var incidentKind = $(this).parent().attr('class').split(" ")[0];
	var id = $(this).attr('id');
	$.visit($.buildUrlFrom(incidentKind, id));
});

function IncidentsSection()
{
	var map = new MapFactory(this);
	
	// Private members
	var attachableDom = '#dynamic-bar .container';
	var incidentListDom = '#list_incidents';
	
	var loadIncidentsIfNeeded = function(successCallback, reload) {
		if(!$.isDefined('#list_incidents') || reload) {
			$.ajax({
		  	type: "GET",
		  	url: "/map/incidents.js"
			}).done(successCallback);
		} else {
			successCallback();
		}
	}
	
	var beforeViewsLoaded = function() {
		loadMainView();
		ViewComponents.Floating.detach();
		ViewComponents.LeftBar.show();
		ViewComponents.LeftBar.expand();
	}
	
	var afterIndexLoaded = function() {
		var domElement = '#count_incidents';
		ViewComponents.LeftBar.hide();
		ViewComponents.Floating.append($(domElement).html());
		ViewComponents.Notification.detach();
	}
	
	var loadMainView = function() {
		$(attachableDom).empty();
		ViewComponents.LeftBar.clearSelected();
	}
	
	var loadIncidentsOnMap = function(items) {
		// Load all the incidents coordinates into the map
		for(var idx =0; idx < items.length; idx++) {
			var lat = $($(items[idx]).children('.lat')[0]).text();
			var lon = $($(items[idx]).children('.lon')[0]).text();
			var incidentKind = $(items[idx]).parent().attr('class');
			var id = $(items[idx]).attr('id');
			
			var itemDescription = $($(items[idx]).children('.extended-incident')[0]).html();
			
			var resourceUrl = $.buildUrlFrom(incidentKind, id);
			var options = {lat: lat, lon: lon, resourceUrl: resourceUrl, iconName: incidentKind};
			map.addCoordinatesAsMarkerToList(options, function(url) {
				$.visit(url);
			});
		}
	}
	
	// Public members
	this.getAttachableDom = function() {
		return attachableDom;
	}
	
	this.newIncident = function() {
		// TODO: validate presence of bike 
		var domElement = '#new_incident';
		beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected('new');
		
		// Insert html form
		$(attachableDom).html($(domElement).html());
		ViewComponents.Counter.forDomElement('#incident_description', 250);

		map.setMapOptions({ isEditable : true, coordinatesDom : '#coordinates' });
		
		// bindings for form selectors
		
		$('#incident_kind').change(function() {
			var selected = $(this).val();
			$('.container .styled-form #new_incident').clearForm();
			$(this).val(selected);
			
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
	}
	
	this.index = function() {	
		loadMainView();
		ViewComponents.LeftBar.collapse();
		
		loadIncidentsIfNeeded(function(msg) {	
			loadIncidentsOnMap($('#list_incidents .item'));			
			setTimeout(afterIndexLoaded, 1000);
		}, true);
	}
	
	this.incidents = function(incidentKind) {
		beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected(incidentKind);
		
		var sectionDom = ' .'+incidentKind;
		loadIncidentsIfNeeded(function(msg) {	
			$(attachableDom).append($(incidentListDom+sectionDom).html());	
			loadIncidentsOnMap($('.kind-group .'+incidentKind+' .item'));

			$('.simplePagerNav').remove();
			// Paginate the results
			$("#paginated-"+incidentKind).quickPager({pageSize: 5});
		});
	}
	
	this.results = function() {
		if(!$.isDefined('#list_incidents')) {
			$.visit('#');
		}
		loadMainView();
		ViewComponents.LeftBar.collapse();
		loadIncidentsOnMap($('#list_incidents .item'));
		afterIndexLoaded();
	}
	
	this.loadIncident = function(incidentKind, id) {
		beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected(incidentKind);
		
		$.ajax({
	  	type: "GET",
	  	url: "/map/incidents/"+id+".js"
		}).done(function(msg) {
			var lat = $('#'+id+" .lat").text();
			var lon = $('#'+id+" .lon").text();
			map.placeMapOn({lat : lat, lon : lon, zoom : zoomForDetails, iconName: incidentKind });
			
			$('.trigger-show').click(function() {
				$(this).hide();
				$('.trigger-hide').fadeIn();
				$('.photo .image').slideToggle();
			});
			
			$('.trigger-hide').click(function() {
				$(this).hide();
				$('.trigger-show').fadeIn();
				$('.photo .image').slideToggle();
			});
		});
	}
	
	this.search = function() {
		var domElement = '#searching';
		beforeViewsLoaded();
		map.enableSearch("#coordinates");
		ViewComponents.LeftBar.setSectionSelected('search');
		
		// Insert html form
		$(attachableDom).append($(domElement).html());
	}
	
	this.getMap = function() {
		return map;
	}

}

