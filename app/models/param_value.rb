class ParamValue < ActiveRecord::Base
  EventEnum={:psv_changed=>'psv_changed',:pv_changed=>'pv_changed',:psu_changed=>'psu_changed',:unset_changed=>'unset_changed'}
  belongs_to :section_param
  belongs_to :page_layout, :foreign_key=>"layout_id"
  belongs_to :section
  
  serialize :pvalue, Hash
  after_save :trigger_events

  scope :within_section, lambda { |param_value|
{ :conditions=>["layout_id=? and theme_id=? and param_values.section_id=? and param_values.section_instance=?", param_value.layout_id, param_value.theme_id, param_value.section_id, param_value.section_instance],
  :include=>['section_param'=>'section_piece_param']}      
     }

  #usage:  
  #        return hash, values are all param_values within same section piece, 
  #        keys are class_name,  format is {:class_name1=>pv1,:class_name2=>pv2  ...}
  def self.find_within_section_piece(param_value)
    section_param = param_value.section_param
    
    pvs = self.find(:all, :conditions=>["layout_id=? and param_values.section_id=? and section_instance=? and section_params.section_piece_id=? and section_params.section_piece_instance=?",
      param_value.layout_id, param_value.section_id, param_value.section_instance, section_param.section_piece_id, section_param.section_piece_instance], 
    :include=>[{:section_param=>:section_piece_param}, :page_layout])
    name_pv_hash = pvs.inject({}){|h, pv| h[pv.section_param.section_piece_param.class_name] = pv; h;}

  end
  
  # usage: return all html_attribute_values this param value contains. 
  #   return a hash, values are instance of HtmlAttributeValue, keys are html_attribute_id and html_attribute.perma_name. 
  #   key is section_param.section_piece_param.class_name+html_attribute.perma_name. ex."block_width"
  #   unique_key = hav.computed? ?  "computed_#{class_name}_#{hav.html_attribute.perma_name}" : "#{class_name}_#{hav.html_attribute.perma_name}"

  def html_attribute_values_hash
    ha_array = HtmlAttribute.find_by_ids(self.html_attribute_ids)
    
    hav_hash = ha_array.inject({}){|h, ha| hav = HtmlAttributeValue.parse_from(self,ha); 
      h[ha.id]=hav;
      unique_key = "#{hav.param_value.section_param.section_piece_param.class_name}_#{hav.html_attribute.perma_name}"
      h[unique_key]=hav; h 
    }

    hav_hash
  end
  

  # usage: update attribute:pvalue 
  # params: html_attribute_id_value_map, 
  #  it is hash like {html_attribute_id=>{pvalue, unit,psvalue}}
  def update_html_attribute_value(html_attribute, html_attribute_value_params, some_event = nil)
    # it maybe called more times by conditions, we should keep updated_html_attribute_values
    @updated_html_attribute_values ||= []
    original_html_attribute_value = HtmlAttributeValue.parse_from(self,html_attribute)
    new_html_attribute_value = HtmlAttributeValue.parse_from(self, html_attribute, html_attribute_value_params)
    is_updated= false
    Rails.logger.debug "original_html_attribute_value=#{original_html_attribute_value.properties.inspect},new_html_attribute_value=#{new_html_attribute_value.properties.inspect}"    
    unless original_html_attribute_value.equal_to?(new_html_attribute_value)
      # changed by user actions, some_event = [pv_changed|psv_changed|psu_changed|unset_changed]
      if some_event 
        if some_event==EventEnum[:unset_changed]
          if new_html_attribute_value.unset?
            self.html_attribute_extra(html_attribute.id, 'unset', new_html_attribute_value.unset)     
          else # user modify unset, we should give a default value. 
            self.html_attribute_extra(html_attribute.id, 'unset', new_html_attribute_value.unset)   
