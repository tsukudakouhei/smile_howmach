require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "名前、メール、パスワード、パスワード確認があれば有効なこと" do
    expect(user).to be_valid
    expect(user.errors).to be_empty
  end

  it "名前が空白の場合、無効であること" do
    user.name = nil
    user.invalid?
    expect(user.errors[:name]).to eq ["can't be blank"]
  end

  it "名前が21文字以上の場合、無効であること" do
    user.name = "a"*21
    user.invalid?
    expect(user.errors[:name]).to eq ["is too long (maximum is 20 characters)"]
  end

  it "メールアドレスが空白の場合、無効であること" do
    user.email = nil
    user.invalid?
    expect(user.errors[:email]).to eq ["can't be blank"]
  end

  it "メールアドレスが重複している場合、無効であること" do
    create(:user)
    user.invalid?
    expect(user.errors[:email]).to eq ["has already been taken"]
  end

  it "パスワードが空白の場合、無効であること" do
    user.password = nil
    user.invalid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "パスワードが3文字以下の場合、無効であること" do
    user.password = "a"
    user.invalid?
    expect(user.errors[:password]).to include("is too short (minimum is 3 characters)")
  end

  it "確認用パスワードが空白の場合、無効であること" do
    user.password_confirmation = nil
    user.invalid?
    expect(user.errors[:password_confirmation]).to include("can't be blank")
  end
end
