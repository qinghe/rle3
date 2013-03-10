Rle3::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :template_files
  resources :menus do
    collection do
        get 'assign_template'
        post 'assign_template'
    end  
  end
  resources :param_values
  resources :section_params
  resources :section_piece_params
  resources :sections
  resources :param_categories
  resources :section_pieces
  resources :blog_posts do
      collection do
        get 'assign'
        post 'assign'
      end    
  end

  resources :assignments

  resources :template_themes do
       member do
         get :editor
         get :edit_layout # modify page_layout
         post :get_param_values # to support post data>1024byte
         post :copy
         post :update_param_value
         post :update_layout_tree
         get :build
         get :generate_assets
       end
  
       collection do
         get :preview # add function preview_template_themes_path
         get 'publish'
         get 'upload_file_dialog'
         post :assign
       end
  end
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  match '(/:c(/:r))' => 'template_themes#preview', :c => /[\d]+/
  match 'preview(/:c(/:r))' => 'template_themes#preview' #preview home
  
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to=>"template_themes#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'
end
