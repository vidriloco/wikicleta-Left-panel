//= require view_components/base.view

$.extend(ViewComponents, {
    Confirmation: {
			initWith: function(trigger, optionsDiv, opts) {
				$(trigger).live('click', function() {
					$(optionsDiv).fadeIn();
					$($(this).parent()).hide();
					if(opts && opts.onTrigger != undefined) {
						opts.onTrigger();
					}
				});
				
				$(optionsDiv + " .declines").live('click', function() {
					$(optionsDiv).hide();
					$($(trigger).parent()).fadeIn();
				});
				
				if(opts && opts.onAccept != undefined) {
					$(optionsDiv + " .accepts").live('click', function() {
						opts.onAccept(optionsDiv);
					});
				}
				
			}
		}
});