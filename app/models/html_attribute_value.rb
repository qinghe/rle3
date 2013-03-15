class HtmlAttributeValue 
  attr_accessor :html_attribute, :param_value
  attr_accessor :properties #hash {pvalue0, psvalue0, unit0, psvalue0_desc, unset, computed}
  
  
  # create an instance from a string it is param_value.pvalue[html_attribute_id]
  # create an instance from hash {pvalue0, psvalue0, unit0}  
  # params: computed, html_attribute_id is in section_piece_param.computed_ha_ids.
  def self.parse_from(param_value, html_attribute, pvalue_properties={}, computed = false)
    
    if pvalue_properties.empty?
      #pvalue_string could be nil,  in this case, get default_pvalue_string?
      pvalue_properties = do_parse(param_value, html_attribute)      
    else
      # build htmlAttributeValue instane from postd params, we need check "unset" param, set to false if it is nil.
      # tidy posted pvalue_properties, only keep valid values.
      html_attribute.repeats.times{|i|
        psvalue = pvalue_properties["psvalue#{i}"]
        if html_attribute.manual_entry?( psvalue )
          pvalue_properties.except!(["pvalue#{i}","unit#{i}"])          
        end
      }
      # if unset is uncheck, 'unset' is nil in posted params.
      if pvalue_properties["unset"].nil?
        pvalue_properties["unset"] = HtmlAttribute::BOOL_FALSE
      end
    end
    
    # default unset is checked
    if pvalue_properties["unset"].nil?
      pvalue_properties["unset"] = HtmlAttribute::BOOL_TRUE
    end
    if pvalue_properties["hidden"].nil?
      pvalue_properties["hidden"] = HtmlAttribute::BOOL_FALSE
    end
    # is computed value store in param_value.pvalue, true or false, 
    if pvalue_properties["computed"].nil?
      pvalue_properties["computed"] = HtmlAttribute::BOOL_FALSE
    end
        
    return ultra_initialize(param_value, html_attribute, pvalue_properties)
  end

  #every html_attribute_value, should have defalut value, or pvalue is nil after unset
  def self.do_parse(param_value, html_attribute)
    #use html attribute value in param_value.pvalue      
    pvalue_string = param_value.pvalue_for_haid(html_attribute.id)
    pvalue_unset = param_value.html_attribute_extra(html_attribute.id,'unset')   
    pvalue_hidden = param_value.html_attribute_extra(html_attribute.id,'hidden')   
    pvalue_computed = param_value.html_attribute_extra(html_attribute.id,'computed')   
    
    object_properties = {"unset"=>pvalue_unset, "hidden"=>pvalue_hidden, "computed"=>pvalue_computed}
    param_value_class = param_value.section_param.section_piece_param.pclass
      if html_attribute.is_special? :text
        object_properties["psvalue0"] = html_attribute.possible_selected_values.first
        object_properties["pvalue0"] =  pvalue_string
      elsif html_attribute.is_special? :bool
        object_properties["psvalue0"] = html_attribute.possible_selected_values.first
        object_properties["pvalue0"] =  pvalue_string      
      elsif html_attribute.is_special? :db
        object_properties["psvalue0"] = html_attribute.possible_selected_values.first
        object_properties["pvalue0"] = pvalue_string.to_i
      else # css and pvalue_string
        if pvalue_string.present?  
Rails.logger.debug "pvalue_string=#{pvalue_string}"
          html_attribute_slug, vals = pvalue_string.split(':')
          # 'width:'.split(':') -> ['width'], in this case vals is nil, 
          # it happened while user select a manul entry and have not enter anything. we should show the empty entry.
          repeats = html_attribute.repeats
          val_arr = vals.nil? ? [] : vals.split()
          repeats.times{|i|
            val = val_arr[i]
            if html_attribute.selected_value?(val)
              object_properties["psvalue#{i}"] = val
            else# it is manual entry.
              object_properties["psvalue#{i}"] = html_attribute.manual_selected_value
              if html_attribute.has_unit?
                object_properties["pvalue#{i}"],object_properties["unit#{i}"] =  val[/^\d+/].to_i,val[/[a-z%]+$/]
              else
                object_properties["pvalue#{i}"] = val
              end
            end
          }
          
        elsif html_attribute.has_default_value?
          object_properties.merge!( html_attribute.default_properties )
        end
      end
