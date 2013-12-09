Rez::Engine.routes.draw do
  resources :profiles, only: [:create, :index, :show, :update, :destroy]
end
