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
      @smile_score = face_detail.smile.confidence
      end
      @smile_price = current_user.smile_prices.build(price: @smile_score)
      if @smile_price.save
        binding.pry
        redirect_to smile_price_path(@smile_price), success: "OKだぜ!"
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
  end
end
