// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require twitter/bootstrap
//= require activestorage
//= require Chart.bundle
//= require chartkick
//= require pace/pace.min
//= require jquery_ujs
//= require bootstrapv3/js/bootstrap.min
//= require jquery-block-ui/jqueryblockui.min
//= require jquery-unveil/jquery.unveil.min
//= require jquery-scrollbar/jquery.scrollbar.min
//= require jquery-numberAnimate/jquery.animateNumbers
//= require jquery-validation/js/jquery.validate.min
//= require bootstrap-select2/select2.min
//= require js/webarch
//= require turbolinks
//= require_tree .


//$(document).ready(function(){
//$("#finds_expense").trigger('submit');
//});

//function for Star Rating
document.addEventListener("turbolinks:load",function(){
	$('.rating-star').click(function(){
		var star = $(this);
		var data_form = $(this).attr('data-form');
		var data_field = $(this).attr('data-field');
		var stars = $(this).attr('data-stars');

		for (i=1;i<=5;i++){
			if(i <= stars){
				$('#' + 'rating' + '_' + data_form + '_' + i).removeClass('glyphicon glyphicon-star-empty');
				$('#' + 'rating' + '_' + data_form + '_' + i).addClass('glyphicon glyphicon-star');
			} else {
				$('#' + 'rating' + '_' + data_form + '_' + i).removeClass('glyphicon glyphicon-star');
				$('#' + 'rating' + '_' + data_form + '_' + i).addClass('glyphicon glyphicon-star-empty');
			}
		}
		$('#' + data_field).val(stars);
		$('#' + 'feedback').val(stars);
	});
});
/*
$(document).ready(function(){
  var formData = $("#finds_expense").serialize();
  $.ajax({
   url: 'expenses_search',
   data: formData,
   type: 'GET',
   contentType: 'application/script'
  });
});
*/







