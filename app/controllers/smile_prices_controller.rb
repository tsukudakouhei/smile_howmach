class SmilePricesController < ApplicationController
  skip_before_action :require_login, only: %i[index show update]
  before_action :set_smile_price, only: %i[show edit update]
  before_action -> { correct_user(@smile_price) }, only: %i[edit update]
  before_action :chart_data, only: %i[show edit]

  def index
    @smile_prices = SmilePrice.where(is_published: true).includes(:user).order(created_at: :desc).page(params[:page])
  end

  def new; end

  def create
    image_data = params[:image]
    smile_price_creator = SmilePriceCreator.new(image_data, current_user)
    @smile_price_record = smile_price_creator.create_smile_price
    if @smile_price_record
      respond_to do |format|
        format.html { redirect_to edit_smile_price_path(@smile_price_record) } 
        format.json { render json: { redirect_url: edit_smile_price_path(@smile_price_record) } }
      end
    else
      respond_to do |format|
        format.html { 
          flash[:error] = "エラーが発生しました。再度お試しください。"
          redirect_to new_smile_price_path
        }
        format.json { 
          render json: { error: "エラーメッセージ" }, status: :unprocessable_entity 
        }
      end
    end
  end

  def show; end

  def edit; end

  def update
    if @smile_price.update(set_smile_price_body)
      redirect_to smile_price_path(@smile_price), success: "投稿しました。"
    else
      flash.now['danger'] = "投稿できませんでした。"
      render :edit
    end 
  end

  private

  def set_smile_price_body
    params.require(:smile_price).permit(:body, :is_published)
  end

  def set_smile_price
    @smile_price = SmilePrice.find(params[:id])
  end

  def chart_data
    return unless @smile_price.smile_analysis_score
    
    score_attributes = [
      :eye_expression_score,
      :mouth_expression_score,
      :nose_position_score,
      :jawline_score,
      :naturalness_and_balance_score
    ]

    @chart_data = score_attributes.map do |attribute|
      @smile_price.smile_analysis_score.send(attribute)
    end
  end
end
