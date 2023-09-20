Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  devise_scope :user do  
    get '/users/sign_out' => 'devise/sessions#destroy'   
    get '/cookies_info', to: 'some_action#index'  
 end
 scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
 # Your existing routes go here
  resources :posts
  root 'home#index'
 end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
