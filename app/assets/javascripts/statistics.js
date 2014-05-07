// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){

	$('#por').select2();
	$('#campus').select2();

	validateStatistics($('#show_form'),'#campus', 'campus');
	validateStatistics($('#campus_form'),'#por','punto de reciclaje');

	

})


function validateStatistics($form, select, option_type){
var msgOnce=0; //variable para evitar que los mensaje se agreguen mas de una vez
	$form.on("submit", function(e){
		var $field= $form.find(select);

		if ($field.val() === null){

			$field.parent().addClass('field_with_errors');
			$field.parent().css('background','#ecf0f1');

			
			if (msgOnce===0){
				$form.before('<div id="error_explanation" class="span">Porfavor revisa los problemas que se muestran a continuación:</div>');
				$field.parent().append('<br><p>Debe haber al menos un ' + option_type + ' seleccionado</p>');
				msgOnce++;
			}
			
			e.preventDefault();

		}

        
	});
}