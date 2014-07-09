module Endpoints
  class LostFounds < Grape::API

    resource :lost_founds do
      
      get :ping do
        {success:'lost_founds test'}
      end

      desc "Create lost or found item"
      post do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          if params[:item_id].present?
            found = LostFound.find(params[:item_id])
            found.assign_attributes(item_name:params[:item_name], description:params[:description], user_id:user.id, property_id:params[:property_id])
          else
            found = LostFound.new(item_name:params[:item_name], description:params[:description], user_id:user.id, property_id:params[:property_id])
          end
          found.lost = false          
          if found.save
            {success: "Sent this item to property manager"}
          else
            {failed: found.errors.messages.to_json}
          end
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Get LostFound item list"
      get do
        user = User.find_by_token(params[:auth_token])
        property = Property.find(params[:property_id])
        if user.present?
          lost_founds = property.lost_founds.lost_items
          {success: lost_founds.map{|lf| {id:lf.id.to_s, item_name:lf.item_name,description:lf.description}}}
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end
    end #// resouce
  end
end
