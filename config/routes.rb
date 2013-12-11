Rez::Engine.routes.draw do
  resources :profiles, only: [:create, :index, :show, :update, :destroy]
  resources :addresses, only: [:create, :index, :show, :update, :destroy]
end
