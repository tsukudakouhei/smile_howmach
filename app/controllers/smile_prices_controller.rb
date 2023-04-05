class SmilePricesController < ApplicationController
  skip_before_action :require_login, only: %i[index show update]
  require 'aws-sdk-rekognition'

  def index
    @smile_prices = SmilePrice.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def create
    smile_price_creator = SmilePriceCreator.new(params, current_user)
    @smile_price_record = smile_price_creator.create_smile_price

    if @smile_price_record
      redirect_to smile_price_path(@smile_price_record), notice: '診断結果でました！'
    else
      flash.now[:alert] = "診断失敗しました。"
      render :new
    end
  end

  def show
    @smile_price = SmilePrice.find(params[:id])
    @mac_manus = SmilepricesMacdmenu.where(smile_price_id: @smile_price)
  end

  def update
    @smile_price = SmilePrice.find(params[:id])
    if @smile_price.update(set_smile_price_body)
      redirect_to smile_prices_path, success: "投稿しました。"
    else
      flash.now['danger'] = "投稿できませんでした。"
      render :edit
    end 
  end

  private

  def set_smile_price_body
    params.require(:smile_price).permit(:body)
  end
end
