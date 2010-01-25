ActionController::Routing::Routes.draw do |map|
  map.resources :drafts, :only => [:create, :destroy],
                         :collection => {:autosave => :post},
                         :member => {:restore => :put}
end
