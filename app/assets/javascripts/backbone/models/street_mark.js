var StreetMark = Backbone.Model.extend({
 	paramRoot: 'street_mark',

	defaults: {
		name: "",
		segment_path: null
	},

	validation: {
		name: {
			required : true,
			minLength: 1,
			maxLength: 50
		},
		segment_path: function(value) {
      if(!value) {
        return 'Error';
      }
			if(value.length == 1 || value == "") {
				return "Error";
			}
			
		}
	},
	
	setLineFeature : function(feature) {
		this.set({ segment_path : feature });
	},

  url : function() {
    return this.id ? '/map/street_marks/' + this.id : '/map/street_marks';
  }
 
});

// Collection of street marks
Wikiando.Collections.StreetMarksCollection = Backbone.Collection.extend({
  model : StreetMark,
  url : "/map/street_marks"
});