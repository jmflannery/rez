Rez::Engine.routes.draw do
  resources :resumes, only: [:create, :index, :show, :update, :destroy] do
    resource :profile, only: [:show]
    resource :address, only: [:show]
    resources :items, only: [:index]
  end
  resources :profiles, only: [:create, :index, :show, :update, :destroy]
  resources :addresses, only: [:create, :index, :show, :update, :destroy]
  resources :items, only: [:create, :index, :show, :update, :destroy] do
    resources :points, only: [:index]
  end
  resources :points, only: [:create, :index, :show, :update, :destroy]
end
