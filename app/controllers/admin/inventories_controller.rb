class Admin::InventoriesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    @inventories = current_user.inventories.paginate(page: params[:page], :per_page => 15)
  end

  def new
    @inventory = Inventory.new
  end

  def create
    purchase_date = params[:inventory][:purchase_date]
    if purchase_date.present? 
      dt = DateTime.strptime(purchase_date, "%m/%d/%Y")
      params[:inventory][:purchase_date] = dt.strftime("%Y-%m-%d")
    end
    @inventory = current_user.inventories.build(params[:inventory].permit(:ivt_id, :name, :re_order_point, :quantity, :purchase_date, :location, :cost, :price_type, :notes));
    respond_to do |format|
      if @inventory.save
        format.html { redirect_to action: :index}
        format.json { render json: @inventory, status: :created, location: @inventory}
        flash[:notice] = 'New Inventory was created successfully'
      else
        format.html { render action: :new }
        format.json { render json: @inventory.errors, status: :unprocessable_entity }
      end      
    end
  end

  def edit
  end
  def update
  end
  
  def destroy
  end  
end
