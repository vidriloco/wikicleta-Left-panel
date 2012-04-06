Wikicleta.Routers.StreetMarks = Backbone.Router.extend({
	initialize: function(object) {
		this.streetMarks = new Wikicleta.Collections.StreetMarksCollection();
		this.streetMarks.reset(object.streetMarks);
	},
	
	routes: {
		"new"						: "new",
		"/:id"      		: "show",
		"/:id/evaluate"	: "evaluate",
		".*"						: "index"
	},
	
	new: function() {
		this.view = new Wikicleta.Views.StreetMarks.NewView({ collection: this.streetMarks });
		this.view.render();
	},
	
	index: function() {
		this.view = new Wikicleta.Views.StreetMarks.IndexView({ streetMarks : this.streetMarks });
		this.view.render();
		this._loadLines(this.streetMarks);
	},
	
	show: function(id) {
		var model = this.streetMarks.get(id);
		this.view = new Wikicleta.Views.StreetMarks.ShowView({ model : model });
		this.view.render();
		this._loadLines([model], true);
		this.view.fetchRankingsSubView();
	},
	
	// renders the show view and pushes the evaluations subview
	evaluate: function(id) {
		var model = this.streetMarks.get(id);
		this.view = new Wikicleta.Views.StreetMarks.ShowView({ model : model });
		this.view.render();
		this.view.pushEvaluationsView();
		this._loadLines([model], true);
	},
	
	// Loads in the map an array of lines given as parameters
	// It centers a line if the detailsForLine parameter is set to true
	_loadLines: function(lines, detailsForLine) {
		mapWrap.clearLines();
		
		var lineAdded = null;
		lines.forEach(function(streetMark) { 
			lineAdded = mapWrap.pushLine(streetMark.get("id"), streetMark.get("segment_path"));
		});
		
		if(detailsForLine) {
			lineAdded.centerOnMap();
		}
	}
	
});
	