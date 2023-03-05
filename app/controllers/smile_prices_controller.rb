class SmilePricesController < ApplicationController
  skip_before_action :require_login

  require 'aws-sdk-rekognition'

  def index; end

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
    if response
      response.face_details.each do |face_detail|
        @smile_price = face_detail.smile.confidence * 15
        @smile_value = face_detail.smile.value
      end
      @smile_price -= 750 if @smile_value == false
      @smile_price = current_user.smile_prices.build(price: @smile_price)
      if @smile_price.save
        smile_price = @smile_price.price
        mac_menu_price_min = MacMenu.select("price").order("price asc").first.price
        binding.pry
        while true
          mac_menu = MacMenu.smileprice_and_below_menu(smile_price).random_choice.first
          @smile_price.smileprices_macdmenus.create(mac_menu_id: mac_menu.id)
          smile_price -= mac_menu.price
          break if smile_price <= mac_menu_price_min
        end
        # @smile_price.smileprices_macdmenus.
        redirect_to smile_price_path(@smile_price), success: "OKだぜ!"
        binding.pry
      else
        flash.now[:danger] = "NGだぜ!"
        render :new
      end
    else
      flash.now[:danger] = "NGだぜ!"
      render :new
    end
  end

  def show
    @smile_price = SmilePrice.find(params[:id])
    @mac_manus = SmilepricesMacdmenu.where(smile_price_id: @smile_price)
  end
end
