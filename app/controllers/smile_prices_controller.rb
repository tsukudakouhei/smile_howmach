class SmilePricesController < ApplicationController
  skip_before_action :require_login, only: %i[index show update]
  require 'aws-sdk-rekognition'

  def index
    @smile_prices = SmilePrice.all.includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def create
    credentials = Aws::Credentials.new(
        Rails.application.credentials[:aws][:access_key_id],
        Rails.application.credentials[:aws][:secret_access_key]
        # :region => 'ap-northeast-1',
    )

    # photo = Base64.decode64(File.expand_path(params[:image]))
    client = Aws::Rekognition::Client.new region: 'ap-northeast-1', credentials: credentials
    attrs = {
      image: {
        bytes: params[:image]
      },
      attributes: ['ALL']
    }
    response = client.detect_faces attrs
    if !response[0].empty?
      response.face_details.each do |face_detail|
        @smile_price = face_detail.smile.confidence * 15
        @smile_value = face_detail.smile.value
      end
      @smile_price / 2 if @smile_value == false
      @smile_price = current_user.smile_prices.build(price: @smile_price)
      if @smile_price.save
        smile_price = @smile_price.price
        mac_menu_price_min = MacMenu.select("price").order("price asc").first.price
        while true
          mac_menu = MacMenu.smileprice_and_below_menu(smile_price).random_choice.first
          @smile_price.smileprices_macdmenus.create(mac_menu_id: mac_menu.id)
          smile_price -= mac_menu.price
          break if smile_price <= mac_menu_price_min
        end
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
end
