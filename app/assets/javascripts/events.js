$(function(){

	$('#modal-event').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

});