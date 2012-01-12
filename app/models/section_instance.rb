class SectionInstance
  SectionEnum = {'center_part'=>'center_part'}
  GlobalParamValueEventEnum={"page_layout_fixed"=>10}
  SectionEventEnum = {:disabled_event=>1, :removed_event=>2}

  # ultra_instantiate()
  # param: page_layouts should always be a whole tree, whatever it subscribe the event or not. 
  #  because the concerned node may need know the param value of parent,siblings or children.
  #  ex. fixed->fluid, need know parent's content_layout_ 
  def self.ultra_instantiate(page_layouts)
    objs =[]
    #get general param values for section instances
    
    layout_id = page_layouts.first.root_id
    # class_name = [block, inner, page, layout]
    pvs = ParamValue.all(:conditions=>["root_layout_id=?",layout_id ], :include=>[{:section_param=>:section_piece_param},:section])  
        
    for page_layout in page_layouts
      pvs_for_layout = pvs.select{|pv| pv.section_id==page_layout.section_id and pv.section_instance==page_layout.section_instance}
      parent_section_instance = objs.select{|obj| obj.is_parent_of?(page_layout)}.first
      new_section_instance =self.new(page_layout,  parent_section_instance, pvs_for_layout)   
      objs << new_section_instance
      if parent_section_instance
        parent_section_instance.children << new_section_instance
      end
    end
    return objs
  end
  
  attr_accessor :page_layout, :section, :param_values,  :parent, :children
  attr_accessor :updated_html_attribute_values # keep unsaved html_attribute_values
  # a page_layout record, infact it is a setion instance.
  #
  # parent_section_instance, we need param values of parents of current section instance while handling event, ex. parent's width.
  
  def initialize(page_layout,  parent_section_instance=nil, pvs=[])
    self.page_layout = page_layout
    self.section = page_layout.section
    self.parent = parent_section_instance
    self.param_values = pvs
    self.children = []
    self.updated_html_attribute_values =[]
  end
  
  def is_parent_of?( a_page_layout)
     self.page_layout.id == a_page_layout.parent_id
  end
  
  def children_hash
    if @children_hash.nil?
      @children_hash = children.inject({}){|h, c| h[c.perma_name] = c;h;}      
    end
    @children_hash
  end
  
  # xevent could be a global_param_value_event or section_event
  # it should return updated_html_attribute_values, action collect them and update the editor.
  def notify(xevent)
    updated_html_attribute_value_array =[]
    #see current section instance subscribe the xevent or not?
    # param_value_event, only this section subscribed, it is sended to section_instance.
    # global_param_value_event, once it is subscribed by original section instance, it is broadcasted to all section instance of the layout.    
    if xevent.kind_of?(ParamValueEvent) or 
      self.page_layout.subscribe_event?(xevent)
      event_name = xevent.event_name
      handler_name = xevent.kind_of?(ParamValueEvent) ? 
        "#{xevent.html_attribute.perma_name[/\w+/]}_#{event_name}_handler" : "#{event_name}_event_handler"
Rails.logger.debug "handler_name=#{handler_name},#{event_name}"      
      send handler_name, xevent      
      updated_html_attribute_value_array.concat( self.save )
    end
    #Rails.logger.debug "updated_html_attribute_value_array=#{updated_html_attribute_value_array.inspect}"    
    updated_html_attribute_value_array
  end
      
  # set or get html_attribute_value by key.
  # key is section_param.class_name+html_attribute.perma_name. ex."block_width"
  # new_attribute_values, instance of HtmlAttributeValue, 
  def html_attribute_values(key)
    if @html_attribute_value_hash.nil?
      @html_attribute_value_hash = {}
      for pv in self.param_values
        class_name = pv.section_param.section_piece_param.class_name
        pv.html_attribute_values_hash.values.each{|hav|
          unique_key = hav.computed? ?  "computed_#{class_name}_#{hav.html_attribute.perma_name}" : "#{class_name}_#{hav.html_attribute.perma_name}"
          @html_attribute_value_hash[unique_key]=hav
        }        
      end
      Rails.logger.debug "html_attribute_value_hash=#{@html_attribute_value_hash.keys.inspect}"
    end
    hav = @html_attribute_value_hash[key]
  end

# there are event, section_disabled, section_removed,
# ex. user disable a section like 'left_part', we need tell other section like 'center part' and 'right_part', it is disabled, please update your width.   
  def section_disabled_event_handler(section_event)
    # only 'center_area' subscribe this event
    source_section_name = section_event.source_section_name
    
      if source_section_name == 'left_part'
        
      elsif source_section_name == 'right_part'
        
      end
    
  end
  
