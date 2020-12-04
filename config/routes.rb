Rails.application.routes.draw do
  root 'homes#top'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update]
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  get "home/about" => "homes#about"

  # フォロー機能の
  resources :relationships, only: [:create, :destroy]
end