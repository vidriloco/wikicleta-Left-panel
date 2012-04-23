//= require sections/base
//= require view_components/confirmation.view
var modal = null;
$.extend(Sections.Pictures, {
	
	index: function() {
		ViewComponents.Blocking.detach();
	},
	
	manageUploads: function() {
		$('#container').html($('#origin .uploads').clone());
		section._loadCommon();
		$('#menu .uploads-launcher').addClass('selected');
		section._fileUploadControlsInit();
	},
	
	manageUploaded: function() {
		section.loadUploaded();
	},
	
	loadUploaded: function() {
		$('#container').html($('#origin .uploaded').clone());
		section._loadCommon();
		$('#menu .uploaded-launcher').addClass('selected');
		$("#pictures").quickPager({pageSize: 1});
		ViewComponents.Confirmation.initWith("#container .triggers-confirmation", '#container .confirmation', {
			onAccept: function(confirmationContainer) {
				$('#container .simplePagerContainer').remove();
				$('#container .loading').fadeIn();
			}
		});
				
		$('.edit-me').editable({
    	type: 'text',
    	submit: 'Guardar',
    	onSubmit: function(value) {
				if(value.current != value.previous) {
					$.ajax({
						type: "PUT",
						url: $(this).attr('data-url'),
						data: {value : value.current},
						dataType: 'script' });
				}
			}
    });
		
	},
	
	_loadCommon: function() {
		$('#menu').html($('#origin .sections').clone());
		modal = $('#picture-manager-modal').reveal();
		modal.bind('reveal:close', function() {
			$.visit($.buildUrlFrom(''));
		})
	},
	
	_fileUploadControlsInit: function() {
		var uploader = new plupload.Uploader({
			runtimes : 'html5,flash,silverlight,browserplus',
			browse_button : 'pickfiles',
			container : 'container',
			max_file_size : '2mb',
			url : $('#url').text(),
			multipart : true,
			multipart_params : { authenticity_token : $('#token').text() },
			flash_swf_url : '/assets/plupload.flash.swf',
			silverlight_xap_url : '/assets/plupload.silverlight.xap',
			filters : [
				{title : "Image files", extensions : "jpg,gif,png,jpeg"}
			]
		});
		
		uploader.init();

		uploader.bind('UploadComplete', function(up, files) {
			$.get($('#url-reload').text());
			$.visit($.buildUrlFrom(''));
			ViewComponents.Notification.put("<p class='notice top-message'>Las fotos seleccionadas fueron guardadas</p>");
		});

		$('#uploadfiles').click(function(e) {
			uploader.start();
			e.preventDefault();
		});

		uploader.bind('FilesAdded', function(up, files) {
			$.each(files, function(i, file) {
				$('#filelist').append(
					'<div id="' + file.id + '" class="file"><a class="delete-file" href="javascript:void(0);">Eliminar</a><span class="name">' +
					file.name + '</span><span class="size">' + plupload.formatSize(file.size) + '</span>' +
				'</div>');
			});

			up.refresh(); // Reposition Flash/Silverlight
		});
		
		uploader.bind('UploadProgress', function(up, file) {
			$('#'+file.id + " .delete-file").addClass("uploading");
			$('#'+file.id + " .uploading").removeClass("delete-file");

			$('#'+file.id + " .uploading").html(file.percent + "%");
		});

		uploader.bind('Error', function(up, err) {
			$('#filelist').append('<div id="'+err.file.id+'" class="file"><span class="name">' +
			err.file.name + '</span><span class="error">' + err.message + '</span></div>');
			$('#'+err.file.id).delay(1500).fadeOut(1000);
			up.refresh(); // Reposition Flash/Silverlight
		});

		uploader.bind('FileUploaded', function(up, file) {
			$('#'+file.id + " .uploading").addClass("completed");
			$('#'+file.id + " .completed").removeClass("uploading");

			$('#'+file.id + " .uploading").html("100%");
			$('#'+file.id).delay(2000).fadeOut(300);
		});
		
		uploader.bind('BeforeUpload', function(up, file) {
			ViewComponents.Blocking.append('transparent-layer');
			$('#container .actions .loading').fadeIn();
			$('#container .actions .links').hide();
		});
		
		$('#filelist').empty();
		$('.delete-file').live('click', function() {
			var fileId = $($(this).parent()).attr('id');
			uploader.removeFile(uploader.getFile(fileId));
			$(this).parent().remove();
		});
	}
});

var section = Sections.Pictures;

