Rails.application.routes.draw do
  resources :groups do
    resources :group_members, only: [:index, :new]
    member do
      get :settings
    end
  end
  resources :contents, only: :index
  resources :users, only: [:edit, :update] do
    member do
      get :edit_avatar
    end
  end
  resources :group_members, only: [:show]
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
