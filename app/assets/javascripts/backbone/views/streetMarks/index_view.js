Wikiando.Views.StreetMarks.IndexView = Backbone.View.extend({
	
	el: "#submenu",
	
	initialize: function() {
		_.bindAll(this, 'render');
		this.options.streetMarks.bind('reset', this.addAll);
	},
	
	addAll: function() {
		var localView = this;
		this.options.streetMarks.forEach(function(streetMark) { 
			localView.addOne(streetMark);
		});
	},
	
	addOne: function(streetMark) {
		mapWrap.pushLine(streetMark.get("id"), streetMark.get("segment_path"));
	},
	
	render: function() {
		var template = Handlebars.compile($("#submenu-template").html());
		$(this.el).html(template({ count : this.options.streetMarks.length }));
		return this;
	}
	
});