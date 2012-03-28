var Answer = Backbone.Model.extend({
 	paramRoot: 'question_answer_rank',

	defaults: {
		cataloged_answer_id: null,
		cataloged_question_id: null
	},

  url : function() {
    return '/answers/' + this.id;
  }
 
});
