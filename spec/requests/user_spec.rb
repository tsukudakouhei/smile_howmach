require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /new" do
    it "httpリクエストを成功で返す" do
      get new_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "有効なパラメーターを与えられた場合" do
      let(:user_params) { attributes_for(:user) }
      it "ユーザーが作成できる" do
        expect {
          post users_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      it "ログイン画面にリダイレクトする" do
        post users_path, params: { user: user_params }
        expect(response).to redirect_to login_path
      end
    end

    context '無効なパラメーターを与えられた場合' do
      let(:user_params) { attributes_for(:user, :invalid) }
      it 'ユーザーが作成できない' do
        expect {
          post users_path, params: { user: user_params }
        }.not_to change(User, :count)
      end

      it '新規登録画面を再表示する' do
        post users_path, params: { user: user_params }
        expect(response).to have_http_status(:success)
      end
    end
  end
  describe "GET /show" do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it "httpリクエストを成功で返す" do
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end
end