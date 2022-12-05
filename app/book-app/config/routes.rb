Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get '/healthz', to: 'health#index'

  resources :books, only: [:index, :show] do
    member do
      post :test_book_job
    end
  end
  resources :jobs, only: [:create]

  # Defines the root path route ("/")
  # root "articles#index"
end
