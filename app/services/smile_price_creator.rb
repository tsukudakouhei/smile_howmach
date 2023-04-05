class SmilePriceCreator
  require 'aws-sdk-rekognition'

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def create_smile_price
    aws_client = Aws::Rekognition::Client.new(region: 'ap-northeast-1', credentials: credentials)
    response = aws_client.detect_faces(input_image_atts)
    if response.face_details.empty?
      return false
    end

    face_details = response.face_details
    @smile_price, @smile_value = calculate_smile_price(face_details)
    @smile_price_record = @current_user.smile_prices.build(price: @smile_price)
    if @smile_price_record.save
      create_smileprice_macmenus
      return @smile_price_record
    else
      return false
    end
  end

  private

  def credentials
    Aws::Credentials.new(
      Rails.application.credentials[:aws][:access_key_id],
      Rails.application.credentials[:aws][:secret_access_key]
    )
  end

  def input_image_atts
    attrs = {
      image: {
        bytes: @params[:image]
      },
      attributes: ['ALL']
    }
  end

  def calculate_smile_price(face_details)
    smile_price, smile_value = nil, nil
    face_details.each do |face_detail|
      smile_confidence = face_detail.smile.confidence
      smile_price = (smile_confidence * 15).round(2)
      smile_value = face_detail.smile.value
    end
    smile_price /= 2 if !smile_value
    return smile_price, smile_value
  end

  def create_smileprice_macmenus
    smile_price = @smile_price_record.price
    mac_menu_price_min = MacMenu.select("price").order("price asc").first.price
    jackpot_menu = rand(1..10)
    while true
      if jackpot_menu == 1
        mac_menu = MacMenu.edamame_menu.first
      elsif jackpot_menu == 3
        mac_menu = MacMenu.poteto_menu.sample
      else
        mac_menu = MacMenu.smileprice_and_below_menu(smile_price).random_choice.first
      end
      @smile_price_record.smileprices_macdmenus.create(mac_menu_id: mac_menu.id)
      smile_price -= mac_menu.price
      break if smile_price <= mac_menu_price_min
    end
  end
end