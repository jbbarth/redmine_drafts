RedmineApp::Application.routes.draw do
  resources :drafts, :only => [:create, :destroy] do
    collection { put :autosave }
    member { put :restore }
  end
end
