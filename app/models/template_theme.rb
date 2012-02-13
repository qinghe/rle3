class TemplateTheme < ActiveRecord::Base
  belongs_to :website
  belongs_to :page_layout, :foreign_key=>"layout_id", :dependent=>:destroy
  has_many :param_values, :foreign_key=>"theme_id"#  :dependent=>:destroy, do not use dependent, it cause load each one of param_value
  
  after_destroy :remove_relative_data
  
  def file_name(usage)
    "#{layout_id}_#{id}.#{usage}"
  end

  # Usage: user want to copy this layout&theme to new for editing or backup.
  #        we need copy param_value and theme_images
  #        note that it is only for root. 
  def copy_to_new()

    layout = self.page_layout    
    #copy new whole tree
    new_layout = layout.copy_to_new
    #create theme record
    new_theme = self.clone
    new_theme.perma_name = 'copy_'+self.perma_name
    new_theme.layout_id = new_layout.id
    new_theme.save!
    
    #copy param values
    #INSERT INTO tbl_temp2 (fld_id)    SELECT tbl_temp1.fld_order_id    FROM tbl_temp1 WHERE tbl_temp1.fld_order_id > 100;
    table_name = "param_values"
    
    table_column_names = ParamValue.column_names
    table_column_names.delete('id')
    
    table_column_values  = table_column_names.dup
    table_column_values[table_column_values.index('root_layout_id')] = new_layout.id
    table_column_values[table_column_values.index('theme_id')] = new_theme.id
    
    #copy param value from origin to new.
    sql = %Q!INSERT INTO #{table_name}(#{table_column_names.join(',')}) SELECT #{table_column_values.join(',')} FROM #{table_name} WHERE ((root_layout_id =#{layout.id}) and (theme_id =#{self.id}))! 
    self.class.connection.execute(sql)
    #update layout_id to new_layout.id    
    for layout in new_layout.descendants
      ParamValue.update_all(["layout_id=?", layout.id],["root_layout_id=? and section_id=? and section_instance=?",layout.root_id, layout.section_id, layout.section_instance])
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
end
