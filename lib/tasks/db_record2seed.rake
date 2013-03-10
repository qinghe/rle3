namespace :db do
  desc "reload section_piece.yml"
  task :reload_section_piece => :environment do
    require 'active_record/fixtures'
    ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "section_pieces") 
  end
    
  desc "export table record from database to seed file, specify talbe with TABLE=x"
  task :record2seed => :environment do
    reject_attribute_names = ['updated_at','created_at']
    table_name = ENV["TABLE"] ? ENV["TABLE"] : nil    
    raise "TABLE is required" unless table_name
    file_path = "#{RAILS_ROOT}/db/#{table_name}.rb"      
    open(file_path, "w") do |f|
              res =table_name.classify.constantize.all
              f.puts 'objs=['
              record_count = 0
              for row in res
                f.print ",\n" if record_count>0
                f.print "  "+ row.attributes.delete_if {|key, value| reject_attribute_names.include? key }.inspect
                record_count+=1
              end
              f.puts ']'
              f.puts "
#{table_name.classify}.delete_all              
for ha in objs
  obj = #{table_name.classify}.new
  obj.send(:attributes=, ha, false)
  obj.save
end
                "
    end
  end
  
  desc "export theme to seed file, specify theme with THEME=x"
  task :export_theme => :environment do
    #Rake::Task['morning:make_coffee'].invoke
    reject_attribute_names = ['updated_at','created_at']
    theme_id = ENV["THEME"] ? ENV["THEME"] : nil    
    raise "THEME is required" unless theme_id
    #make dir db/seed/theme#{id}    
    dir_path = File.join( RAILS_ROOT,"db","seeds","theme#{theme_id}")
    FileUtils.mkdir(dir_path) unless File.exists?(dir_path)
    themes = TemplateTheme.find(:all, :conditions=>["id=?", theme_id])
    theme = themes.first
    if theme
      #export theme
      file_path =  File.join(dir_path, "themes.rb")
      export_data(file_path, themes, reject_attribute_names)

      #export page_layout
      layouts = PageLayout.find(:all, :conditions=>["root_id=?", theme.layout_id])
      file_path =  File.join(dir_path, "layouts.rb")
      export_data(file_path, layouts, reject_attribute_names)
      #export param_value
      file_path =  File.join(dir_path, "param_values.rb")
      param_values = ParamValue.all(:conditions=>["theme_id=?", theme.id])
      export_data(file_path, param_values, reject_attribute_names)
    end  
  end
  
  desc "load theme seeds to database, specify theme with THEME=x"
  task :load_theme => :environment do
    #Rake::Task['morning:make_coffee'].invoke
    reject_attribute_names = ['updated_at','created_at']
    theme_id = ENV["THEME"] ? ENV["THEME"] : nil    
    raise "THEME is required" unless theme_id
    #make dir db/seed/theme#{id}    
    dir_path = File.join( RAILS_ROOT,"db","seeds","theme#{theme_id}")
    
    xpath = File.join(dir_path, "*.rb")
    Dir[xpath].each {|file| 
      puts "loading #{file}"
      load file
    }
  end 
  
  def export_data(file_path, records, reject_attribute_names)
    open(file_path, "w") do |f|
      f.puts 'objs=['
      record_count = 0
      for row in records
        f.print ",\n" if record_count>0
        f.print "  "+ row.attributes.except(*reject_attribute_names).inspect
        record_count+=1
      end
      f.puts ']'
      f.puts "object_class = #{records.first.class.name}"
      f.puts %q!
for ha in objs
  obj = object_class.new()
  obj.send(:attributes=, ha, false)
  quoted_values = obj.class.column_names.collect{|col| obj.class.connection.quote(ha[col], col) }
  sql = "INSERT INTO #{obj.class.quoted_table_name} " +
          "(#{obj.class.column_names.join(', ')}) " +
          "VALUES(#{quoted_values.join(', ')})" 
  obj.connection.execute(sql)
end
             !
    end
  end
  
end
