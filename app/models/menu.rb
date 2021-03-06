class Menu < ActiveRecord::Base
  extend FriendlyId
  acts_as_nested_set

  has_one :menu_level, :primary_key=>"root_id", :foreign_key=>"menu_id", :conditions=>proc{"menu_levels.level=#{self.level} and #{!self.root.inheritance}"}
  
  has_many :assignments
  has_many :blog_posts,:through =>:assignments
  belongs_to :website
  
  after_save  :store_root_id
  friendly_id :title, :use => :scoped, :scope => :website
    
  # assigned themes within website's menu 
  def self.assigned_theme_ids()
    roots = Menu.roots
    theme_ids = []
    for menu in roots
      if menu.inheritance         
        menu.self_and_descendants.each{|item| theme_ids.push( item.theme_id, item.detail_theme_id)}          
      else
        menu_levels = MenuLevel.all(:conditions=>["root_id=?",menu.id])
        menu_levels.each{|ml| theme_ids.push( ml.theme_id, ml.detail_theme_id)}
      end
    end
Rails.logger.debug   "assigned_theme_ids-> theme_ids=#{theme_ids.inspect}"  
    theme_ids.uniq!; theme_ids.sort!
    theme_ids.shift if theme_ids.first == 0 # may contain 0
    theme_ids
  end

  #we need valid 
  def store_root_id
    if self.root_id.nil?
      if self.parent_id.nil?
        self.root_id=self.id
      else
        self.root_id = self.root.id
      end
      self.save!
    end    
  end
  
  def find_theme_id(is_preview = false, is_detail = false)
    the_theme_id = 0
    col = "theme_id"
    col= "detail_"+col if is_detail
    col= "p"+col if is_preview
    if self.root.inheritance
      items = find_self_and_ancestors(self.root.self_and_descendants)
#Rails.logger.debug "items = #{items.inspect}"      
      for item in items
        the_theme_id = item[col] if item[col]>0
      end
    else  
      the_theme_id = self.menu_level[col]
    end    
    
    # this menu have no assigned theme, get theme from website default.
    if the_theme_id==0
      col = is_detail ? "detail_template" : "list_template"
      col = "p"+col if is_preview
      the_theme_id= Website.current[col]
    end
    the_theme_id
  end
  
  # usege: if current is not root, find themes used by current menu item, 
  # else find default used themes by whole tree 
  # return: [theme_for_list, theme_for_detail] 
  
  def assigned_theme_ids(is_preview = false)
    if @theme_ids.nil?
      @theme_ids = []
      @theme_ids << find_theme_id(is_preview)
      @theme_ids << find_theme_id(is_preview, is_detail = true)
    end
    @theme_ids
  end
  
  # for each menu item, it has assigned preview template_theme.
  def previewable?
    if self.root.assigned_theme_ids.include?(0)
      return !self.assigned_theme_ids.include?(0)
    else
      return true  
    end
  end
  
  def find_self_and_ancestors(whole_tree)
    nodes = whole_tree.select{|node| node.lft<= self.lft and node.rgt>=self.rgt }
  end
  
  def path
    "/#{self.id}"
  end
  
end
