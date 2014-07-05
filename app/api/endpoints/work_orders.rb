module Endpoints
  class WorkOrders < Grape::API

    resource :work_orders do
      
      get :ping do
        { :success => 'work order test' }
      end

      desc "Create new work order"
      post do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          work_order = WorkOrders.new(location:params[:location], category:params[:category], property:params[:property], title:params[:title], details:params[:details])
          if work_order.save
            {success: "Created new work order"}
          else
            {faild: work_order.errors.messages.to_json}
          end        
        else
          {faild: 'Cannot find this token, please login again'}
        end
      end


    end

  end
end
