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
// require rails-ujs
//= require jquery
// require twitter/bootstrap
//= require jquery_ujs
//= require bootstrap/js/bootstrap.bundle
//= require activestorage
//= require Chart.bundle
//= require chartkick
//= require turbolinks
//= require turbolinks-compatibility

// Start for AGENCY
//= require js_agency/jqBootstrapValidation
//= require js_agency/contact_me
//= require js_agency/agency.min
// End for AGENCY

//START FOR ADMIN
// require jquery_sb-admin/jquery
//= require jquery-easing_sb-admin/jquery.easing
//= require chart.js/Chart.min
// require datatables/jquery.dataTables
// require datatables/dataTables.bootstrap4
//= require js_sb-admin/sb-admin.min
// require js_sb-admin/demo/datatables-demo
//= require js_sb-admin/demo/chart-area-demo
//END FOR ADMIN
//= require_self
//= require_tree .

var turbolinks = jQuery.Event('turbolinks:load');
// $(document).trigger(
// 	$(document).on('ready turbolinks:load',function(){
// 	$('.rating-star').click(function(){
// 		var star = $(this);
// 		var data_form = $(this).attr('data-form');
// 		var data_field = $(this).attr('data-field');
// 		var stars = $(this).attr('data-stars');

// 		for (i=1;i<=5;i++){
// 			if(i <= stars){
// 				$('#' + 'rating' + '_' + data_form + '_' + i).removeClass('glyphicon glyphicon-star-empty');
// 				$('#' + 'rating' + '_' + data_form + '_' + i).addClass('glyphicon glyphicon-star');
// 			} else {
// 				$('#' + 'rating' + '_' + data_form + '_' + i).removeClass('glyphicon glyphicon-star');
// 				$('#' + 'rating' + '_' + data_form + '_' + i).addClass('glyphicon glyphicon-star-empty');
// 			}
// 		}
// 		$('#' + data_field).val(stars);
// 		$('#' + 'feedback').val(stars);
// 	});
// }));









