$(function(){

	$('#modal-por').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

});