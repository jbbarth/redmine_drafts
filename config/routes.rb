RedmineApp::Application.routes.draw do
  resources :drafts, :only => [:create, :destroy] do
    collection { post :autosave }
    member { put :restore }
  end
end