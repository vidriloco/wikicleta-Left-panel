//= require sections/maps

function StreetsSection()
{
	this.map = null;
	
	this.index = function() {
		this.map = new MapFactory(this);
	}
}