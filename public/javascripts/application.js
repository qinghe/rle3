// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// set this for global ajax request.

$(document).ready(function() {
  
  $("#publish input:radio").filter('.menu_inheritance').change(function(){
    $(this).parent().next().children().toggle();
  });

})

//$('#layout_tree_form').bind('ajax:success', function(evt, data, status, xhr){
//    $('#page_layout_tree').html(xhr.responseText);
//  });