# here are some user case
# center_part, left_part and right_part should always have same width unit.  
#                                                            fixed,                                     fluid                    
# 0. change left_part width from 150px to 200px     left_part_width+50, center_part_width-50   
# *1. change left_part width from 150px to 20%
# *2. change left_part width from 15% to 200px
# *3. center_area width from 100% to 800px 
# *4. center_area width from 800px to 100%  
# 5. page width from 800px to 900px
  
  # params: param_value_event is instance of GlobalParamValueEvent  
  def block_width_event_handler( param_value_event )
    # TODO make sure each child's width less then the container's width 
    # TODO support unit %
    is_value_changed = (param_value_event.event == ParamValue::EventEnum[:pv_changed]) # value changed or unit changed
    is_fixed = self.fixed?
    source_section_name = param_value_event.source_section_name
    part_triggered = ['center_part','left_part','right_part'].include? source_section_name
    page_triggered = ['root'].include? source_section_name
    # width of one in these three changed.       
    if self.section_perma_name=='center_area'
      left_part = self.children.select{|s| s.section_perma_name=='left_part'}.first
      right_part = self.children.select{|s| s.section_perma_name=='right_part'}.first
      center_part = self.children.select{|s| s.section_perma_name=='center_part'}.first
Rails.logger.debug "left_part=#{left_part}, right_part=#{right_part}, center_part=#{center_part}"        
      if part_triggered
        if false #is_fixed, enable fixed center_area later. 
          center_part_width = center_part.html_attribute_values( 'block_width' )
          if source_section_name == 'left_part'
            center_part_width['pvalue']+= param_value_event.difference

          elsif  source_section_name == 'right_part'
            
          else
            
          end
        else          
          left_part_block_width =  left_part.html_attribute_values( 'block_width' )            
          left_part_block_margin = left_part.html_attribute_values( 'block_margin' )
          right_part_block_width = right_part.html_attribute_values( 'block_width' )
          right_part_block_margin = right_part.html_attribute_values( 'block_margin' )
          center_part_inner_margin = center_part.html_attribute_values( 'inner_margin' )
          if source_section_name == 'left_part'
            center_part_inner_margin['pvalue3']+= param_value_event.difference
            left_part_block_margin['pvalue1'] = -left_part_block_width['pvalue'] #margin-right = -left_part.width
          elsif  source_section_name == 'right_part'
            center_part_inner_margin['pvalue1']+= param_value_event.difference   
            right_part_block_margin['pvalue3'] = -right_part_block_width['pvalue'] #margin-left = -right_part.width                 
          end
          self.updated_html_attribute_values.push(center_part_inner_margin, left_part_block_margin, right_part_block_margin)
        end
        
      end                   
    end    
  end
       
# here are two tipical layouts,    
#   Layout Example                                 fluid --> fixed                         fixed --> fluid
#   layout_root1 
#         +----center_area
#         |       +-------center_part
#         |       |-------header_part
#         |       |-------left_part
#         |       +-------right_part    
#         |----footer   
#  
#   layout_root2 
#         +--page
#         |    +----center_area
#         |    |       +-------center_part
#         |    |       |-------header_part
#         |    |       |-------left_part
#         |    |       +-------right_part    
#         |    +----footer   
#         +--dialog
#         +--message_box

# rules to change layout from fixed to fluid
#  1. it only works for container section.
#  2. it only works while there are all container section in same level(exclude float section, ex. dialog).
#  ex. in layout1. center_area and footer are same level,  center_part, header_part, left_part and right_part are same level 
#  container and content layout is not horizontal, width-> unset
#  root is also a container
# rules to change layout from fluid to fixed             
  
  def page_layout_fixed_event_handler( global_param_value_event )
    is_fixed = global_param_value_event.new_html_attribute_value.pvalue
    parent_block_width =  self.parent_section_instance.html_attribute_values("block_width") unless self.parent.nil?    
    block_width = html_attribute_values("block_width")
    block_margin =  html_attribute_values("block_margin")
    block_inner_margin = html_attribute_values("inner_margin")
Rails.logger.debug "is_fixed = #{is_fixed}, handle section=#{self.section.perma_name}"    

    if is_fixed
      to_fixed()
    else
      to_fluid()
    end
  end

  # a container, content layout attribute of parent is vertical, and have a width value, we could say to_fluid means unset the width. 
  def to_fluid()
    if self.root?
      block_min_width = html_attribute_values("page_min-width")
      block_width = html_attribute_values("page_width")
      block_margin =  html_attribute_values("page_margin")
      #block, inner
      
        block_width['unset']  = HtmlAttribute::UNSET_TRUE
        block_width['hidden']  = HtmlAttribute::BOOL_TRUE
        block_min_width['unset']  = HtmlAttribute::UNSET_FALSE
        block_min_width['hidden']  = HtmlAttribute::BOOL_FALSE
      self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
    elsif self.section.perma_name=='container'
  
    elsif self.section.perma_name=='center_area'
      # parent_width is unset
  
        
    end    
  end
  
