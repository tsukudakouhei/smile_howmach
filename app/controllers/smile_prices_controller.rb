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
      @smile_prices = current_user.smile_prices.build(price: @smile_price)
      if @smile_prices.save
        redirect_to smile_price_path(@smile_prices), success: "OKだぜ!"
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
    @smile_prices = SmilePrice.find(params[:id])
  end
end
