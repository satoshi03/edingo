// constants
var UPDATE_INTERVAL = 2000;
var BASEURL = '/documents/';

var documentdata = '';

$(function() {
	var docid = $('#docid').val();
	var docurl = BASEURL + docid + '.json';
	var user = $('#username').val();
	var update = false;

	$.ajax({
		url: docurl,
		type: 'GET',
		contentType: 'application/json; charset=utf-8'
	}).done(function(response) {
		$('#editarea').val(response.documents.content);
	});

	setInterval(function() {
		$.ajax({
			url: docurl,
			type: 'GET',
			contentType: 'application/json; charset=utf-8'
		}).done(function(response) {
			var storeddata = response.documents.content;
			if (update) {
				update = false;
				var currentdata = $('#editarea').val();
				var newdata = { documents: [{
					id: docid,
					last_edit_by: user,
					content: currentdata
				}]};
				$.ajax({
					url: docurl,
					type: 'POST',
					data: JSON.stringify(newdata)
				}).done(function() {
					console.log('newdata is saved');
				});
			} else {
				$('#editarea').val(storeddata);
			}
		});
	}, UPDATE_INTERVAL);

	$('#editarea').keydown(function() {
		update = true;
		console.log('update');
	});
});
