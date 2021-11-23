# frozen_string_literal: true

Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'sessions/new'

  get '/help',      to: 'static_pages#help'
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  put '/tts',       to: 'users#tts'

  resources :dictionaries do
    collection do
      post 'export_multiple'
    end
    post 'export', on: :member
    resources :entries do
      member do
        post 'finalize'
        post 'play'
        get 'play'
      end
    end
  end
  resources :sampas
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'dictionaries#index'
end
