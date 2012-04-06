//= require sections/base
//= require view_components/counter.view
//= require view_components/floating.view

$('.item').live('click', function() {
	var incidentKind = $(this).parent().attr('class');
	var id = $(this).attr('id');
	$.visit('#/'+incidentKind+"/"+id);
});

$.extend(Sections.Incidents, {
	new: function() {
		var domElement = '#new_incident';
		section._beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected('new');
		
		// Insert html form
		$(section._attachableDom).append($(domElement).html());
		ViewComponents.Counter.forDomElement('#incident_description', 250);

		
		section.map.setMapOptions({ isEditable : true, coordinatesDom : '#coordinates' });
		
		// bindings for form selectors
		
		$('#incident_kind').change(function() {
			console.log(this.value);
		});
		
		$('#incident_kind').change(function() {
			var selected = $(this).val();
			var matchingString = ".incident-"+selected;
			$('.incident-selectable').hide();
			$(matchingString).toggle();
		});
	},
	
	index: function() {	
		section._loadMainView();
		ViewComponents.LeftBar.collapse();
		section.map.reset();
		
		section._loadIncidentsIfNeeded(function(msg) {				
			setTimeout('section._afterIndexLoaded();', 1000);
		}, true);
	},
	
	incidents: function() {
		var incidentId = this.params['id'];
		var incidentKind = this.params['incidents'];
		
		section._beforeViewsLoaded();
		ViewComponents.LeftBar.setSectionSelected(incidentKind);
		
		var sectionDom = ' .'+incidentKind;
		section._loadIncidentsIfNeeded(function(msg) {	
			$(section._attachableDom).append($(section._incidentListDom+sectionDom).html());
			$('.kind-group .incident-details').hide();
			
			if(incidentId != undefined) {
				$('.kind-group #'+incidentId+' .incident-details').fadeIn();
			}
			// Paginate the results
			$("#paginated-"+incidentKind).quickPager({pageSize: 6});
		});
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
	},
	
	_loadMainView: function() {
		$(section._attachableDom).empty();
		ViewComponents.LeftBar.clearSelected();
		
		if($.isDefined('#map')) {
			if(section.map === undefined) {
				section.map = new ViewComponents.Geo.Map(new google.maps.Map(document.getElementById(mapAtDom), mapOptions));
			}
		}
	},
	
	_attachableDom: '#dynamic-bar .container',
	_incidentListDom: '#list_incidents'
});

var section = Sections.Incidents;
