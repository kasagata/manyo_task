class Admin::UsersController < ApplicationController
  skip_before_action :logout_required
  before_action :admin_required, only: [:index, :edit, :show, :new]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.eager_load(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: t('.created')
    else
      render :new
    end
  end

  def show
    @tasks = @user.tasks.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: t('.destroyed')
    else
      @users = User.all
      render :index
  end

  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_required
    redirect_to tasks_path, notice: t('notice.admin_required') unless admin?
  end

end
