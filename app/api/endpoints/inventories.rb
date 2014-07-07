module Endpoints
  class Inventories < Grape::API

    resource :inventories do
      get do

      end
      
      get do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          inventories = 
          if work_order.save
            {success: "Created new work order"}
          else
            {failed: work_order.errors.messages.to_json}
          end        
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

    end    
  end
end