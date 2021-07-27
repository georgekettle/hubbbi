Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users/invitations' }

  resources :groups do
    resources :group_members, only: [:index, :new, :create]
    resources :courses, only: [:new, :create]
    member do
      get :settings
    end
  end

  resources :pages, only: [:edit, :update, :show]
  resources :sections, only: [] do
    resources :pages, only: [:new, :create], controller: 'sections/pages'
  end

  resources :users, only: [:edit, :update] do
    member do
      get :edit_avatar
    end
  end

  resources :group_members, only: [:show, :update, :destroy] do
    resources :links, only: [:new, :create], module: "group_members"
  end

  resources :links, only: [:edit, :update, :destroy]

  resources :courses, only: [:show, :edit, :update, :destroy] do
    resources :course_members, only: [:index, :new, :create]
    member do
      get :settings
    end
  end

  resources :course_members, only: [:destroy]

  # root directs to groups#index if logged in:
  root to: "groups#index", constraints: -> (r) { r.env["warden"].authenticate? }, as: :authenticated_root
  root to: 'home#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
