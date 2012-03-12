Wikiando.Views.StreetMarks.ShowDetailsView = Backbone.View.extend({
	
	el: "#bottom-panel",
	controls : "#controls-panel",
	
	events: {},
	
	initialize: function() {
		_.bindAll(this, 'render');
		this.render();
	},
	
	render: function() {
		$(this.controls).html($('#details-controls-template').html());
		
		// Changing top controls associated with this view
		var template = Handlebars.compile($('#details-template').html());
		$(this.el).html(template({ model_id : this.model.id }));
		$(this.el).fadeIn();
		return this;
	}
	
});