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
  resources :group_members, only: [:show, :update, :destroy]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
