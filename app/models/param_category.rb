class ParamCategory < ActiveRecord::Base
  belongs_to :editor
  acts_as_list :scope => :editor
  
  has_many :param_values
end
