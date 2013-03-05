class Assignment < ActiveRecord::Base
  acts_as_list :scope => [:website_id,:name]
  belongs_to :blog_post
end
