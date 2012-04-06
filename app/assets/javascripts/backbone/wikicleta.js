//= require_self
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views
//= require_tree ./routers

var Wikicleta = {
    Views: {
			StreetMarks: {},
			Incidents: {}
		},
    Controllers: {},
		Collections: {},
		Routers: {},
		Session: {},
		
    initStreetMarks: function(object) {
			window.router = new Wikicleta.Routers.StreetMarks(object);
			this._historyRewind();
    },

		init: function(section, collection) {
			if(section == "incidents") {
				window.router = new Wikicleta.Routers.Incidents(collection);
			}
			Backbone.history.start();
		},
		
		_historyRewind: function() {
			Backbone.history.start();
		},
		
		setCurrentUser: function(user) {
			Wikicleta.Session.user = user;
			console.log(Wikicleta.Session.user);
		}
};

