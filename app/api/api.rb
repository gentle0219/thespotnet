class API < Grape::API
  prefix 'api'
  version 'v1'
  format :json
  
  helpers do
    def warden
      env['warden']
    end

    def current_user
      warden.user || @user
    end

    def authenticate!
      error!('401 Unauthorized', 401) unless current_user
    end
  end
  # load remaining API endpoints

  mount Endpoints::Accounts
  mount Endpoints::Events
  mount Endpoints::WorkOrders
  mount Endpoints::Inventories
  mount Endpoints::Spots
  mount Endpoints::LostFounds
end
