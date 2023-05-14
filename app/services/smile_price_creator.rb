class SmilePriceCreator
  attr_reader :error
  def initialize(image, current_user)
    @image = image
    @current_user = current_user
  end

  def create_smile_price
    return nil unless validate_image_param
    rekognition_service = RekognitionService.new(@image)
    rekognition_data = rekognition_service.analyze_image

    chatgpt_service = ChatgptService.new(rekognition_data)
    chatgpt_service_result = chatgpt_service.analyze_data

    temp_smile_price_instance = chatgpt_service_result[:smile_price]
    smile_score = chatgpt_service_result[:smile_score]

    smile_price = smile_price_score_change_price(smile_score)

    @smile_price_record = @current_user.smile_prices.build(price: smile_price)
    @smile_price_record.smile_analysis_score = temp_smile_price_instance.smile_analysis_score
    if @smile_price_record.save
      create_smileprice_macmenus(@smile_price_record)
      return @smile_price_record
    else
      return false
    end
  end

  private

  def validate_image_param
    if @image.blank?
      @error = "診断失敗しました。"
      false
    else
      true
    end
  end

  def smile_price_score_change_price(smile_score)
    smile_score * 15 
  end

  def create_smileprice_macmenus(smile_price)
    smile_price = smile_price.price
    mac_menu_price_min = MacMenu.select("price").order("price asc").first.price
    jackpot_menu = rand(1..10)
    while true
      if jackpot_menu == 1
        mac_menu = MacMenu.edamame_menu.first
      elsif jackpot_menu == 2
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