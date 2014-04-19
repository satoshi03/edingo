// constants
var UPDATE_INTERVAL = 2000;
var BASEURL = '/documents/';

var documentdata = '';

$(function() {
	var docid = $('#docid').val();
	var docurl = BASEURL + docid;
	var user = $('#username').val();
	var update = false;

	$.ajax({
		url: docurl + '.json',
		type: 'GET',
		contentType: 'application/json; charset=utf-8'
	}).done(function(response) {
		$('#editarea').val(response.documents[0].content);
	});

	setInterval(function() {
		$.ajax({
			url: docurl + '.json',
			type: 'GET',
			contentType: 'application/json; charset=utf-8'
		}).done(function(response) {
			var storeddata = response.documents[0].content;
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
					type: 'PUT',
					data: newdata
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
