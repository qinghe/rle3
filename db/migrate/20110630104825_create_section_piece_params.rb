class CreateSectionPieceParams < ActiveRecord::Migration
  def self.up
    create_table :section_piece_params, :force=>true do |t|
      t.column :section_piece_id,        :integer, :limit => 2,     :null => false, :default => 0
      t.column :editor_id,               :integer, :limit => 2,     :null => false, :default => 0
      t.column :param_category_id,       :integer, :limit => 2,     :null => false, :default => 0
      t.column :position,       :integer, :limit => 2,     :null => false, :default => 0
      # get param_value order by ssection_piece_params.position
      t.column :pclass,                  :string 
      # since a html style attribute also could in css, 
      # it tell where use the current param. possible value style,css,erb
       
      # the param class, can be 1class = the param will be written to the css file,
                                                # 2style = the param will be written in a style clause,
                                                # 3group = this html param is grouped together with other html params for display
                                                # 4var = this param represents a general variable
                                                # 5db = this param represents a database object
                                                # 6string = this is an id in the cstrings table
                                                # 7themeimg = this is the file name of a theme image
                                                # 8bool = present a checkbox or similar to the user, stored value is "1" or "0"
                                                # pbool = present a checkbox or similar or hidden section param to the user,  stored value is "1" or "0"
                                                #         when do previewing, it is always return true, so the content in the ~~if~~ always be rendered. 
                                                #         then the ajax updates could update the content.
                                                # 9int = expect an integer
                                                # asections = expect a list of section ids
                                                # bsection = expect a section id
                                                # cblocks = expect a list of section ids (container sections only) - no longer used
                                                # dchoice = multiple choice strings from html_attributes table presented as a select
                                                # eurl = url
                                                # radio = multiple choice strings presented as radio buttons
                                                # mcclass = pvalues.pvalue is not used. html_attributes pvalues = the list of included section_param ids
                                                #   the section_params listed must have pclass='ssclass' and must have been originally 1class.
                                                # ssclass = default_value|pid{page_value}pid{...}...
                                                #   where default_value is the same as for 1class, pid is a page (menu item) id,
                                                #   and page_value is like default_value but applies to that page. The order of pids is not important
                                                # xheading = a heading displayed above a group of related section params
      t.column :class_name,              :string,                    :null => false, :default => "" # if pclass == class, class_name = the name of the class
                    # if pclass == style, class_name = the name of the style
                    # if pclass == group, class_name = the name of the group of html attributes
                    # if pclass == db, class_name = the database object that this param represents, ex Menus, Groups, Products, ...
      t.column :html_attribute_ids,      :string,   :limit => 1000,  :null => false, :default => ""
      t.column :param_conditions,        :string,   :limit => 1000#,  :null => false, :default => ""
      t.boolean :is_editable,     :default=>true # some uneditable section piece param store the computed value.  like 'inner_height'

    end
  end

  def self.down
    drop_table :section_piece_params
  end
end
