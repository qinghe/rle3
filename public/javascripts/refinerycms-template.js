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
  
})
function submit_layout_tree_form (op, layout_id, selected_section_id) {
  $('#op').val(op);
  // layout_id, selected_section_id could be null.
  if (layout_id) $('#layout_id').val(layout_id);
  if (selected_section_id) $('#selected_section_id').val(selected_section_id);
  $('#layout_tree_form').trigger('submit');
}
