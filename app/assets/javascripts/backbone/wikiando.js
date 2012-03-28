//= require_self
//= require_tree ./templates
//= require_tree ./models
//= require_tree ./views
//= require_tree ./routers

var Wikiando = {
    Views: {
			StreetMarks: {}
		},
    Controllers: {},
		Collections: {},
		Routers: {},
		Session: {},
		
    initStreetMarks: function(object) {
			window.router = new Wikiando.Routers.StreetMarks(object);
			Backbone.history.start();
    },
		setCurrentUser: function(user) {
			Wikiando.Session.user = user;
			console.log(Wikiando.Session.user);
		}
};

