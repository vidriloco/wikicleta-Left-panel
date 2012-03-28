var StreetMarkRanking = Backbone.Model.extend({
 	paramRoot: 'street_mark_ranking',

	defaults: {
		street_mark_id 	: null
	},
	
	validation: {
		street_mark_id: {
			required : true
		}
	},
	
  url : function() {
    return '/map/street_marks/rankings';
  }
 
});