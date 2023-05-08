class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def not_authenticated
    flash[:warning] = "ログインしてください。"
    redirect_to login_path
  end

  def correct_user(resource)
    if resource.is_a?(User)
      user_to_check = resource
    else
      user_to_check = resource.user
    end

    unless user_to_check == current_user
      flash[:error] = "権限がありません"
      redirect_to smile_prices_path
    end
  end

end
