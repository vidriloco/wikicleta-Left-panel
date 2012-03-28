Wikiando.Views.StreetMarks.ShowEvaluationsView = Backbone.View.extend({
	
	el: "#bottom-panel",
	controls : "#controls-panel",
	
	events: { 
		'click a.rank': 'save'
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
		if(Wikiando.Session.user==null) {
			return false;
		}
		
		var fields = this._fieldsForRanking();
		
		if($('#questions-count').text() == _.size(fields)) {
			var ranking = new StreetMarkRanking(_.extend(fields, { 
				street_mark_id : this.model.id
			}));
			ranking.save();
			window.location.hash = "/"+this.model.id;
		} 
	},
	
	_fieldsForRanking : function() {
		var fields = {};
		
		_.each($('.answer:checked'), function(answer) { 
			var attribute = $(answer).attr('name');
			fields[attribute] = $(answer).val();
		});
		return fields;
	}
	
});