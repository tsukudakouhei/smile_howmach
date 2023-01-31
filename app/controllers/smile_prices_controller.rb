class SmilePricesController < ApplicationController
  skip_before_action :require_login

  def index; end

  def new; end

  def create
    binding.pry
    photo = Base64.decode64(File.expand_path(params[:image]))
    redirect_to smile_prices_path
  end

  def show;
    @s = params[:id]
  end
end
