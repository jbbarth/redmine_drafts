ActionController::Routing::Routes.draw do |map|
  map.resources :drafts, :only => [:create]
end
