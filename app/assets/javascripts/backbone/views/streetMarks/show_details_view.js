Wikiando.Views.StreetMarks.ShowDetailsView = Backbone.View.extend({
	
	el: "#bottom-panel",
	controls : "#controls-panel",
	
	events: {},
	
	initialize: function() {
		_.bindAll(this, 'render');
		this.render();
	},
	
	render: function() {
		// Changing top controls associated with this view
		$(this.controls).html($('#details-controls-template').html());
		
		var template = Handlebars.compile($('#details-template-invite').html());
		$(this.el).html(template({ model_id : this.model.id }));
		$(this.el).fadeIn();
		return this;
	}
	
});