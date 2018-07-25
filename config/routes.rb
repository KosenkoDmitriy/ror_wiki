Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'stories#index'
  get "ajax_all_stories" => "stories#ajax", as: :ajax_all_stories

  resources :topics do
    resources :stories
    namespace :unconfirmed do
      resources :stories
    end
  end

end
