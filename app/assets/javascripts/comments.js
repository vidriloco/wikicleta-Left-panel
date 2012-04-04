//= require view_components/counter.view

$(document).ready(function() {
	ViewComponents.Counter.forDomElement('#comment_comment', 400);

	// Comment form methods
	var clearComment = function() {
		$('#new_comment').clearForm();
		$('#comment_comment').trigger('keyup');
	}
	
	$('.clearer').bind('click', clearComment);
	
	$('#comment_comment').keyup(function() {
		var text = $(this).val();
	  if(text.length > 0) {
			$('#new_comment .actions').fadeIn(400);
		} else {
			$('#new_comment .actions').hide();
		}
	});
	$('#comment_comment').trigger('keyup');
	
});