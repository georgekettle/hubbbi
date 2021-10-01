Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "registrations",
    sessions: "sessions",
    passwords: "passwords" }

  resources :groups do
    resources :group_members, only: [:index]
    resources :courses, only: [:new, :create]
    resources :invites, only: [:new, :create], module: "groups"
    member do
      get :settings
    end
  end

  resources :invites, only: [:destroy]

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
    resources :audios, only: [:new, :create], controller: 'sections/audios'
    resources :section_elements, only: :index
  end

  resources :section_elements, only: :update
  resources :texts, only: :update
  resources :images, only: [:destroy, :edit, :update]
  resources :videos, only: [:edit, :update]
  resources :links, only: [:edit, :update, :destroy]
  resources :pdfs, only: [:destroy, :edit, :update]
  resources :audios, only: [:destroy, :edit, :update] do
    resources :media_plays, only: [:create], controller: 'audios/media_plays' do
      collection do
        post :add_to_queue
      end
    end
  end
  resources :media_plays, only: [:update, :destroy] do
    member do
      patch :skip_queue
      put :skip_queue
      patch :reorder
      put :reorder
    end
    collection do
      get :fetch_media_player
    end
  end

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
