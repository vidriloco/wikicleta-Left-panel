Wikicleta.Views.StreetMarks.ShowView = Backbone.View.extend({
	
	el: "#main-panel",
	
	events: { 
		'click a.close': 'closeView'
	},
	
	initialize: function() {
		_.bindAll(this, 'render');
	},
	
	render: function() {
		var template = Handlebars.compile($("#street-mark-template").html());
		$(this.el).html(template({ name : this.model.get("name"), updated_at : this.model.get("updated_at") }));
		$(".timeago").timeago();
		$(this.el).fadeIn();
		$('#submenu').empty();
		
		new Wikicleta.Views.StreetMarks.ShowDetailsView({ model : this.model });
		
		return this;
	},
	
	closeView: function() {
		$(this.el).hide().empty();
		mapWrap.placeViewportAt({zoom: defaultZoom });
	},
	
	pushEvaluationsView: function() {
		new Wikicleta.Views.StreetMarks.ShowEvaluationsView({ model : this.model });
	}, 
	
	fetchRankingsSubView: function() {
		$.get("/map/street_marks/"+this.model.id+'/rankings');
	}
	
});