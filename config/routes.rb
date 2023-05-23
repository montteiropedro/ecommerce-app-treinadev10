Rails.application.routes.draw do
  root "warehouses#index"
  resources :warehouses, only: [:show]
end
