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
