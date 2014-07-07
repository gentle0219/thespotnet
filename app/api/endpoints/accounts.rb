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
    end
    
  end
end