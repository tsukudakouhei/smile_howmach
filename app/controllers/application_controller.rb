class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = "ログインしてください。"
    redirect_to login_path
  end

end
