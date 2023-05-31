require 'rails_helper'

RSpec.describe "SmilePrices", type: :request do
  let(:user) { create(:user) }
  let(:smile_price) { create(:smile_price, user: user) }

  describe "GET /index" do
    it "httpリクエストを成功で返す" do
      get smile_prices_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "httpリクエストを成功で返す" do
      get smile_price_path(smile_price)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
      before do
        sign_in user
      end
    
    it "returns http success" do
      get edit_smile_price_path(smile_price)
      expect(response).to have_http_status(:success)
    end
  end

end
