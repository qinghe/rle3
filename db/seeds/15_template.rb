#################################  template resource #####################################
template = TemplateTheme.first

title = 'Main menu'

main_menu_section = template.page_layout.self_and_descendants.where(:title=>title).first
main_menu = Menu.find_by_title(title)

template.assign_resource(main_menu, main_menu_section)

title="Blog category"
blog_category_section = template.page_layout.self_and_descendants.where(:title=>title).first
blog_category = Menu.find_by_title(title)
template.assign_resource(blog_category, blog_category_section)

template_files = template.template_files
title="Logo"
logo_section = template.page_layout.self_and_descendants.where(:title=>title).first
logo_file = template_files.select{|file| file.attachment_file_name=~/logo/ }.first
template.assign_resource(logo_file, logo_section)


#################################  template css #####################################
ActiveRecord::Base.connection.reconnect!
# strange it always  'Lost connection to MySQL server' here
html_page = template.html_page
for partial_html in html_page.partial_htmls
  case partial_html.page_layout.title
  when 'Main menu'
    partial_html['block_background-color']['pvalue'] = '#D74700'
    partial_html['block_background-color'].update
  when 'content'
    partial_html['block_height']['unset'] = true
    partial_html['block_height'].update
    partial_html['content_layout_horizontal']['pvalue'] = true
    partial_html['content_layout_horizontal'].update
    
  when 'main content'
    partial_html['block_height']['unset'] = true
    partial_html['block_height'].update
    partial_html['block_width']['pvalue'] = 600
    partial_html['block_width'].update
    
  when 'lftnav'
    partial_html['block_height']['unset'] = true
    partial_html['block_height'].update
    partial_html['block_width']['pvalue'] = 200
    partial_html['block_width'].update
    partial_html['block_background-color']['pvalue'] = '#FFF8ED'
    partial_html['block_background-color'].update
  when 'footer'
    partial_html['block_background-color']['pvalue'] = '#F5F5F5'
    partial_html['block_background-color'].update
  end
end