Rails.application.routes.draw do
  #I hate these and want to write them out by hand
  resources :organizations, only: [ :index, :create, :update, :destroy ]

  get "/employees", to: "employees#index"
  post "/employees", to: "employees#new"
  post "/employees/login", to: "employees#create"
  put "/employees/:id", to: "employees#update"
  delete "/employees/:id", to: "employees#delete"

  resources :alerts
end
