class ChatgptService
  require 'openai'

  def initialize(rekognition_data)
    @rekognition_data = rekognition_data
  end

  def analyze_data
      prompt = "Please analyze the smile in the image using the provided data: #{@rekognition_data}\n"\
          "For each aspect of the smile, provide a numeric rating on a scale of 1 to 20 (1 being the lowest, 20 being the highest).\n"\
          "1. Eye expression rating:\n"\
          "2. Mouth expression rating:\n"\
          "3. Nose position rating:\n"\
          "4. Jawline rating:\n"\
          "5. Naturalness and balance rating:"
      response = client.completions(
        engine: "text-davinci-002",
        prompt: prompt,
        max_tokens: 150,
        n: 1,
        stop: nil,
        temperature: 0.5
      )
    text = response.choices[0].text

    @eye_score = text[/eye expression.*?(?:rated at )?(\d{1,2})/i, 1].to_i
    @mouth_score = text[/mouth expression.*?(?:rated at )?(\d{1,2})/i, 1].to_i
    @nose_score = text[/nose position.*?(?:rated at )?(\d{1,2})/i, 1].to_i
    @jawline_score = text[/jawline.*?(?:rated at )?(\d{1,2})/i, 1].to_i
    @naturalness_balance_score = text[/naturalness and balance.*?(?:rated at )?(\d{1,2})/i, 1].to_i
    @smile_score = @eye_score + @mouth_score + @nose_score + @jawline_score + @naturalness_balance_score
    temp_smile_price_instance = SmilePrice.new
    analysis_score_create(temp_smile_price_instance)
    return { smile_price: temp_smile_price_instance, smile_score: @smile_score }
  end

  def analysis_score_create(smile_price)
    smile_analysis_score = smile_price.build_smile_analysis_score(
      smile_score: @smile_score,
      eye_expression_score: @eye_score,
      mouth_expression_score: @mouth_score,
      nose_position_score: @nose_score,
      jawline_score: @jawline_score,
      naturalness_and_balance_score: @naturalness_balance_score
    )
    smile_analysis_score.save
  end

  private

  def client
    OpenAI::Client.new(api_key: Rails.application.credentials[:openai][:openai_api_key])
  end

end
