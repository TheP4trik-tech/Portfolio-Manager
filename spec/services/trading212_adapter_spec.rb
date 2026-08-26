require "rails_helper"
RSpec.describe Trading212Adapter, type: :service do
  let(:user) { create(:user) }
  let(:uri) { "https://live.trading212.com/api/v0/equity/account/summary" }

  before do
    create(:api_credential, user: user, provider: "trading212")
  end
  it "authorized access" do
    credentials = user.api_credentials.find_by(provider: "trading212")
     stub_request(:get, uri).with(basic_auth: [ credentials.api_id, credentials.api_key ])
                           .to_return(status: 200,
                                      body: {
                                        "totalValue" => 2000,
                                        "currency" => "CZK",
                                        "cash" => {
                                          "availableToTrade" => 100
                                        },
                                        "investments" => {
                                          "totalCost" => 12,
                                          "unrealizedProfitLoss" => 1222
                                        }
                                      }.to_json, headers: { "Content-Type" => "application/json" }
                           )
    result = Trading212Adapter.new(user).call
    expect(result[:total_balance]).to eq(2000)
    expect(result[:currency]).to eq("CZK")
  end

  it "unauthorized access" do
    credentials = user.api_credentials.find_by(provider: "trading212")
    stub_request(:get, uri).with(basic_auth: [ credentials.api_id, credentials.api_key ]).to_return(status: 401, body: {}.to_json)
    result = Trading212Adapter.new(user).call
    expect(result).to be_a(String)
  end
end
