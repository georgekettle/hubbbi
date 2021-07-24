Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users/invitations' }
  resources :groups do
    resources :group_members, only: [:index, :new, :create]
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
  resources :group_members, only: [:show, :update, :destroy] do
    resources :links, only: [:new, :create], module: "group_members"
  end
  resources :links, only: [:edit, :update, :destroy]
  resources :courses, only: [:show]
  # root directs to groups#index if logged in:
  root to: "groups#index", constraints: -> (r) { r.env["warden"].authenticate? }, as: :authenticated_root
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
