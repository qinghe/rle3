# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def build_tabs( tabs)
    menu = '<ul class="tabs clear-block">'
    tabs.each{|tab|
      menu << '<li>'
      menu << yield(tab) 
      menu << '</li>'
    }
    menu << "</ul>"
  end
  
  def my_remote_function(options)
    url = url_for( options[:url] )
    form =  options[:submit]
    callback = nil
#    callback = %q! function (data, textStatus, xhr){ $("#editors").html(xhr.responseText); }!
    return " ajax_post('#{url}','#{form}','script');return false;"
    
  end
  
end
