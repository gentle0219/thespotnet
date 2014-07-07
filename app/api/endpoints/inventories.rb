module Endpoints
  class Inventories < Grape::API

    resource :inventories do
      
      get do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          inventories = Inventory.itv_list.map{|iv| {name:iv, quantity:Inventory.count(iv)}}
          {success: inventories}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      post :send_request do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          request = InventoryRequest.new(user_id:user.id, ivt_id:params[:ivt_id], quantity:params[:quantity], sent_date:Time.now)
          if request.save
            {success: "Created new request"}
          else
            {failed: request.errors.messages.to_json}
          end          
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

    end    
  end
end