#Rails.logger.debug "param_value:#{param_value.id}, html_attribute=#{html_attribute.slug},pvalue_string=#{pvalue_string.inspect}, pclass=#{param_value_class},properties=#{object_properties.inspect}"
    object_properties
  end
  
  def self.build_pvalue_from_properties(param_value, html_attribute, pvalue_properties)
    #use overrided value in pvalue_properties
    pvalue_string = nil
    if html_attribute.is_special? :text
      pvalue_string = pvalue_properties["pvalue0"]
    elsif html_attribute.is_special? :bool
      pvalue_string = pvalue_properties["pvalue0"]
    elsif html_attribute.is_special? :db
      pvalue_string = pvalue_properties["pvalue0"]
    else      
      vals = html_attribute.repeats.times.collect{|i|
        html_attribute.manual_entry?(pvalue_properties["psvalue#{i}"]) ? 
          "#{pvalue_properties["pvalue#{i}"]}#{pvalue_properties["unit#{i}"]}" : pvalue_properties["psvalue#{i}"]
      }
      pvalue_string = html_attribute.slug+':'+ vals.join(' ')
    end
    pvalue_string
  end
  

  def self.ultra_initialize(param_value, html_attribute, properties)
    hav = HtmlAttributeValue.new
    hav.html_attribute = html_attribute
    hav.param_value = param_value
    hav.properties = properties    
    hav
  end
  

  # param: properties to string  {'pvalue0'=>'90','unit0'=>'px'} -> 'wdith:90px'
  def build_pvalue(default=false)
    
    return default ? self.class.build_pvalue_from_properties(param_value, html_attribute, html_attribute.default_properties) :
      self.class.build_pvalue_from_properties(param_value, html_attribute, properties)
  end
  
  def equal_to?(another_instance)
    return ((self.html_attribute.id==another_instance.html_attribute.id) and 
    (self.hidden? == another_instance.hidden?) and 
    ((self.unset? and another_instance.unset?) or 
     ((self.unset? == another_instance.unset?) and (self.build_pvalue ==another_instance.build_pvalue) ))) 
  end

  # get pvalue, psvalue, unit, unset  
  # if the reperts==1  key are pvalue, psvalue, unit,unset
  # if the reperts>1   hav[pvalue{n}],hav[psvalue{n}], hav[unit{n}]   ,n start from 0  
  def [](key)
    
    #return properties[key] if key=~/unset/
    # pvalue and pvalue0 both return pvalue0
    key=~/[\d]$/ ? properties[key] : properties[key+'0'] 
           
  end
  
  # set pvalue, psvalue, unit, unset  
  # if the reperts==1  key are pvalue, psvalue, unit,unset
  # if the reperts>1   key are pvalue{n}, psvalue{n}, n start from 0  
  def []=(key,val)
    #unset or bool like this way
    if val.kind_of?(TrueClass) or val.kind_of?(FalseClass)
      val = val ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
    end  
    if key=~/unset/
      properties[key] = val
      #it has default value at least while initialize!
    elsif key=~/hidden/
      properties[key] = val
    elsif key=~/[\d]$/
      properties[key] = val
    else
      self.html_attribute.repeats.times{|i|
        properties[key+i.to_s] = val
      }  
    end
    if key=~/pvalue/ # in code we could set 'width=200'
      # correct psvalue and unit
      if self.unset?
        properties['unset'] = HtmlAttribute::BOOL_FALSE
      end
      unless self.html_attribute.manual_entry? self['psvalue']
        self['psvalue'] =  self.html_attribute.manual_selected_value
        if self.html_attribute.has_unit?
          self['unit'] =  self.html_attribute.units.first
        end
      end
    end
  end
  
  # return pvalue with right type, db:int, bool:bool, text:string
  def pvalue( irepeat = 0)
    casted_value = properties["pvalue#{irepeat}"] 
    if html_attribute.is_special? :bool
      casted_value = casted_value.to_i > 0    
    elsif html_attribute.is_special? :db
      casted_value = casted_value.to_i
    end
    casted_value
  end
  
  def unset
    return unset? ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
  end
  
  def unset?
    return properties["unset"]!=HtmlAttribute::BOOL_FALSE
  end

  def hidden
    return hidden? ? HtmlAttribute::BOOL_TRUE : HtmlAttribute::BOOL_FALSE
  end  
  
  def hidden?
    return properties["hidden"]==HtmlAttribute::BOOL_TRUE
  end
  
  def bool_true?
    self.properties['pvalue']==HtmlAttribute::BOOL_TRUE ?  true:false    
  end
  
  def manual_entry?(irepeat=0)
    html_attribute.manual_entry?(properties["psvalue#{irepeat}"])
  end
  
  def computed
    return properties["computed"]
  end
  
  def computed?
    return properties["computed"]==HtmlAttribute::BOOL_TRUE
  end
  
  begin 'css selector, name, value'
    def css_selector
      if self.param_value.section_param.section_piece_param.class_name=~/(block)/
        ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_id}"
      else  
        ".s_#{self.param_value.page_layout_id}_#{self.param_value.section_param.section_id} .#{self.param_value.section_param.section_piece_param.class_name}"
      end
    end
    
    def attribute_name
      self.html_attribute.slug
    end
    def attribute_value
        vals = html_attribute.repeats.times.collect{|i|
          html_attribute.manual_entry?(properties["psvalue#{i}"]) ? 
            "#{properties["pvalue#{i}"]}#{properties["unit#{i}"]}" : properties["psvalue#{i}"]
        }.join(' ')
    end
  end
  
  # update param_value with self 
  def update()
    Rails.logger.debug "yes, in HtmlAttributeValue.save"
    self.param_value.update_html_attribute_value(self.html_attribute, self.properties, 'system')
  end
  


  # possible selected values are website related, ex. menus.  
=begin  
  def possible_selected_values
    if @possible_selected_values.nil?      
      if html_attribute.is_special? :db        
        @possible_selected_values = html_attribute.possible_selected_values
      else
        @possible_selected_values = html_attribute.possible_selected_values
      end
    end
    @possible_selected_values
  end
  def possible_selected_values_descriptions
    if @possible_selected_values_descriptions.nil?      
      if html_attribute.is_special? :db      
        @possible_selected_values_descriptions = html_attribute.possible_selected_values_descriptions        
        #@possible_selected_values_descriptions+=(Menu.roots.collect{|menu| menu.title})
      else
        @possible_selected_values_descriptions = html_attribute.possible_selected_values_descriptions
      end
    end
    @possible_selected_values_descriptions
  end    
=end
end
