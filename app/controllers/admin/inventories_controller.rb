class Admin::InventoriesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    @inventories = current_user.is_admin? ? Inventory.all : current_user.inventories
    if params[:search].present?
      @inventories = @inventories.search(params[:search]) #.paginate(page: params[:page], :per_page => 10)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
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
    @inventory = Inventory.find(params[:id])
  end
  def update
    @inventory = Inventory.find(params[:id])
  end
  
  def destroy
    @inventory = Inventory.find(params[:id])
  end  
end
