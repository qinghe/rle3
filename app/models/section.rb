class Section < ActiveRecord::Base
  belongs_to :section_piece  
  has_many :section_params
  acts_as_nested_set #:scope=>"root_id"
  
  # usage: attribute section_piece_id, perma_name required
  # params: default_param_value,  is a hash,  class_name=>{htmal_attribute_id=>default_value,..}
  def self.create_section(section_piece_id,attrs = {}, default_param_value={})
    #create record in table sections
    obj = nil
    self.transaction do      
      obj = create(:section_piece_id=> section_piece_id) do |sp|
        sp.section_piece_instance = 1
        sp.attributes= attrs unless attrs.empty?
      end
      #copy the section piece param  to section param table
      obj.add_section_piece_param(default_param_value)
      #set root_id, css need root_piece_instance_id as selector
      obj.update_attribute("root_id", obj.id)
    end
    obj
  end  
  
  # return created section
  def add_section_piece(section_piece_id, default_param_value={})
    section_piece = SectionPiece.find(section_piece_id)
    tree = self.root.self_and_descendants
    section_piece_instance = tree.select{|xnode| xnode.section_piece_id==section_piece_id}.size.succ
    atts = {:website_id=>website_id, :section_piece_id=>section_piece_id, :section_piece_instance=>section_piece_instance, :perma_name=>"#{section_piece.perma_name}#{section_piece_instance}"}
    obj = nil
    self.class.transaction do      
      obj = self.class.create!(atts)
      obj.move_to_child_of(self)
      obj.add_section_piece_param(default_param_value)
      obj.update_attribute("root_id", self.root_id)      
    end
    obj
  end
  
  def build_html
     section_piece_hash = SectionPiece.all().inject({}){|h, s| h[s.id] = s; h}
     tree = self.self_and_descendants
     build_html_piece(tree, self, section_piece_hash)
  end

  def build_css
     section_piece_hash = SectionPiece.all().inject({}){|h, s| h[s.id] = s; h}
     tree = self.self_and_descendants
     build_css_piece(tree, self, section_piece_hash)
  end
  

  # Usage:  add section piece param into this section  
  # params: default_param_value,  is a hash,  class_name=>{htmal_attribute_id=>default_value,..}
  def add_section_piece_param(default_param_values={})
    # section_id, section_piece_param_id, section_piece_id, section_piece_instance, is_enabled, disabled_ha_ids
    section_piece_params = section_piece.section_piece_params
    exclude_keys = [:disabled_ha_ids]
    section_root_id = self.root.id
      for spp in section_piece_params
        section_param = SectionParam.create(:section_root_id=>section_root_id) do |sp|
          sp.section_id = self.id
          sp.section_piece_param_id = spp.id
          #sp.is_enabled =
          if default_param_values.key?(spp[:class_name])
            dpvs = default_param_values.fetch spp[:class_name]
            sp.default_value = dpvs.except(*exclude_keys)
            sp.disabled_ha_ids = dpvs['disabled_ha_ids'].to_s
          end
          sp.default_value ||={}
        end
      end
  end
    
  def global_event_array
    if @global_event_array.nil?
      @global_event_array = self.global_events.split(',')
    end
    @global_event_array
  end
  
  def subscribed_global_event_array
    if @subscribed_global_event_array.nil?
      @subscribed_global_event_array = self.subscribed_global_events.split(',')
    end
    @subscribed_global_event_array
  end
  
  begin 'build html, css, js for section'  
    def build_html_piece(tree, node, section_piece_hash)
      # .dup, do not alter the model, or affect other method. it may be in cache. 
       piece = node.section_piece.html.dup
       piece.insert(0,get_header_script(node))
       unless node.leaf?              
         children = tree.select{|n| n.parent_id==node.id}
         for child in children
           subpiece = build_html_piece(tree, child, section_piece_hash)
           if(pos = (piece=~/~~content~~/))           
             piece.insert(pos,subpiece)
           else           
             piece.concat(subpiece)
           end
         end
       end
       piece
    end
    
    def build_css_piece(tree, node, section_piece_hash)
      #duplicate the css, then modify it.
       piece = section_piece_hash[node.section_piece_id].css.dup
       piece.insert(0,get_header_script(node))
       unless node.leaf?              
         children = tree.select{|n| n.parent_id==node.id}
         for child in children
           subpiece = build_css_piece(tree, child, section_piece_hash)               
           piece.concat(subpiece)
         end
       end
       piece
    end
    
    def build_js_piece(tree)
      js_ids = ''               
      for node in tree
        js_ids.concat(section_piece_hash[node.section_piece_id].js)
      end
      piece = ''
      unless js_ids.empty?
        jss = Js.find(js_ids.split(','))
        piece = jss.inject(''){|sum, js| sum.concat(js.content); sum}
      end
      piece
    end
    
    def get_header_script(node)
      reject_keys = ["created_at","created_on","updated_at", "udpated_on"]
      header = "<? section_piece=#{node.attributes.except(*reject_keys).inspect}; ?>#{$/}"
      #only set @param_values, @menus for root piece.
      header << "<? @param_values.setup(section,section_piece) ?>#{$/}" 
      header << "<? @menus.setup(section,section_piece) ?>#{$/}" if node.section_piece.is_menu?
      header
    end 
    
  end
end
