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
    @assign = Assign.new(property_id:params[:cleaners][:property], member_id:params[:cleaners][:cleaner])
    respond_to do |format|
      if @assign.save
        format.html { redirect_to action: :cleaners_list }        
        format.json { render json: @assign, status: :created, location: @assign }
        flash[:notice] = "Assigned cleaners"
      else
        format.html { render action: :cleaners_list }
        format.json { render json: @assign.errors, status: :unprocessable_entity }
      end
    end 
    
  end

  def delete_cleaner
    assign = Assign.find(params[:id])
    assign.destroy
    redirect_to action: :cleaners_list
  end

  def time_clocks
    @properties = current_user.properties.paginate(page: params[:page], :per_page => 15)
  end

  def management
    
  end
end
