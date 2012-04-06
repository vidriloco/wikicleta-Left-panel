$.extend({	
	rad: function(x) {
		return x*Math.PI/180;
	},
	
	isBlank: function(dom) {
		return $.trim($(dom).html()).length == 0;
	},
	
	distanceBetween: function(coord1, coord2) {
		var R = 6371; // km
		var dLat = $.rad((coord2.lat()-coord1.lat()));
		var dLon = $.rad((coord2.lng()-coord1.lng()));
		var lat1 = $.rad(coord1.lat());
		var lat2 = $.rad(coord2.lat());

		var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
		        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
		var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
		return R * c;
	},
	
	collinear: function(a, b, c) {
		return (b.lat() - a.lat()) * (c.lng() - a.lng()) == (c.lat() - a.lat()) * (b.lng() - a.lng());	
	},
	
	withinLine: function(p, q, r) {
		return p <= q <= r || r <= q <= p;
	}
	
});