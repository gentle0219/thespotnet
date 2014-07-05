class Admin::WorkOrdersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    @work_orders = current_user.work_orders.paginate(page: params[:page], :per_page => 10)
  end

  def new
    @work_order = WorkOrder.new
  end

  def create
    @work_order = current_user.work_orders.build(params[:work_order].permit(:location, :category, :level, :title, :details));
    respond_to do |format|
      if @work_order.save
        format.html { redirect_to action: :index}
        format.json { render json: @work_order, status: :created, location: @work_order}
        flash[:notice] = 'New Work Order was created successfully'
      else
        format.html { render action: :new }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
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
