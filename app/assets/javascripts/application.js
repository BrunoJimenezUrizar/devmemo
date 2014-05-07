// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery_nested_form
//= require bootstrap-datetimepicker
//= require select2
//= require_tree .
//= require_self
//= require rails.validations
//= require rails.validations.simple_form
//= require rails.validations.nested_form
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require jquery.purr
//= require best_in_place


// Variables globales que usaremos para mantener los mapas:
var polygonMap;
var campusMap;
var pointsMap;

$(function()
{

    $("div#modal-building").delegate("#building-save","click", function(){
    	$("div#modal-building #new_building").submit();
    	$("div#modal-building .edit_building").submit();
    });
    $("div#modal-building").delegate("#floor-save","click", function(){
        $("#new_floor").submit();
        $(".edit_floor").submit();
    });
    $("div#modal-poi").delegate("#poi-save","click", function(){
    	$("#new_poi").submit();
    	$(".edit_poi").submit();
    });
    $("div#modal-por").delegate("#por-save","click", function(){
    	$("#new_por").submit();
    	$(".edit_por").submit();
    });
    $("div#modal-university").delegate("#university-save","click", function(){
        $("#new_university").submit();
        $(".edit_university").submit();
    });

    $("div#modal-event").delegate("#event-save","click", function(){
        $("#new_event").submit();
        $(".edit_event").submit();
    });
    $("div#modal-building").delegate("#campus-save","click", function(){
        $("#new_campus").submit();
        $(".edit_campus").submit();
    });

    $("div#modal-question").delegate("#question-save","click", function(){
        $("#new_question").submit();
    });
    $("div#modal-survey").delegate("#survey-save","click", function(){
        $("#new_question_group").submit();
        $(".edit_question_group").submit();
    });
    $("div#modal-category").delegate("#category-save","click", function(){
        $("#new_category").submit();
        $(".edit_category").submit();
    });
    $("div#modal-type").delegate("#type-save","click", function(){
        $("#new_type").submit();
        $("#new_complaint_type").submit();
        $(".edit_type").submit();
        $(".edit_complaint_type").submit();
    });

    $("#edit_university_roles").click(function(){

  
    });

    $("#select_admin_university").select2();
    $("#select_admin_campus").select2();

    $(".btn").tooltip();

    $('form').on('nested:fieldAdded', function(event) {
        $(event.target).find(':input').enableClientSideValidations();
    });

    $('.best_in_place').best_in_place();

    $('#modal-survey').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

    $('#modal-question').on('shown.bs.modal', function () {
        $(ClientSideValidations.selectors.forms).validate();
    });

    $('#questions_details').click();
    $('#questions_details').style.display = "none";

    

});

//metodo para desplegar ventana de ayuda en los modals
function HelpInfo(info){
  
  var numClicks=0;

  $('a.info').on('click', function(){
    if(numClicks===0){
        $(this).after('<div class="info">'+info+'</div>');
        numClicks++;
    }else{
        $('div.info').remove();
        numClicks--;
    }
    
  });
}

