class Admin::WorkOrdersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin
  def index
    @work_orders = current_user.work_orders
  end

  def new
  end
  def create
  end

  def edit
  end
  def update
  end
  
  def destroy
  end  
end
