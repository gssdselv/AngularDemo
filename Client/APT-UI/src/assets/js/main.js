$(function () {

	if (window.location.pathname.indexOf("/report.html") >= 0) {
		$(".panelclose").click(function(){
			value = $('.leftpanel').css('left') === '0px' ? '-200px' : 0 ;
			contentfullwidth = ($(window).width()) - 200;
			contentwidth= $('.rightpanel').css('margin-left')==='200px' ? '100%' : contentfullwidth+'px';
			marvalue= $('.rightpanel').css('margin-left')=='200px' ? '0' : '200px';
			$('.leftpanel').animate({
				left: value                        
			});
			$('.rightpanel').animate({
				marginLeft: marvalue,
				width:contentwidth
			});
			$(this).find('i').toggleClass('fa-chevron-right');
		});
		$('.filtercategory').slimScroll({
			color: '#add3ed',
			railColor : '#02040a',
			railVisible: true,
			railOpacity : 1,
			opacity:1,
			size: '5px',
			alwaysVisible: false,
			height:'calc(100% - 106px)'
		});
	let fromdate = document.getElementById('fromdate');
		let picker1 = new Lightpick({
			field: fromdate,
			orientation: 'top',
			onSelect: function(date){
				fromdate.value = date.format('DD/MM/YYYY');
			}
		});
		let todate = document.getElementById('todate');
		let picker2 = new Lightpick({
			field: todate,
			orientation: 'top',
			onSelect: function(date){
				todate.value = date.format('DD/MM/YYYY');
			}
		});
		

	}
	else
	{


		let datePicker = document.getElementById('datetimepicker1');
		let picker = new Lightpick({
			field: datePicker,
			orientation: 'top',
			onSelect: function(date){
				datePicker.value = date.format('DD/MM/YYYY');
			}
		});
		let datetimepicker2 = document.getElementById('datetimepicker2');
		let picker1 = new Lightpick({
			field: datetimepicker2,
			orientation: 'top',
			onSelect: function(date){
				datetimepicker2.value = date.format('DD/MM/YYYY');
			}
		});
		let datetimepicker3 = document.getElementById('datetimepicker3');
		let picker2 = new Lightpick({
			field: datetimepicker3,
			orientation: 'top',
			onSelect: function(date){
				datetimepicker3.value = date.format('DD/MM/YYYY');
			}
		});
		let datetimepicker4 = document.getElementById('datetimepicker4');
		let picker3 = new Lightpick({
			field: datetimepicker4,
			orientation: 'top',
			onSelect: function(date){
				datetimepicker4.value = date.format('DD/MM/YYYY');
			}
		});

		$('[data-toggle="popover"]').popover();  
	}
});