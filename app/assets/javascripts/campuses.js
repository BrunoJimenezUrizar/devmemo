$(function(){
	$("body").delegate("a.edit_btn","mouseenter",function(){$(this).addClass("btn-primary");});
	$("body").delegate("a.edit_btn","mouseleave",function(){$(this).removeClass("btn-primary");});

	$("body").delegate("a.delete_btn", "mouseenter", function(){$(this).addClass("btn-danger");});
	$("body").delegate("a.delete_btn", "mouseleave", function(){$(this).removeClass("btn-danger");});

	$('#modal-campus').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });
});
