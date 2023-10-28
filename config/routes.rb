Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'fetch_datas#index'
  resources :fetch_datas do
    post :upload_data, on: :collection
  end
end
