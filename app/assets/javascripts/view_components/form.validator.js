//= require view_components/base.view

$.extend(ViewComponents, {
    ValidForm: {
			
			set: function(dom, rules) {
				this.domElement = dom;
				this.validationRules = rules;
				var instance = this;
				
				$(this.domElement).submit(function() {
					for(var idx in instance.validationRules) {
						var hash = instance.validationRules[idx];
						if(!instance.validate(hash)) {
							instance.markError(hash.id);
							return false;
						}
					}
					return true;
				})
			},
			
			validate: function(hash) {
				switch(hash.condition) {
					case 'before_than':
				  	return this.validateTime(hash.respect, hash.id, hash.special);
					case 'min':
				  	return this.validateMin(hash.value, hash.id);
					case 'regexp':
						return this.validateWithRegexp(hash.regexp, hash.id);
						break;
					case 'not_empty':
						return this.validateMin(0, hash.id);
					case 'both':
						return this.validateBothNotEmpty(hash.anotherId, hash.id)
				}
			},
			
			validateMin: function(value, partialDom) {
				var dom = this.domElement+" "+partialDom;
				return $(dom).val().length > value;
			},
			
			validateWithRegexp: function(regexp, partialDom) {
				var dom = this.domElement+" "+partialDom;
				var val = $(dom).val();
				
				if(val.length == 0) {
					return true;
				}
				
				return val.match(regexp);
			},
			
			validateTime: function(anotherPartialDom, partialDom, special) {
				var minDom = this.domElement+" "+partialDom;
				var maxDom = this.domElement+" "+anotherPartialDom;
				var minDate = new Date();
				var maxDate = new Date();
				if(special) {
					minDate.setHours($(minDom+"_4i").val());
					maxDate.setHours($(maxDom+"_4i").val());
					minDate.setMinutes($(minDom+"_5i").val());
					maxDate.setMinutes($(maxDom+"_5i").val());
				} 
				return minDate < maxDate;
			},
			
			validateBothNotEmpty: function(anotherPartialDom, partialDom) {
				return this.validateMin(0, anotherPartialDom) && this.validateMin(0, partialDom);
			},
			
			markError: function(id) {
				$(this.domElement+" "+id+'_msj').fadeIn(200).delay(5000).fadeOut(400);
			}
			
		}
});