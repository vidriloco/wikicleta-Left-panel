//= require jquery
//= require jquery_ujs
//= require jquery-ui-min
//= require jquery.tipsy
//= require quickpager.jquery
//= require view_components/notification.view
//= require underscore
//= require backbone

// Following are some functions used over the application
$.fn.clearForm = function() {
  return this.each(function() {
    var type = this.type, tag = this.tagName.toLowerCase();
    if (tag == 'form')
      return $(':input',this).clearForm();
    if (type == 'text' || type == 'password' || tag == 'textarea')
      this.value = '';
    else if (type == 'checkbox' || type == 'radio')
      this.checked = false;
    else if (tag == 'select')
      this.selectedIndex = -1;
  });
};

$.extend({
	isDefined: function(dom) {
		return $(dom).length;
	},
	currentSectionIs: function(dom) {
		return $.isDefined("#section-"+dom);
	},
	visit: function(hashedUrl) {
		window.location.hash=hashedUrl;
	},
	buildUrlFrom: function(section, id) {
		if(id === undefined) {
			return "#"+section;
		}
		return "#"+section+"/"+id;
	},
	assetsURL: 'http://127.0.0.1:3000/assets/'
})