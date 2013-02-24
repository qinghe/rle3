#it is a theme of page_layout
class TemplateTheme < ActiveRecord::Base
  belongs_to :website
  belongs_to :page_layout, :foreign_key=>"page_layout_root_id", :dependent=>:destroy
  has_many :param_values, :foreign_key=>"theme_id"#  :dependent=>:destroy, do not use dependent, it cause load each one of param_value
  
  after_destroy :remove_relative_data
  scope :by_layout,  lambda { |layout_id| where(:page_layout_root_id => layout_id) }
  
  
  begin 'for page generator'  
    def file_name(usage)
      "#{layout_id}_#{id}.#{usage}"
    end
  end
  # Usage: user want to copy this layout&theme to new for editing or backup.
  #        we need copy param_value and theme_images
  #        note that it is only for root. 
  def copy_to_new()

    original_layout = self.page_layout    
    #copy new whole tree
    new_layout = original_layout.copy_to_new
    #create theme record
    new_theme = self.dup
    new_theme.perma_name = 'copy_'+self.perma_name
    new_theme.layout_id = new_layout.id
    new_theme.save!
    
    #copy param values
    #INSERT INTO tbl_temp2 (fld_id)    SELECT tbl_temp1.fld_order_id    FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
    table_name = ParamValue.table_name
    
    table_column_names = ParamValue.column_names
    table_column_names.delete('id')
    
    table_column_values  = table_column_names.dup
    table_column_values[table_column_values.index('layout_root_id')] = new_layout.id
    table_column_values[table_column_values.index('theme_id')] = new_theme.id
    
    #copy param value from origin to new.
    sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE  (theme_id =#{self.id})! 
    self.class.connection.execute(sql)
    #update layout_id to new_layout.id    
    for node in new_layout.self_and_descendants
      original_node = original_layout.self_and_descendants.select{|item| (item.section_id == node.section_id) and (item.section_instance==node.section_instance) }.first
      ParamValue.update_all(["page_layout_id=?", node.id],["theme_id=? and page_layout_id=?",new_theme.id, original_node.id])
    end
    return new_theme
  end
  
  
  def export_to_seed
    
  end
  
  def remove_relative_data
    ParamValue.delete_all(["theme_id=?", self.id])
  end
  
  # all menus used by this theme, from param values which pclass='db'
  # param_value.pvalue should be menu root id
  # return menu roots
  def assigned_menus
    pvs = self.param_values.all(:conditions=>["section_piece_params.pclass=?","db"],:include=>[:section_param=>:section_piece_param])
    pvs.collect{|pv| mid = pv.first_pvalue.to_i; mid>0 ? Menu.find(mid) : nil }.compact
  end
  
  begin 'param values'  
      # param values of self.
    def full_param_values(editor_id=0)
      if editor_id>0
      ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
       :conditions=>["theme_id=? and section_piece_params.editor_id=?", self.id, theme_id, editor_id],
       :order=>"section_piece_params.editor_id, param_categories.position")
        
      else
      ParamValue.find(:all, :include=>[:section_param=>[:section_piece_param=>:param_category]], 
       :conditions=>["theme_id=?", self.id, theme_id],
       :order=>"section_piece_params.editor_id, param_categories.position")
          
      end
    end
  
  end
  
end