Rails.logger.debug "pvalue=#{new_html_attribute_value.build_pvalue(default=true)}"              
            self.set_pvalue_for_haid(html_attribute.id, new_html_attribute_value.build_pvalue(default=true))            
          end
        else
          self.set_pvalue_for_haid(html_attribute.id, new_html_attribute_value.build_pvalue)
        end 
      else
        if new_html_attribute_value.hidden != original_html_attribute_value.hidden
          self.html_attribute_extra(html_attribute.id, 'hidden', new_html_attribute_value.hidden)
        end     
        if new_html_attribute_value.unset != original_html_attribute_value.unset
          self.html_attribute_extra(html_attribute.id, 'unset', new_html_attribute_value.hidden)
        end
        if new_html_attribute_value.computed != original_html_attribute_value.computed
          self.html_attribute_extra(html_attribute.id, 'computed', new_html_attribute_value.hidden)
        end
        self.set_pvalue_for_haid(html_attribute.id, new_html_attribute_value.build_pvalue)        
      end
      @updated_html_attribute_values << new_html_attribute_value
      is_updated = true  
    end
    [is_updated, new_html_attribute_value, original_html_attribute_value]
  end
  
  #Usage:  user modify param_value, trigger event, event in EventEnum
  # flow chart is:
  #            client side               server side
  #  user modify param_value ->       raise_event -> if(change_event) modify pvalue(not save) -> 
  #                                   accumulate modification event, include global_param_value_event and section_event -> 
  #                                   after pv.save -> call trigger_event
  # 
  def raise_event(some_event, event_params)
    @param_value_events||=[]
    @global_param_value_events||=[]
    if some_event=~/changed/
      html_attribute =  event_params[:html_attribute ]
      html_attribute_value_params= event_params[:html_attribute_value_params]
      is_updated, new_html_attribute_value, original_html_attribute_value = update_html_attribute_value(html_attribute, html_attribute_value_params, some_event)
      if is_updated
        if some_event!=EventEnum[:psv_changed]
          pve = ParamValueEvent.new(some_event, self, html_attribute, nil, nil )
          @param_value_events<<pve
        end    
        # tell current section, this is new html attribute value. 
        #Rails.logger.debug "self.section=#{section.inspect}"        
        se = GlobalParamValueEvent.new(some_event, self, html_attribute,nil, new_html_attribute_value )
        if self.page_layout.subscribe_event?(se)
          @global_param_value_events << se
        end
      end
    end
  end
  
  # Usage: it is called after save, to trigger accumulated events.
  # we also collect all updated_html_attribute_values which caused by GlobalParamValueEvent or ParamValueEvent events.
  def trigger_events
Rails.logger.debug "trigger_events:#{@param_value_events.inspect}, section_events=#{@global_param_value_events.inspect}"
    #@param_value_events may be nil, ex. load seed.   
    unless @param_value_events.nil?
      param_value_events = @param_value_events
      @param_value_events = nil # in case update self.pvalue, trigger again.
      param_value_events.each{|pve| 
        @updated_html_attribute_values.concat( pve.notify )
      }
    end 
    unless @global_param_value_events.nil?
      section_events = @global_param_value_events
      @global_param_value_events = nil # in case update self.pvalue, trigger again.
      section_events.each{|pve| 
        @updated_html_attribute_values.concat(pve.notify)      
      }
    end 
  end
  
  def updated_html_attribute_values
    @updated_html_attribute_values
  end
  
  def html_attribute_ids()
    if @html_attribute_ids.nil?
      section_piece_param = self.section_param.section_piece_param
      @html_attribute_ids = section_piece_param.html_attribute_ids.split(',').collect{|i|i.to_i}
    end
    @html_attribute_ids
  end
  
  def html_attribute_value(html_attribute)
    return HtmlAttributeValue.parse_from(self,html_attribute)
  end
  
  #belongs_to_html_attribute_ids could be Array or an html_attribute_id
  def attribute_values(belongs_to_html_attribute_ids)
    belongs_to_html_attribute_ids ||= self.html_attribute_ids        
    return self.pvalue.slice(*belongs_to_html_attribute_ids).values if belongs_to_html_attribute_ids.kind_of?(Array)    
    self.pvalue.slice(belongs_to_html_attribute_ids).values
  end
  
  def pvalue_for_haid(html_attribute_id)    
    self.pvalue[html_attribute_id] 
  end
  def set_pvalue_for_haid(html_attribute_id, value_for_ha)    
    self.pvalue[html_attribute_id]  = value_for_ha
  end
  def set_unset_for_haid(html_attribute_id, unset_for_ha)
    self.pvalue["#{html_attribute_id}unset"] = unset_for_ha
  end
  
  
  def unset?(html_attribute_id)
    ( self.html_attribute_extra(html_attribute_id, 'unset')== HtmlAttribute::UNSET_FALSE) ? false : true    
  end
     
  # use in layout_generator
  def hidden?(html_attribute_id)
    # all computed are hidden
    ( self.html_attribute_extra(html_attribute_id,'hidden')== HtmlAttribute::BOOL_TRUE or computed?) ?  true : false  
  end
  
  def computed?(html_attribute_id)
    ( self.html_attribute_extra(html_attribute_id,'computed')== HtmlAttribute::BOOL_TRUE) ?  true : false  
  end
  
  def html_attribute_extra(html_attribute_id, attr_name, attr_val = nil )
    if attr_val.nil?
      self.pvalue["#{html_attribute_id}#{attr_name}"]
    else
      self.pvalue["#{html_attribute_id}#{attr_name}"] = attr_val
    end
    
  end
  

  def disabled_html_attribute_ids
    if @disabled_html_attribute_ids.nil?
      @disabled_html_attribute_ids = self.disabled_ha_ids.split(',').collect{|i|i.to_i}
    end
    @disabled_html_attribute_ids
  end  
  
end



