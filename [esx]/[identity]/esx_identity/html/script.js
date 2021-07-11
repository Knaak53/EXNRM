$(function() {
	var sexSelected = "m"
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
		}
	});

	document.onkeyup = function (data) {
		if (data.which == 27) { // Escape key
			$.post('http://esx_identity/escape', JSON.stringify({}));
		}
	};	

	$('#m').click(function(){
		sexSelected = "m"
		let text = "Sexo seleccionado: Masculino"
		$('#selectedsex').text(text);
	});
	$('#f').click(function(){
		sexSelected = "f"
		let text = "Sexo seleccionado: Femenino"
		$('#selectedsex').text(text);
	});

	$(document).on('input', '#heighInput', function() {
		console.log( $(this).val() );
		let text = "Altura seleccionada: "+$(this).val()
		$('#rangeshow').text(text)
	});
	
	$("#register").submit(function(event) {
		event.preventDefault(); // Prevent form from submitting
		
		// Verify date
		var date = $("#dateofbirth").val();
		var dateCheck = new Date($("#dateofbirth").val());

		if (dateCheck == "Invalid Date") {
			date == "invalid";
		}
		$.post('http://esx_identity/register', JSON.stringify({
			name: $("#name").val(),
			firstname: $("#firstname").val(),
			lastname: $("#lastname").val(),
			dateofbirth: date,
			sex: sexSelected,
			height: $('#heighInput').val()
		}));
	});
});
