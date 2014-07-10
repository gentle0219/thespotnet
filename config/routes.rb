TheSpotNet::Application.routes.draw do	
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'

    resources :users
    resources :properties
    resources :work_orders
    resources :inventories
    resources :lost_founds
    
    resources :messages do
      collection do
        get 'inbox'
      end
    end

    #resources :cleaners
    get 'cleaners_list'                   => 'cleaners#cleaners_list'
    delete 'cleaner/:id'                      => 'cleaners#delete_cleaner', as: 'delete_cleaner'

    post 'update_cleaners'                => 'cleaners#update_cleaners'
    get 'time_clocks'                     => 'cleaners#time_clocks'
    get 'management'                      => 'cleaners#management'    
  end
  
  mount API => '/'

  devise_for :users, controllers: {sessions: "sessions"}
  root :to => 'home#index'
  
  post 'api/v1/accounts/sign_in'        => 'home#create_session'
  post 'api/v1/accounts/sign_out'       => 'home#delete_session'
  
end
