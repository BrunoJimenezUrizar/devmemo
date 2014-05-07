// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.



$(function(){

	$(".add_fields").click(function(event){
		time = new Date().getTime();
		regexp = new RegExp($(this).data('id'), 'g');
		$(this).before($(this).data('fields').replace(regexp, time));
		event.preventDefault();
	});

	$("a#cancel_button").click(function(event){
		("form").remove();
		event.preventDefault();
	});

	// Función para hacer que los accordeones de las universidades
	// dejen de aparecer seleccionados cuando se comprimen automáticamente
	// Simplemente agrega la clase 'collapsed' a todos los otros acordeones
	// que no hayan sido seleccionados.
	$("a.accordion-toggle").on("click", function(event){
		var parent = $(this).parents("div.accordion-group").first();
		var $siblings = $(parent).siblings("div.accordion-group");

		$siblings.each(function(){
			$(this).find("a.accordion-toggle").addClass("collapsed");
		});
	});

	$('#modal-university').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });
});
