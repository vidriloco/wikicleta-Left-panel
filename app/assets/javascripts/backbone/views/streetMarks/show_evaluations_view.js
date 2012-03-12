Wikiando.Views.StreetMarks.ShowEvaluationsView = Backbone.View.extend({
	
	el: "#bottom-panel",
	controls : "#controls-panel",
	
	events: { 
		'click a.commit': 'save'
	},
	
	initialize: function() {
		_.bindAll(this, 'render');
		this.render();
	},
	
	render: function() {
		$(this.el).html($('#ranking-template').html());
		$(this.el).fadeIn();		
		// Changing top controls associated with this view
		var template = Handlebars.compile($('#ranking-controls-template').html());
		$(this.controls).html(template({ model_id : this.model.id }));
		return this;
	},
	
	save: function() {
		alert('saved');
	}
	
});