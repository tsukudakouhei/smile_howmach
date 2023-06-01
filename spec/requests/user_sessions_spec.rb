require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /new" do
    it "httpリクエストを成功で返す" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "有効なパラメーターを与えられた場合" do
      it "ログインに成功する" do
        post login_path, params: { email: user.email, password: user.password }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "DELETE /destroy" do
    it "ログアウトに成功する" do
      delete logout_path
      expect(response).to have_http_status(:redirect)
    end

      it "ログインにリダイレクトする" do
        delete logout_path
        expect(response).to redirect_to login_path
      end
  end
end