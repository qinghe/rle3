function ajax_post (url, form, data_type, callback) {
  $.ajax({type:'post',data:$("#"+form+" :input").serialize(), url:url,dataType:data_type, success:callback });   
}

/*   start js for ajax  */
function ajax_get(url)
{ 
  $.ajax({type:'get', url:url,dataType:'script'});    
}
