class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :set_user, only: %i[ index new create]
  skip_before_action :logout_required
  
  def index
    page = params[:page]
    #ソート処理
    if params[:sort_deadline_on]
      @tasks = @user.tasks.sort_deadline_on.page(page)
    elsif params[:sort_priority]
      @tasks = @user.tasks.sort_priority.page(page)
    else
    #検索処理
      @search_params = task_search_params
      @tasks = @user.tasks.search(@search_params).order(created_at: :desc).page(page)
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = @user
    if @task.save
      redirect_to tasks_path, notice: t('.created')
    else
      render :new
    end
  end

  def show
    redirect_to tasks_path, notice: t('.not_access') unless @task.user == current_user
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path, notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: t('.destroyed')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status)
  end

  def task_search_params
    params.fetch(:search, {}).permit(:title, :status)
  end

  def set_user
    @user = current_user
  end


end
