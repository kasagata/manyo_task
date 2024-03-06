class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :login_required
    before_action :logout_required
  
    private
  
    def login_required
      redirect_to new_session_path, notice: t('notice.login_required') unless current_user
    end
end
