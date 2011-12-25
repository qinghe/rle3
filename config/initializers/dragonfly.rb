require 'dragonfly/rails/images'

Dragonfly[:images].configure do |c|

# override default
# c.datastore.root_path = ::Rails.root.join('public/system/dragonfly', ::Rails.env).to_s  
  c.datastore.root_path = ::Rails.root.join('public','shops', ::Rails.env).to_s
  
end