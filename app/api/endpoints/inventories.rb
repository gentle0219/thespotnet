module Endpoints
  class Inventories < Grape::API

    resource :inventories do
      
      desc "Inventory list"
      get do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          inventories = Inventory.itv_list.map{|iv| {name:iv, quantity:Inventory.count(iv)}}
          {success: inventories}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Inventory request list"
      get :requests do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          requests = user.inventory_requests
          { success: requests.map{|rq| {id:rq.id.to_s, ivt_id:rq.ivt_id, quantity:rq.quantity, state:rq.state}} }
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Send inventory request"
      post :requests do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          params[:requests].each do |request|
            request = InventoryRequest.new(user_id:user.id, ivt_id:request[:ivt_id], quantity:request[:quantity], location:request[:location], property_id:request[:property_id], sent_date:Time.now)
            request.save
          end
          {success: "Created new request"}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Get Property location list"
      get :locations do
        user = User.find_by_token(params[:auth_token])        
        if user.present?
          manager = user.manager
          locations = manager.present? ? manager.property_locations : []
          { success: locations.map{|loc| {id:loc.id.to_s, propert_id:loc.property.id.to_s, location:loc.location}} }
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

    end    
  end
end