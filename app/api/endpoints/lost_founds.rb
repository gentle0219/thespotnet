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
          lost_found = LostFound.new(item_name:params[:item_name], description:params[:description], user_id:user.id)
          if lost_found.save
            {success: {id:lost_found.id.to_s, item_name:lost_found.item_name, description:lost_found.description}}
          else
            {failed: "Please check again"}
          end
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end

      desc "Get LostFound item list"
      get do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          lost_founds = user.lost_founds
          {success: lost_founds.map{|lf| {id:lf.id.to_s, item_name:lf.item_name,description:lf.description}}}          
        else
          {failed: 'Cannot find this token, please login again'}
        end
      end
    end #// resouce
  end
end
