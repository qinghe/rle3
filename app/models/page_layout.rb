class PageLayout < ActiveRecord::Base
  belongs_to :section  
  has_many :themes, :class_name => "TemplateTheme",:foreign_key=>:layout_id
  acts_as_nested_set :scope=>"root_id" # scope is for :copy, no need to modify parent_id, lft, rgt.
  #has_many :param_values, :foreign_key=>:layout_id, :primary_key=>root.id
  # remove section relatives after page_layout destroyed.
  before_destroy :remove_section

  # a page_layout tree could be whole html or partial html, it depend's on self.section.section_piece.is_root?,  
  # it is only for root.
  def is_html_root?
    self.section.section_piece.is_root? 
  end
  
  def has_child?
    return (rgt-lft)>1
  end
        
  def children
    tree = self.root.self_and_descendants
    tree.select{|node| node.parent_id==self.id}
  end      
  
  # param values of self.
  def param_values(theme_id,editor_id=0)
    if editor_id>0
    ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
     :conditions=>["layout_id=? and theme_id=? and section_piece_params.editor_id=?", self.id, theme_id, editor_id],
     :order=>"section_piece_params.editor_id, param_categories.position")
      
    else
    ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
     :conditions=>["layout_id=? and theme_id=?", self.id, theme_id],
     :order=>"section_piece_params.editor_id, param_categories.position")
        
    end
  end

  # param values of whole layout tree.
  def whole_param_values(theme_id)
    ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
     :conditions=>["root_layout_id=? and theme_id=?", self.id, theme_id],
     :order=>"section_piece_params.editor_id, param_categories.position")
   
  end
  #notice: attribute section_id, perma_name required
  # section.root.section_piece_id should be 'root'
  def self.create_layout(section_id, title, attrs={})
    #create record in table page_layouts
    obj = create!(:section_id=>section_id) do |l|
      l.title = title
      l.perma_name = title.underscore
      l.attributes = attrs unless attrs.empty?
      l.section_instance = 1
    end
    obj.update_attribute("root_id",obj.id)
    #create a theme for it.
    TemplateTheme.create!({:website_id=>obj.website_id,:layout_id=>obj.id,:title=>"theme for layout#{obj.id}",:perma_name=>"theme#{obj.id}"}) 
    #copy the default section param value to the layout
    obj.add_param_value()
    obj
  end


  # user copy prebuild layout tree to another layout tree as child.
  # copy it self and decendants to new parent. this only for root layout.
  # include theme param values. add theme param values to all themes which available to the new parent.
  def add_layout_tree(copy_layout_id)
    
    copy_layout = self.class.find(copy_layout_id)
    raise "only for root layout" unless copy_layout.root?
    
    copy_layout.copy_to_new_parent(self)
    
  end

  
  #
  #  cached_whole_tree, it is whole tree of new parent, to compute new added section instance.
  #  added_section_ids, new added section ids, but not in cache.
  #  root_layout.copy_to()
  def copy_to_new_parent(new_parent, cached_whole_tree = nil, added_section_ids=[])
    
    cached_whole_tree||= new_parent.root.self_and_descendants
    
    new_section_instance =  ( cached_whole_tree.select{|xnode| xnode.section_id==self.section_id}.size +
      added_section_ids.select{|xid| xid==self.section_id}.size ).succ
    
    clone_node = self.clone
    clone_node.parent_id = new_parent.id
    clone_node.root_id = new_parent.root_id
    clone_node.section_instance = new_section_instance
    clone_node.copy_from_root_id =  self.root_id
    
    clone_node.save!    
    added_section_ids << clone_node.section_id

    # it should only have one theme.
    copy_theme = self.root.themes.first
    table_name = ParamValue.table_name    
    table_column_names = ParamValue.column_names
    table_column_names.delete('id')
    # copy param values to all available themes
    for theme in clone_node.root.themes
      table_column_values  = table_column_names.dup
      table_column_values[table_column_values.index('root_layout_id')] = clone_node.root_id
      table_column_values[table_column_values.index('layout_id')] = clone_node.id
      table_column_values[table_column_values.index('theme_id')] = theme.id
      table_column_values[table_column_values.index('section_instance')] =  clone_node.section_instance
    
      sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE ((root_layout_id=#{self.root_id} and layout_id =#{self.id}) and (theme_id =#{copy_theme.id}) and section_id=#{self.section_id} and section_instance=#{self.section_instance})! 
      self.class.connection.execute(sql) 
    end 
        
    for node in self.children       
      node.copy_to_new_parent(clone_node, cached_whole_tree, added_section_ids)
    end
                
  end
  
  # user copy decendants of a layout to new root layout while user copy theme to new theme.
  # since copy to new root, there is no section_instance confliction.
  def copy_decendants_to_new_parent(new_parent)
    for node in self.children
      clone_node = node.clone
      clone_node.parent_id = new_parent.id
      clone_node.root_id = new_parent.root_id
      clone_node.save!
      if node.has_child?
        node.copy_decendants_to_new_parent(clone_node)
      end
    end
    # root means we have copied all decendants and do not copy them other than root 
    if new_parent.root?
      self.class.update_all(["copy_from_root_id=?,updated_at=?, created_at=?",self.id, Time.now,Time.now],['root_id=?',new_parent.id])
    end
  end
    
  #
  # Usage: modify layout, add the section instance as child of current node into the layout,
  # Params: page_layout, instance of model PageLayout 
  # return: added page_layout record
  # 
  def add_section(section_id, attrs={})
    # check section.section_piece.is_container?
    obj = nil
    section = Section.find(section_id)    
    if section.root? and self.section.section_piece.is_container      
      whole_tree = self.root.self_and_descendants
      section_instance = whole_tree.select{|xnode| xnode.section_id==section.id}.size.succ
      atts = {:website_id=>website_id, :root_id=>root_id, :section_id=>section_id, :section_instance=>section_instance, :title=>"#{section.perma_name}#{section_instance}"}
      atts[:perma_name] = atts[:title].underscore
      atts.merge!(attrs)
      obj = self.class.create!(atts)      
      obj.move_to_child_of(self)
      #copy the default section param value to the layout
      obj.add_param_value()
    end
    obj
  end
  
  # Usage: remove param_values belong to self in every theme while destroy self(page_layout record)
  def remove_section
    remove_param_value()
  end
  
  def build_content(theme_id=0)
    tree = self.self_and_descendants.all(:include=>[:section=>:section_piece])
    # have to Section.all, we do not know how many section_pieces each section contained.
    sections = Section.all(:include=>:section_piece)
    section_hash = sections.inject({}){|h, s| h[s.id] = s; h}
    css = build_css(tree, self, section_hash, theme_id)
    html = build_html(tree,  section_hash)
    return html, css
  end
  # Usage: build html, js, css for a layout
  # Params: theme_id, 
  #         if passed, build css for that theme, or build css for default theme   
  #
  def build_html(tree, section_hash)
    build_section_html(tree, self, section_hash)
  end
  
  def build_css(tree, node, section_hash, theme_id=0)
    css = section_hash[node.section_id].build_css
    css.insert(0, get_header_script(node))    
    unless node.leaf?              
      children = tree.select{|n| n.parent_id==node.id}
      for child in children
        subcss = build_css(tree, child, section_hash)               
        css.concat(subcss)
      end
    end
    css
  end

  def build_js(tree, sections)
    section_ids = tree.collect{|node|node.section_id}
    section_piece_ids = sections.select{|s| section_ids.include?(s.root_id) or section_ids.include?(s.id) }.collect{|s| s.section_piece_id}
    js_ids = ''
    unless section_piece_ids.empty?
      section_pieces = SectionPiece.find(section_piece_ids)
      js_ids = section_pieces.inject(''){|sum, sp| sum.concat(sp.js); sum}
    end    
    unless js_ids.empty?
      
    end
    return ''
  end
  
  #Usage:  add param_value of section into this layout  
  def add_param_value()
    # section_id, section_piece_param_id, section_piece_id, section_piece_instance, is_enabled, disabled_ha_ids
    # all section_params belong to section tree.
    # section_tree = self.section.self_and_descendants
    # get default values of this section
    section_id = self.section.id
    layout_id = self.id
    root_layout_id = self.root.id
    themes = TemplateTheme.find(:all,:conditions=>['layout_id=?',root_layout_id])
    for theme in themes
        section_params = self.section.section_params
        for sp in section_params
          #use root section_id
          ParamValue.create(:root_layout_id=>root_layout_id, :section_id=>section_id, :layout_id=>layout_id, :section_instance=>self.section_instance) do |pv|
            pv.section_param_id = sp.id
            pv.theme_id = theme.id
# puts "sp.default_value=#{sp.default_value.inspect}"            
            pv.pvalue = sp.default_value   
            #set default empty {} for now.
          end
        end
    end
  end 
   
  def remove_param_value()
    layout_id = self.root.id
    themes = TemplateTheme.find(:all,:conditions=>['layout_id=?',layout_id])
    ParamValue.delete_all(["layout_id=?  and section_id=? and section_instance=? and theme_id in (?)", self.root.id,  self.section_id, self.section_instance, themes.collect{|obj|obj.id }])    

  end
   
  #param: some_event could be a global_param_value changed event or a section_event.
  def subscribe_event?( some_event)
    section_events = self.section.subscribed_global_event_array
    section_events.include? some_event.event_name   
  end
  
  #usage: raise this global_param_value_event to whole layout tree or not 
  def raise_event?( some_event)
    reserved_section_events = self.section.global_event_array    
    reserved_section_events.include? some_event.event_name       
  end
  # get all descendants which reserved the :some_event
  def nodes_for_event(some_event)
    @subscribe_event_nodes_hash ||={}
    unless @subscribe_event_nodes_hash.key?  some_event.event_name
      nodes = self.root.self_and_descendants.select{|layout| layout.section.global_event_array.include? some_event.event_name}
      @subscribe_event_nodes_hash[some_event.event_name] = nodes
    end
    @subscribe_event_nodes_hash[some_event.event_name]
  end
  
  private
  def build_section_html(tree, node, section_hash) 
    subpieces = ""
    unless node.leaf?              
      subnodes = tree.select{|n| n.parent_id==node.id}
      for child in subnodes
        subpiece = build_section_html(tree, child, section_hash)        
# Rails.logger.debug "layout_id = #{child.id}, html=#{subpiece}" 
        subpieces.concat(subpiece)
      end
    end  
     piece = node.section.build_html
     piece.insert(0,get_header_script(node))
     if node.root?
#       piece.insert(0,init_vars)  
     end
               
     if(pos = (piece=~/~~content~~/))           
       piece.insert(pos,subpieces)
     else           
       piece.concat(subpieces)
     end
     # remove ~~content~~ however, node could be a container.
     # there could be more than one ~~content~~, use gsub!
     piece.gsub!(/~~content~~/,'')       

  end

  def get_header_script(node)
    reject_keys = ["created_at","created_on","updated_at", "udpated_on"]
    header = "<? section=#{node.attributes.except(*reject_keys).inspect}?>#{$/}"
  end   
end
