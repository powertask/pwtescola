Rails.application.routes.draw do
  resources :histories
  resources :contracts
  resources :tickets
  resources :debtors
  resources :customers
  resources :units
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :home do
    collection do
      get 'filter_name' => 'home#filter_name'
      get :get_tasks
      get :get_click
    end
  end

  get 'list_customers' => 'customers#list_customers'
  get 'define_customer' => 'customers#define_customer'

  get 'home/:cod/show' => 'home#show', as: :show
  get 'home/:cod/deal' => 'home#deal', as: :deal
  get 'home/:cod/get_cna' => 'home#get_cna', as: :get_cna
  patch 'home/:cod/pay_cna' => 'home#pay_cna', as: :pay_cna
  patch 'home/:cod/set_cna' => 'home#set_cna', as: :set_cna
  get 'home/:cod/get_tickets' => 'home#get_tickets', as: :get_tickets
  get 'home/:cod/set_tickets' => 'home#set_tickets', as: :set_tickets


  root 'home#index'

end
