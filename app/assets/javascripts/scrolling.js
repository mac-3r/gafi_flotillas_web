
$( window ).scroll(function() {
  url = $('#view-more a').attr('href');
  if ($(window).scrollTop() == ($(document).height() -  $(window).height()) ) {
    $('#view-more').html('Cargando contenido');
    //alert(url);
    $.getScript(url, function(){

    });
  }
});