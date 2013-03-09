# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  attr_accessor :shop,:website
  before_filter :init_shop
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def model_dialog(dialog_title, dialog_content)
    @dialog_title = dialog_title
    @content_string = render_to_string :partial => dialog_content
    respond_to do |format|
        format.js{ render "base/model_dialog"}
    end
  end
  
  def render_message(message)
    respond_to do |format|
        format.js{ render "base/message_box", :locals=>{:message=>message}}
    end
      
  end
  
  def init_shop
    #self.shop = Shop.first
    self.website = Website.first
    Website.current = self.website    
  end
  
end
