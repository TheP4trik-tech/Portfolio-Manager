# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with duplicate email" do
    create(:user, email: "test@test.com")
    user = build(:user, email: "test@test.com")
    expect(user).not_to be_valid
  end

  it "is invalid with bad email format" do
    user = build(:user, email: "notanemail")
    expect(user).not_to be_valid
  end

  it "is invalid without first_name" do
    user = build(:user, first_name: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with first_name too short" do
    user = build(:user, first_name: "A")
    expect(user).not_to be_valid
  end

  it "is invalid with first_name too long" do
    user = build(:user, first_name: "A" * 26)
    expect(user).not_to be_valid
  end

  it "is invalid with last_name too long" do
    user = build(:user, last_name: "A" * 26)
    expect(user).not_to be_valid
  end

  it "is valid without last_name" do
    user = build(:user, last_name: nil)
    expect(user).to be_valid
  end

  it "is invalid with password shorter than 6 characters" do
    user = build(:user, password: "abc")
    expect(user).not_to be_valid
  end

  it "has many api_credentials" do
    user = create(:user)
    expect(user).to respond_to(:api_credentials)
  end

  it "has many cash_snapshots" do
    user = create(:user)
    expect(user).to respond_to(:cash_snapshots)
  end

  it "destroys api_credentials when user is destroyed" do
    user = create(:user)
    create(:api_credential, user: user)
    expect { user.destroy }.to change(ApiCredential, :count).by(-1)
  end

  it "destroys cash_snapshots when user is destroyed" do
    user = create(:user)
    create(:cash_snapshot, user: user)
    expect { user.destroy }.to change(CashSnapshot, :count).by(-1)
  end
end
