Rails.application.routes.draw do

  resources :contracts
  resources :proposals
  resources :proposal_tickets
  resources :tickets
  resources :debtors
  resources :customers
  resources :units
  resources :bank_slips
  resources :students
  resources :courses
  resources :remittances
  resources :discharges

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

  get 'home/:cod/get_tickets_simul' => 'home#get_tickets_simul', as: :get_tickets_simul
  get 'home/:cod/set_tickets_simul' => 'home#set_tickets_simul', as: :set_tickets_simul
  
  get 'home/:cod/get_charge_ticket' => 'home#get_charge_ticket', as: :get_charge_ticket
  patch 'home/:cod/set_charge_ticket' => 'home#set_charge_ticket', as: :set_charge_ticket

  post 'proposal/:cod/create_proposal' => 'proposals#create_proposal', as: :create_proposal
  post 'proposal/:cod/cancel_proposal' => 'proposals#cancel_proposal', as: :cancel_proposal

  get 'bank_slip/:cod/create_new_due_at' => 'bank_slips#create_new_due_at', as: :create_new_due_at
  get 'bank_slip/:cod/bank_slip_cancel' => 'bank_slips#bank_slip_cancel', as: :bank_slip_cancel

  get 'history/:debtor_id/new_history' => 'histories#new_history', as: :new_history
  post 'history/:debtor_id/create_history' => 'histories#create_history', as: :create_history

  get 'contract/:contract/delete_contract' => 'contracts#delete_contract', as: :delete_contract
  get 'contract/:cod/contract_pdf' => 'contracts#contract_pdf', as: :contract_pdf
  get 'contract/:cod/contract_transaction_pdf' => 'contracts#contract_transaction_pdf', as: :contract_transaction_pdf
  get 'contract/:cod/create_bank_billet' => 'contracts#create_bank_billet', as: :create_bank_billet
  post 'contract/:cod/create_contract_from_proposal' => 'contracts#create_contract_from_proposal', as: :create_contract_from_proposal
  post 'contract/:cod/create_contract' => 'contracts#create_contract', as: :create_contract

  post 'remittance/remittance_create' => 'remittances#remittance_create', as: :remittance_create
  get 'remittance/remittance_new' => 'remittances#remittance_new', as: :remittance_new
  get 'remittance/:cod/remittance_download' => 'remittances#remittance_download', as: :remittance_download
  get 'discharge/sent_discharge' => 'discharges#sent_discharge', as: :sent_discharge
  post 'discharge/create_discharge' => 'discharges#create_discharge', as: :create_discharge


  root 'home#index'

end
