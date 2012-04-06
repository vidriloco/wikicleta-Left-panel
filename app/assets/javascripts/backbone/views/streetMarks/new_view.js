Wikicleta.Views.StreetMarks.NewView = Backbone.View.extend({
	el: "#main-panel",
	
	events: { 
		'click a.close': 'closeView',
		'click a.commit': 'save'
	},

	initialize: function() {
		_.bindAll(this, 'render');
		this.model = new this.collection.model();
	},
	
	render : function() {
		mapWrap.stopLineMarking();
		$(this.el).html($("#new-mark-form-template").html());
		$(this.el).fadeIn();
		$('#submenu').empty();
		
		mapWrap.startLineMarking(this);
		Backbone.ModelBinding.bind(this);
		
		Backbone.Validation.bind(this, { forceUpdate: true });
		return this;
	},
	
	closeView: function() {
		$(this.el).hide().empty();
		mapWrap.stopLineMarking();
		//Backbone.Validation.unbind(this);
	},
	
	save: function() {
		if(this.model.isValid() && Wikicleta.Session.user != null) {
			var localView = this;
			this.collection.create(this.model.toJSON(),
			{
				success: function(streetMark) {
					localView.closeView();
					mapWrap.pushLine(streetMark.id, streetMark.get("segment_path"));
					localView.visualNotification('success');
					window.location.hash = "/"+streetMark.id;
				},
				error: function(streetMark, jqXHR) {
					alert('not saved');
				}
			}
			);
		}
	},
	
	visualNotification: function(event_) {
		if(event_=='success') {
			$('#notifications').html("Has añadido una nueva calle. ¡Gracias!");
			$('#notifications').fadeIn(1000).delay(1500).fadeOut(1000);
		}
	}
});