Rez::Engine.routes.draw do
  resources :addresses, only: [:create, :index, :show, :update, :destroy]
  resources :resumes, only: [:create, :index, :show, :update, :destroy] do
    resource :profile, only: [:show]
    resources :items, only: [:index]
  end
  resources :profiles, only: [:create, :index, :show, :update, :destroy]
  resources :items, only: [:create, :index, :show, :update, :destroy]
  resources :points, only: [:create, :index, :show, :update, :destroy]
end
