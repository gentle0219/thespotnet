class HomeController < ApplicationController
  
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def index
  end

  def create_session
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    
    email    = params[:email]
    password = params[:password]
    dev_id   = params[:dev_id]

    resource = User.find_for_database_authentication( :email => email )
    if resource.nil?
      render :json => {failed:'No Such User'}, :status => 401
    else      
      if resource.valid_password?( password )
        device = resource.devices.where( dev_id:dev_id ).first        
        device = resource.devices.create(dev_id:dev_id) if device.blank?        
        user = sign_in( :user, resource )
        user_info={id:resource.id.to_s, name:resource.name,email:resource.email,auth_token:resource.authentication_token, role:resource.role}
        render :json => {:success => user_info}
        else
          render :json => {failed: params[:password]}, :status => 401
        end
      end
   end

   def delete_session
    if params[:email].present?
        resource = User.find_for_database_authentication(:email => params[:email])
    elsif params[:user_id].present?
      resource = User.find(params[:user_id])
    end
    
    if resource.nil?
      render :json => {failed:'No Such User'}, :status => 401
    else
      sign_out(resource)
      render :json => {:success => 'sign out'}
    end
  end
  
end
