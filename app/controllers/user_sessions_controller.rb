class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create guest_login]

  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to smile_prices_path, notice: 'ログインに成功しました'
    else
      flash.now[:alert] = 'ログインに失敗しました'
      render :new
    end
  end

  def guest_login
    @guest_user = User.create!(
    name: 'ゲスト',
    email: SecureRandom.alphanumeric(10) + "@email.com",
    password: 'password',
    password_confirmation: 'password'
    )
    auto_login(@guest_user)
    redirect_back_or_to smile_prices_path, notice: 'ゲストとしてログインしました'
  end

  def destroy
    logout
    redirect_to(login_path, notice: 'ログアウトしました')
  end

end
