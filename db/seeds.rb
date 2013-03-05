# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
###################################################################################################################################################################################################################################################################################################################################################################################
#  
# rake RAILS_ENV=test db:seed

# plese load section_pieces first, seed sections.rb need it.
require 'active_record/fixtures'
ActiveRecord::Fixtures.create_fixtures("#{Rails.root}/test/fixtures", "section_pieces")   

SectionParam.delete_all
ParamValue.delete_all

SEED_DEFAULT_TABLES =  ["html_attributes", "editors"]

for t in SEED_DEFAULT_TABLES
  t.classify.constantize.delete_all
end

#suffix number of seeds file name indicate loading order. 
xpath = File.dirname(__FILE__)+ "/seeds/*.rb"
Dir[xpath].sort.each {|file| 
  puts "loading #{file}"
  load file
}

###################################################################################################################################################################################################################################################################################################################################################################################   
# load sample resources
xpath = File.dirname(__FILE__)+ "/seeds/sample_resources/*.rb"
Dir[xpath].sort.each {|file| 
  puts "loading #{file}"
  load file
}


###################################################################################################################################################################################################################################################################################################################################################################################   
# Section

puts "loading complete!"
