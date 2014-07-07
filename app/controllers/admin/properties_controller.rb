class Admin::PropertiesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    # if params[:search].present?
    #   @properties = Property.search(params[:search]).paginate(page: params[:page], :per_page => 10)
    # else
    #   @properties = Property.all.paginate(page: params[:page], :per_page => 10)  
    # end

    @properties = current_user.is_admin? ? Property.all : current_user.properties
    if params[:search].present?
      @properties = @properties.search(params[:search]).paginate(page: params[:page], :per_page => 10)
    else
      @properties = @properties.paginate(page: params[:page], :per_page => 10)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @properties }
    end
  end

  def new
    @property = Property.new    
  end

  def create
    @owner = Owner.new(create_owner_params)
    @owner.save
    
    @property = current_user.properties.build(create_propery_params)
    @property.owner = @owner
    respond_to do |format|
      if @property.save
        format.html { redirect_to action: :index}
        format.json { render json: @property, status: :created, location: @property}
        flash[:notice] = 'New Property was created successfully'
      else
        format.html { render action: :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @property = Property.find(params[:id])
    @owner = @property.owner
  end
  def update
    @property = Property.find(params[:id])
    @owner = @property.owner
    @owner.update_attributes(create_owner_params)    
    respond_to do |format|
      if @property.update_attributes(create_propery_params)
        format.html { redirect_to action: :index}
        format.json { render json: @property, status: :created, location: @property}
        flash[:notice] = 'Property was updated successfully'
      else
        format.html { render action: :new }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end      
    end
  end

  def destroy
    @property = Property.find(params[:id])
    if @property.destroy
      redirect_to action: :index
      flash[:notice] = 'Property was deleted'
    end
  end

  private
  def create_propery_params
    params.require(:property).permit(:name, :pt_id, :address1, :address2, :city, :state, :zip_code, :phone, :geo_location_id, :bedrooms, :full_bathrooms, :half_bathrooms, :notes)
  end

  def create_owner_params
    params.require(:owner).permit(:name, :pt_id, :address1, :address2, :city, :state, :zip_code, :phone, :phone2)
  end
end
