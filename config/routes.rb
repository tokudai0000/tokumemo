Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create]
    collection do
      get 'rank'
      get 'undergraduate'
      get 'course'
    end
  end
  
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :index]
  
  root 'hello#index'
end
