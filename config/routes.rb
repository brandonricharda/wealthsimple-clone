Rails.application.routes.draw do
    devise_for :users, controllers: { :registrations => "registrations", :sessions => "sessions" }
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root "pages#home"
    resources :users, only: [:show, :create, :new]
    resources :accounts, only: [:show, :create, :new]
    resources :transactions, only: [:create, :new]
end
