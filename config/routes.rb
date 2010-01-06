ActionController::Routing::Routes.draw do |map|
  map.resources :drafts, :only => [:create, :destroy],
                         :member => {:restore => :put}
end
