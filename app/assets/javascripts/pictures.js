//= require plupload.full
//= require browserplus.min
//= require i18n/es
//= require jquery.colorbox-min


$(document).ready(function() {
	var uploader = new plupload.Uploader({
		runtimes : 'html5,flash,silverlight,browserplus',
		browse_button : 'pickfiles',
		container : 'container',
		max_file_size : '2mb',
		url : $('#url').text(),
		multipart : true,
		multipart_params : { authenticity_token : $('#token').text() },
		flash_swf_url : '../others/plupload.flash.swf',
		silverlight_xap_url : '../others/plupload.silverlight.xap',
		filters : [
			{title : "Image files", extensions : "jpg,gif,png,jpeg"}
		]
	});

	$('#uploadfiles').click(function(e) {
		uploader.start();
		e.preventDefault();
	});
	
	uploader.init();
	
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

	$('#filelist').empty();
	
	
	// ends fileupload
	
	$('a.picture').colorbox({ transition: 'fade', maxWidth: "1300px", maxHeight: "700px" });
	$('a.open-gallery').click(function() {
		$('a.picture').click();
	});
	
	$('.delete-file').live('click', function() {
		var fileId = $($(this).parent()).attr('id');
		uploader.removeFile(uploader.getFile(fileId));
		$(this).parent().fadeOut(600);
	});
});