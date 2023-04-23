class RekognitionService
  require 'aws-sdk-rekognition'

  def initialize(image)
    @image = image
  end

  def analyze_image
    aws_client = Aws::Rekognition::Client.new(region: 'ap-northeast-1', credentials: credentials)
    response = aws_client.detect_faces(input_image_atts)
    if response.face_details.empty?
      return false
    end
    face_details = response.face_details
    @face_details = []
    face_details.each do |face_detail|
      detail = {
        smile: face_detail.smile,
        eyes_open: face_detail.eyes_open,
        mouth_open: face_detail.mouth_open,
        emotions: face_detail.emotions,
        landmarks: face_detail.landmarks
      }
      @face_details << detail
    end
    return @face_details
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
        bytes: @image
      },
      attributes: ['ALL']
    }
  end
end