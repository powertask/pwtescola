$(function() {
    $( '#due_at' ).datepicker({
		format: "dd/mm/yyyy",
      	autoclose: true,
      	startDate: "01/01/2017"
    });
  });

$(function() {
    $( '#paid_at' ).datepicker({
      	showOtherMonths: true,
		formatDate: "dd/mm/yyyy",
      	selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: "Fechar",
		currentText: "Hoje",
		maxDate: new Date(2020, 1, 1),
		showButtonPanel: true    });
  });

$(function() {
    $( '#datepicker1' ).datepicker({
      	showOtherMonths: true,
		formatDate: "dd/mm/yyyy",
      	selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: "Fechar",
		currentText: "Hoje",
		showButtonPanel: true,
		minDate: new Date(1900, 1, 1)
    });
  });

$(function() {
    $( '#datepicker2' ).datepicker({
      	showOtherMonths: true,
		formatDate: "dd/mm/yyyy",
      	selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		closeText: "Fechar",
		currentText: "Hoje",
		showButtonPanel: true,
		minDate: new Date(1900, 1, 1)
    });
  });
