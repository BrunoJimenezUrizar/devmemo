$(function(){

	$('#modal-poi').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

});