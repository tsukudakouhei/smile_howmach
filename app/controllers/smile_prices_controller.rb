class SmilePricesController < ApplicationController
  skip_before_action :require_login, only: %i[index show update]
  require 'aws-sdk-rekognition'

  def index
    @smile_prices = SmilePrice.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def create
    @smile_price = detect_smile_price(params[:image])
    if @smile_price.present?
      @smile_price = create_smile_price_for_user(current_user, @smile_price)
      if @smile_price.present?
        add_mac_menus_to_smile_price(@smile_price)
        redirect_to smile_price_path(@smile_price), notice: '診断結果でました！'
      else
        flash.now[:alert] = "診断失敗しました。"
        render :new
      end
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

  def detect_smile_price(image)
    credentials = Aws::Credentials.new(
      Rails.application.credentials[:aws][:access_key_id],
      Rails.application.credentials[:aws][:secret_access_key]
    )

    client = Aws::Rekognition::Client.new(region: 'ap-northeast-1', credentials: credentials)
    attrs = {
      image: { bytes: image },
      attributes: ['ALL']
    }

    response = client.detect_faces(attrs)
    if response.face_details.empty?
      nil
    else
      response.face_details.map { |face_detail| face_detail.smile.confidence * 15 }.sum
    end
  end
end
