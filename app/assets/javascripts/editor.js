// constants
var UPDATE_INTERVAL = 2000;
var BASEURL = '/';

var documentdata = '';

$(function() {
	var docid = $('#docid').val();
	var docurl = BASEURL + docid;
	var user = $('#username').val();
	var update = false;

	setInterval(function() {
		$.ajax({
			url: docurl,
			type: 'GET',
			contentType: 'application/json; charset=utf-8'
		}).done(function(response) {
			var storeddata = response.data;
			if (update) {
				update = false;
				var currentdata = $('#editarea').val();
				var newdata = {
					user: user,
					data: currentdata
				};
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
