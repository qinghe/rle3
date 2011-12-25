// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
// set this for global ajax request.
function ajax_post (url, form, data_type, callback) {
  $.ajax({type:'post',data:$("#"+form+" :input").serialize(), url:url,dataType:data_type, success:callback });   
}

/*   start js for ajax  */
function ajax_get(url)
{ 
  $.ajax({type:'get', url:url,dataType:'script'});    
}

$(document).ready(function() {
  $("#section_select_dialog").dialog({ autoOpen: false,
                                       buttons: { "Cancel": function() { $(this).dialog("close"); },
                                                  "OK": function() { submit_layout_tree_form( 'add_child',null, $(this).find('[name="selected_section_id"]').val());
                                                                     $(this).dialog("close"); }
                                                }  });
  $("#section_select_dialog .titles li").click(function(){
    $(this).parent().children().removeClass('selected');
    $(this).addClass('selected'); 
    $(this).parent().next().children().removeClass('selected');
    $(this).parent().next().children().eq($(this).index()).addClass('selected');
    $(this).parent().siblings('input').val($(this).attr('data-section-id'))
  });
  
  $("#publish input:radio").filter('.menu_inheritance').change(function(){
    $(this).parent().next().children().toggle();
  });
  

})

function submit_layout_tree_form (op, layout_id, selected_section_id) {
  $('#op').val(op);
  // layout_id, selected_section_id could be null.
  if (layout_id) $('#layout_id').val(layout_id);
  if (selected_section_id) $('#selected_section_id').val(selected_section_id);
  $('#layout_tree_form').trigger('submit');
}
//$('#layout_tree_form').bind('ajax:success', function(evt, data, status, xhr){
//    $('#page_layout_tree').html(xhr.responseText);
//  });
