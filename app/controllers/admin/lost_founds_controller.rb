class Admin::LostFoundsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    @lost_founds = LostFound.all.paginate(page: params[:page], :per_page => 10)
  end

  def new
    @lost_found = LostFound.new    
  end
  def create
    @lost_found = current_user.lost_founds.build(params[:lost_found].permit(:property, :item_name, :description))
    respond_to do |format|
      if @lost_found.save
        format.html { redirect_to action: :index}
        format.json { render json: @lost_found, status: :created, location: @lost_found}
        flash[:notice] = 'New Lost Item was created successfully'
      else
        format.html { render action: :new }
        format.json { render json: @lost_found.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @lost_found = LostFound.find(params[:id])
  end
  def update
    @lost_found = LostFound.find(params[:id])
    @lost_found.assign_attributes(params[:lost_found].permit(:property, :item_name, :description))
    respond_to do |format|
      if @lost_found.save
        format.html { redirect_to action: :index}
        format.json { render json: @lost_found, status: :created, location: @lost_found}
        flash[:notice] = 'New Work Order was updated successfully'
      else
        format.html { render action: :edit }
        format.json { render json: @lost_found.errors, status: :unprocessable_entity }
      end      
    end
  end

  def show
    @lost_found = LostFound.find(params[:id])
  end

end