# a container, if have no width value, content layout attribute of ancestors are vertical, to_fixed means change nothing. 
#              if have width value and bigger than available width, we could say to_fixed means unset the width. 
  def to_fixed()
    if self.root?
      block_min_width = html_attribute_values("page_min-width")
      block_width = html_attribute_values("page_width")
      block_margin =  html_attribute_values("page_margin")
      #block, inner
        block_width['unset']  = HtmlAttribute::UNSET_FALSE
        block_width['hidden']  = HtmlAttribute::BOOL_FALSE
        block_min_width['unset']  = HtmlAttribute::UNSET_TRUE
        block_min_width['hidden']  = HtmlAttribute::BOOL_TRUE
        block_margin['unset'] = HtmlAttribute::UNSET_FALSE
        block_margin['psvalue'] = 'auto'  
      
      self.updated_html_attribute_values.push(block_width,block_min_width,block_margin )
    elsif self.section.perma_name=='container'
  
    elsif self.section.perma_name=='center_area'
      # parent_width is unset
    end
  end

    
  def height_pv_changed_handler(param_value_event)
    param_value = param_value_event.param_value
    html_attribute = param_value_event.html_attribute      
    height = self.html_attribute_values('block_height')
  Rails.logger.debug "param_value_event=#{param_value_event.event}"    
    if height.manual_entry?
      margin, border, padding  = self.html_attribute_values('inner_margin'),
        self.html_attribute_values('inner_border-width'),
        self.html_attribute_values('inner_padding')
      computed_inner_height = self.html_attribute_values('inner_height')
      inner_height_value = height['pvalue0'].to_i
      [0,2].each{|i|#0:top, 2: bottom
        inner_height_value-= margin["pvalue#{i}"]  if margin.manual_entry?(i)  
        inner_height_value-= border["pvalue#{i}"]  if border.manual_entry?(i)  
        inner_height_value-= padding["pvalue#{i}"] if padding.manual_entry?(i)  
          } 
  Rails.logger.debug "height=#{height['pvalue0']}, inner_height_value=#{inner_height_value}"           
      computed_inner_height['psvalue'] = height['psvalue']
      computed_inner_height['pvalue'] = inner_height_value
      computed_inner_height['unit'] = height['unit']
      computed_inner_height['unset'] = HtmlAttribute::UNSET_FALSE
      self.updated_html_attribute_values.push(computed_inner_height)
    end
  end
  # TODO width_pv_changed_handler, should not bigger than its parent's width.
  
  def margin_pv_changed_handler
    height_pv_changed_handler
    
  end 
  def padding_pv_changed_handler
    height_pv_changed_handler
    
  end 
  
  # return: 0(self is fluid) or >0(real width) 
  def width    
    # it is root and fluid 
    return 0 if self.root? and !html_attribute_values("page_layout_fixed").bool_true?
    # it is root and fixed
    return html_attribute_values("page_width")['pvalue'] if self.root? 

    # self width unset, parent content layout is vertical.
    if self.html_attribute_values("block_width").unset? and self.parent.content_layout_vertical?
      #TODO consider the computed margin, computed_padding caused by 'border image'
      margin, border, padding = html_attribute_values("inner_margin"), html_attribute_values("inner_border-width"), html_attribute_values("inner_padding")
      computed_width = self.parent_width      
      computed_width -= (margin['pvalue1']+margin['pvalue3']) unless margin.unset? 
      computed_width -= (border['pvalue1']+border['pvalue3']) unless border.unset? 
      computed_width -= (padding['pvalue1']+padding['pvalue3']) unless padding.unset? 
        
      return computed_width  
    end
        
    return self.html_attribute_values("block_width")['pvalue'].to_i    
  end
  
  def parent_width
    self.parent.width
  end
  
  def save
    updated_html_attribute_values.each{|hav|  hav.update  }
    # update param_value.pvalue
    updated_html_attribute_values.collect{|hav| hav.param_value}.uniq.each{|pv| pv.save}
    # save param_value.pvalue  
    updated_html_attribute_values.pop(updated_html_attribute_values.length)    
  end

  def fixed?
    #decide by width and parent's content_layout_horizontal
    # width=unset && parent's content_layout_horizontal = true   or  width=100% or fixed=true(only for root)  
    self.width>0
  end

  
  def root?
    self.page_layout.root?
  end
  
  def container?
    # has html_attribute_value: content_layout_horizontal
    ! html_attribute_values("content_layout_horizontal").nil?
  end
  
  def content_layout_vertical?
    not html_attribute_values("content_layout_horizontal").bool_true?
  end
  
  def section_perma_name
    self.section.perma_name
  end  
end