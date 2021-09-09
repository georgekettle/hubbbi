Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions" }

  resources :groups do
    resources :group_members, only: [:index]
    resources :courses, only: [:new, :create]
    resources :invites, only: [:new, :create], module: "groups"
    member do
      get :settings
    end
  end

  resources :pages, only: [:edit, :update, :show, :destroy] do
    resources :sections, only: :create
    member do
      get :edit_sections
      get :settings
    end
  end

  resources :sections, only: [:destroy, :update] do
    resources :pages, only: [:new, :create], controller: 'sections/pages'
    resources :images, only: [:new, :create], controller: 'sections/images'
    resources :videos, only: [:new, :create], controller: 'sections/videos'
    resources :links, only: [:new, :create], controller: 'sections/links'
    resources :pdfs, only: [:new, :create], controller: 'sections/pdfs'
    resources :section_elements, only: :index
  end

  resources :section_elements, only: :update
  resources :texts, only: :update
  resources :images, only: [:destroy, :edit, :update]
  resources :videos, only: [:edit, :update]
  resources :links, only: [:edit, :update, :destroy]
  resources :pdfs, only: [:destroy, :edit, :update]

  resources :group_members, only: [:show, :edit, :update, :destroy] do
    resources :links, only: [:new, :create], module: "group_members"
    resources :course_members, only: [:new, :create], module: "group_members"
    member do
      get :edit_avatar
    end
  end

  resources :courses, only: [:show, :edit, :update, :destroy] do
    resources :course_members, only: [:index, :new, :create]
    member do
      get :settings
    end
  end

  resources :course_members, only: [:destroy]
  resources :attachments, only: :destroy
  # root directs to groups#index if logged in:
  root to: "groups#index", constraints: -> (r) { r.env["warden"].authenticate? }, as: :authenticated_root
  root to: 'home#home'

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
