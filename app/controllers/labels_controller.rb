class LabelsController < ApplicationController
  skip_before_action :logout_required
  before_action :set_user, only: %i[ index new create]
  before_action :set_label, only: %i[ show edit update destroy ]
  
  def index
    @labels = @user.labels
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    @label.user = @user
    if @label.save
      redirect_to labels_path, notice: t('.created')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: t('.updated')
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    redirect_to labels_path, notice: t('.destroyed')
  end

  private

  def label_params
    params.require(:label).permit(:name)
  end

  def set_user
    @user = current_user
  end

  def set_label
    @label = Label.find_by(id: params[:id])
  end
end
