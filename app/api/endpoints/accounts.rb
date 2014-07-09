module Endpoints
  class Accounts < Grape::API

    resource :accounts do
      # Forgot Password
      # GET: /api/v1/accounts/forgot_password
      # parameters:
      #   email:      String *required
      # results: 
      #   success string
      get :forgot_password do
        user = User.where(email:params[:email]).first
        if user.present?
          UserMailer.forgot_password(user).deliver
          {success: 'Email was sent successfully'}
        else
          {:failed => 'Cannot find your email'}
        end
      end

      desc "Get last cleaner from property"
      get :last_cleaner do
        user = User.find_by_token(params[:auth_token])
        if user.present?
          property = Property.find(params[:property_id])
          cleaner = property.last_cleaner
          if cleaner.present?
            {success: {id:cleaner.id.to_s, phone:cleaner.phone,email:cleaner.email}}
          else
            {failed: 'Cannot find cleaner.'}
          end  
        else
          {failed: 'Cannot find this token, please login again.'}
        end
      end
    end
    
  end
end