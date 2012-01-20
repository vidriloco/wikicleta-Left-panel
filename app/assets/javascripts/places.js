$(document).ready(function() {
	
	var requestPlaces = function() {
		var orderValue = $("#l-params").val();
		var selectedCategories = [];
		$(".cats").children("input:checked").each(function(index) {
			if($(this).attr('class') == 'item') {
		  	selectedCategories.push($(this).attr('id').split("-")[1]);
			}
		});
		
		// Response is yielded at index.js.erb (listings#places)		
		$.ajax({
		  type: "GET",
		  url: "places",
		  data: { filtered: true, ordered_by: orderValue, format : "js", categories: selectedCategories }
		});
	}
	
  $("#l-params").change(requestPlaces);
  $(".cats input").change(requestPlaces);

});