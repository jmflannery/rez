Rez::Engine.routes.draw do
  resources :profiles, only: [:create, :index, :show, :update, :destroy]
  resources :addresses, only: [:create, :index, :show, :update, :destroy]
  resources :resumes, only: [:create, :index, :show, :update, :destroy]
  resources :items, only: [:create, :index, :show, :update, :destroy]
  resources :paragraphs, only: [:create, :index, :show, :update, :destroy]
end
