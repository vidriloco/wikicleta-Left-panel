//= require view_components/base.view

$.extend(ViewComponents, {
    ValidForm: {
			
			set: function(dom, rules, callback) {
				this.domElement = dom;
				this.validationRules = rules;
				var instance = this;
				
				$(this.domElement).submit(function() {
					for(var idx in instance.validationRules) {
						var hash = instance.validationRules[idx];
						if(!instance.validate(hash)) {
							if(hash.overrideWhen != undefined && hash.overrideWhen) {
								return true;
							}
							instance.markError(hash.id);
							return false;
						}
					}
					
					if(callback != undefined) {
						callback();
					}
					return true;
				})
			},
			
			validate: function(hash) {
				this.rule = hash.condition;
				if(hash.type != undefined && hash.type=="file") {
					switch(hash.condition) {
						case 'max':
							return this.validateFileSize('max', hash.value, hash.id);
						case 'regexp':
							return this.validateFileWithRegexp(hash.regexp, hash.id);
						case 'not_empty':
							return this.validateMin(0, hash.id);
					}
				} else {
					switch(hash.condition) {
						case 'before_than':
					  	return this.validateTime(hash.respect, hash.id, hash.special);
						case 'min':
					  	return this.validateMin(hash.value, hash.id);
						case 'regexp':
							return this.validateWithRegexp(hash.regexp, hash.id);
						case 'not_empty':
							return this.validateMin(0, hash.id);
						case 'both':
							return this.validateBothNotEmpty(hash.anotherId, hash.id)
					}
				}
			},
			
			validateFileSize: function(range, value, partialDom) {
				return true;
			},
			
			validateFileWithRegexp : function(regexp, partialDom) {
				var dom = this.domElement+" "+partialDom;

				var fullPath = $(dom).val();
				if (fullPath) {
			    var startIndex = (fullPath.indexOf('\\') >= 0 ? fullPath.lastIndexOf('\\') : fullPath.lastIndexOf('/'));
	        var filename = fullPath.substring(startIndex);
	        if (filename.indexOf('\\') === 0 || filename.indexOf('/') === 0) {
	                filename = filename.substring(1);
	        }
	        return filename.match(regexp);
				}
				
				return false;
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
				var domForError=this.domElement+" "+id+'_'+this.rule;
				$(domForError).fadeIn(200).delay(5000).fadeOut(400);
			}
			
		}
});