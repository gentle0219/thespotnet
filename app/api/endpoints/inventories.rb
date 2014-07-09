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
          requests = user.manager.inventory_requests
          { success: requests.map{|rq| {id:rq.id.to_s, ivt_id:rq.ivt_id, quantity:rq.quantity, accepted:rq.accepted}} }
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Send inventory request"
      post :requests do        
        user = User.find_by_token(params[:auth_token])
        if user.present? 
          requests = params[:requests].split(";")
          requests.each do |request|
            item = request.split(",")
            r = InventoryRequest.new(user_id:user.id, ivt_id:item[0], location:item[1], property_id:item[2], quantity:item[3], sent_date:Time.now)
            r.save
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

      post :accept do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          request_ids = params[:request_ids].split(",")
          requests = InventoryRequest.in(id:request_ids)
          requests.each do |r|
            r.update_attributes(accepted:true, accept_date:Time.now)
          end
          {success: "Accepted requests"}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end
    end    
  end
end
