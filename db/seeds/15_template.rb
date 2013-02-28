template = TemplateTheme.first

title = 'Main menu'

main_menu_section = template.page_layout.self_and_descendants.where(:title=>title).first
main_menu = Menu.find_by_title(title)

template.assign_resource(main_menu, main_menu_section)
