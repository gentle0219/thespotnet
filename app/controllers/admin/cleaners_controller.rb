class Admin::CleanersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    @properties = current_user.properties
  end

  def new
  end

  def edit
  end

  def cleaners_list
    @properties = current_user.properties.paginate(page: params[:page], :per_page => 15)
  end
  def update_cleaners
    params[:cleaners].each do |key, val|
      assign = Assign.where(property_id:key).first
      if assign.present?
        assign.update_attribute(:member_id, val)
      else
        Assign.create(property_id:key, member_id:val)
      end      
    end
    redirect_to action: :cleaners_list
    flash[:notice] = "Assigned cleaners"
  end

  def time_clocks
    @properties = current_user.properties.paginate(page: params[:page], :per_page => 15)
  end

  def management
    
  end
end
