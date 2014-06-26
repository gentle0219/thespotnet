class Admin::UsersController < ApplicationController
  layout 'admin'
  before_filter :authenticate_admin

  def index
    if params[:search].present?
      @users = current_user.members.search(params[:search]).paginate(page: params[:page], :per_page => 10)
    else
      @users = current_user.members.all.paginate(page: params[:page], :per_page => 10)  
    end
  	
  	respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  def new
    @user = User.new
  end
  def create
    @user = current_user.members.build(params[:user].permit(:name, :email, :password, :password_confirmation, :role))
    respond_to do |format|
      if @user.save
        format.html { redirect_to action: :index }        
        format.json { render json: @user, status: :created, location: @user }
        flash[:notice] = 'New user created successfully'
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  # The User profile update
  #
  # @route
  # @wireframe    
  def update
    @user = User.find(params[:id])
    @user.assign_attributes(params[:user].permit(:name, :email, :password, :password_confirmation, :role))
    respond_to do |format|
      if @user.save
        format.html { redirect_to action: :index }        
        format.json { render json: @user, status: :created, location: @user }
        flash[:notice] = 'Updated user'
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user.nil?
    respond_to do |format|
      format.html { redirect_to action: :index}
      format.json { head :no_content}
      flash[:notice] = 'Deleted new user'
    end
  end

  
end