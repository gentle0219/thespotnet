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
end
