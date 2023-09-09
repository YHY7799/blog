Rails.application.routes.draw do
   devise_for :users
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'     
 end
 scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
 # Your existing routes go here
  end
  resources :posts
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
