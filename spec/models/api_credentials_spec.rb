require "rails_helper"

RSpec.describe ApiCredential, type: :model do
  it "is valid with valid attributes" do
    credential = build(:api_credential)
    expect(credential).to be_valid
  end

  it "is invalid without provider" do
    credential = build(:api_credential, provider: nil)
    expect(credential).not_to be_valid
  end

  it "is invalid without api_key" do
    credential = build(:api_credential, api_key: nil)
    expect(credential).not_to be_valid
  end

  it "is invalid without api_id" do
    credential = build(:api_credential, api_id: nil)
    expect(credential).not_to be_valid
  end

  it "belongs to user" do
    credential = create(:api_credential)
    expect(credential.user).to be_a(User)
  end

  it "resets error_sent when api_key changes" do
    credential = create(:api_credential)
    credential.update(error_sent: true)
    credential.update(api_key: "new_key")
    expect(credential.reload.error_sent).to eq(false)
  end

  it "resets error_sent when api_id changes" do
    credential = create(:api_credential)
    credential.update(error_sent: true)
    credential.update(api_id: "new_id")
    expect(credential.reload.error_sent).to eq(false)
  end

  it "does not reset error_sent when provider changes" do
    credential = create(:api_credential)
    credential.update(error_sent: true)
    credential.update(provider: "etoro")
    expect(credential.reload.error_sent).to eq(true)
  end
end
