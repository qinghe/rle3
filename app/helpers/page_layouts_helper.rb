module PageLayoutsHelper
  def self.build_html_attribute_container_id(param_value_id, html_attribute_id)
    "pv_#{param_value_id}_#{html_attribute_id}"
  end
  
  def build_html_attribute_container_id(param_value_id, html_attribute_id)
    PageLayoutsHelper.build_html_attribute_container_id(param_value_id, html_attribute_id)
  end 
  
  def build_page_layout_source_path(page_layout)
    "/page_layouts/content/#{page_layout[:id]}"
  end
  def build_page_layout_preview_path(page_layout)
    "/page_layouts/preview/#{page_layout[:id]}"
  end
  def page_layouts_path()
    {:action=>"index"}
  end
  def page_layout_path(page_layout, action="show")
    {:action=>action, :id=>page_layout}
  end  
end
