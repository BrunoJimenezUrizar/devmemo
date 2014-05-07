// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.


$(function(){
var msgOnce=0; //variable para evitar que los mensaje se agreguen mas de una vez
	$('#mobile_user_form').on("submit", function(e){
		var $field1= $('#mobile_user_form').find('input#from');
		var $field2= $('#mobile_user_form').find('input#to');
		

		if ( $field1.val()=="" || $field2.val()=="" ){

			$field1.parent().addClass('field_with_errors');
			
			if (msgOnce===0){
				
				$field2.parent().append('<br><p>Las fechas no pueden estar en blanco</p>');
				msgOnce++;
			}
			
			e.preventDefault();

		}

			if ( $field2.val() < $field1.val() ){

			$field1.parent().addClass('field_with_errors');
			
			if (msgOnce===0){
				
				$field2.parent().append('<br><p>Las fechas estan en orden incorrecto</p>');
				msgOnce++;
			}
			
			e.preventDefault();

		}

        
	});

	$('#mobile_users_table').dataTable({
		"sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
  		"sPaginationType": "bootstrap",
  		"aaSorting": [],
  		"oLanguage": {
                "sProcessing":     "Procesando...",
			    "sLengthMenu":     "Mostrar _MENU_ registros",
			    "sZeroRecords":    "No se encontraron resultados",
			    "sEmptyTable":     "Ningún dato disponible en esta tabla",
			    "sInfo":           "Registros _START_ al _END_ de _TOTAL_ ",
			    "sInfoEmpty":      "Mostrando registros del 0 al 0 de un total de 0 registros",
			    "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
			    "sInfoPostFix":    "",
			    "sSearch":         "Buscar:",
			    "sUrl":            "",
			    "sInfoThousands":  ",",
			    "sLoadingRecords": "Cargando...",
			    "oPaginate": {
			        "sFirst":    "Primero",
			        "sLast":     "Último",
			        "sNext":     "Siguiente",
			        "sPrevious": "Anterior"
			    },
			    "oAria": {
			        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
			        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
			    }
            }
	});

});