class Admin::WorkOrdersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    level = params[:level].present? ? params[:level] : "0"
    case level
    when "0"
      @work_orders = WorkOrder.all.paginate(page: params[:page], per_page: 15)
    when "1"
      @work_orders = WorkOrder.where(opend:true).paginate(page: params[:page], per_page: 15)
    when "2"
      @work_orders = WorkOrder.where(opend:false).paginate(page: params[:page], per_page: 15)
    when "3"      
      @work_orders = WorkOrder.where(lebel:"high").paginate(page: params[:page], per_page: 15)
    end

    # if current_user.is_admin?
    #   @work_orders = WorkOrder.all.paginate(page: params[:page], per_page: 15)
    # else
    #   @work_orders = current_user.work_orders.paginate(page: params[:page], :per_page => 10)
    # end    
  end

  def new
    @work_order = WorkOrder.new
  end

  def create
    @work_order = current_user.work_orders.build(params[:work_order].permit(:property, :category, :level, :title, :details, :maintenance))
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
    @work_order = WorkOrder.find(params[:id])
  end
  def update
    @work_order = WorkOrder.find(params[:id])
    @work_order.assign_attributes(params[:work_order].permit(:property, :category, :level, :title, :details, :maintenance))
    respond_to do |format|
      if @work_order.save
        format.html { redirect_to action: :index}
        format.json { render json: @work_order, status: :created, location: @work_order}
        flash[:notice] = 'New Work Order was updated successfully'
      else
        format.html { render action: :update }
        format.json { render json: @work_order.errors, status: :unprocessable_entity }
      end      
    end
  end
  
  def destroy
    @work_order = WorkOrder.find(params[:id])
    if @work_order.destroy
      redirect_to action: :index
      flash[:notice] = 'WorkOrder was deleted'
    end
  end  
end
