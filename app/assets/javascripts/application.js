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
//= require turbolinks
//= require_tree .


//$(document).ready(function(){
//$("#finds_expense").trigger('submit');
//});


$(function(){
	$('.rating').click(function(){
		var star = $(this);
		var stars = $(this).attr('data-stars');

		for (i=1;i<=5;i++){
			if(i <= stars){
				$('#' + 'rating_star' + '_' + i).removeClass('glyphicon glyphicon-star-empty');
				$('#' + 'rating_star' + '_' + i).addClass('glyphicon glyphicon-star');
			} else {
				$('#' + 'rating_star' + '_' + i).removeClass('glyphicon glyphicon-star');
				$('#' + 'rating_star' + '_' + i).addClass('glyphicon glyphicon-star-empty');
			}
		}

	});
});







