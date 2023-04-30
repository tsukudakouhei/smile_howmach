class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = "ログインしてください。"
    redirect_to login_path
  end

  def currect_user(resource)
    unless resource.user == current_user
      flash[:error] = "権限がありません"
      redirect_to smile_prices_path
    end
  end

end
