module PageTag
  class ParamValues
    attr_accessor :template_tag
    def initialize( template_tag )
      self.template_tag = template_tag
    end
    
    def param_values_hash
      if @param_values_hash.nil?
        param_values =  ParamValue.find(:all,:conditions=>["theme_id=?", self.template_tag.id],
          :include=>[:section_param=>:section_piece_param], :order=>'param_values.page_layout_id,section_piece_params.class_name '
        )
        
        @param_values_hash = param_values.inject({}){|h,pv|
          sp = pv.section_param
          key =  "#{pv.page_layout_id}_#{sp.section_id}" #keep it same as WrappedPageLayout.to_key
          h[key]||=[]   
          h[key]<<pv
          h
        }      
      end
      @param_values_hash
    end
  
    #usage
    # key, template_tag.current_piece.to_key, look for css in current section piece
    # options: :source=>[computed|normal], get pvalue from 'pvalue' or 'computed_pvalue'  
    def css( class_name, options={})
      class_name = class_name.to_s
      key = self.template_tag.current_piece.to_key
      val = ""
      if self.param_values_hash.key? key
        pvs = param_values_hash[key]
        for pv in pvs
  #Rails.logger.debug "pv=#{pv.id}, pv.html_attribute_ids=#{pv.html_attribute_ids}"
          # section_piece_param which have same class_name should be given same plass
          spp = pv.section_param.section_piece_param
          if spp.class_name == class_name
            if options[:source]=='computed' #computed param value must be css 
              val<< pv.computed_pvalue.values.join(';')                           
            else
              html_attributes = HtmlAttribute.find_by_ids(pv.html_attribute_ids)
              for ha in  html_attributes
                if ha.is_special?(:image) or ha.is_special?(:src)
                  hav= pv.html_attribute_value(ha)
                  file_name = hav['pvalue0']
                  if file_name
                    if spp.pclass==SectionPieceParam::PCLASS_STYLE
                      # replace ':' with '='
                      val << %Q!#{ha.slug}="#{build_path(file_name)}"!
                    else
                      val << "#{ha.slug}:url(#{build_path(file_name)});"
                    end
                  end
                else
                  unset = pv.unset?(ha.id)
                  # should output hidden pv
                  # hidden= pv.hidden?(ha.id)
                  pv_for_ha = pv.pvalue_for_haid(ha.id)
                  if !unset 
                    if spp.pclass==SectionPieceParam::PCLASS_STYLE
                      ha_slug, ha_value = pv_for_ha.split(':')
                      val << %Q!#{ha_slug}="#{ha_value}"!
                    else
                      val <<  ( pv_for_ha+';' )                    
                    end
                  end                
                end
                
              end
      
            end
          end
        end
      end
#   Rails.logger.debug    " class_name=#{class_name}, val=#{val}"
      val
    end
        
    # parent section_piece
    def root_piece_instance_id
      if self.section and self.section_piece
        root_piece = Section.find(section_piece['root_id'])
  #      Rails.logger.debug "root_piece=#{root_piece.inspect}"
        "#{section['section_id']}_#{section['section_instance']}_#{root_piece['section_piece_id']}_#{root_piece['section_piece_instance']}" #section_piece_instance always 1.  
      end
    end    
    
    def build_path(file_name)
      "/shops/#{::Rails.env}/#{1}/template_files/#{file_name}"
      
    end
    
  end
end