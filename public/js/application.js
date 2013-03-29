$(document).ready(function() {
  $('div.main a').click(function(e) {
    e.preventDefault();
    album_id = $(this).attr('class');
    $('img.'+album_id).toggle();
    $('div#'+album_id).toggle();
  });

  $('div.photos img, div.displayed_photos img').on('click', function(e) {
    $(this).toggleClass('selected')
    var image_url = $(this).attr('src');
    $('form').append("<input type='hidden' name='photos[]' value='"+image_url+"'>");
  });

$("#slideshow > div:gt(0)").hide();

setInterval(function() { 
  $('#slideshow > div:first')
    .fadeOut(1000)
    .next()
    .fadeIn(1000)
    .end()
    .appendTo('#slideshow');
},  3000);
  
  $('a#flickr').click(function() {
    $(this).parent().hide();
    $('form#flickr').show();
  });

  // $('form#flickr').on('submit', function(e) {
  //   e.preventDefault();

  //   $.ajax({
  //     url:
  //     method: "post"
  //     $(this).serialize();
  //   })
  // });

});
