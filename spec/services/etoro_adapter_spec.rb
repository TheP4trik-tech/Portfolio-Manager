require "rails_helper"
RSpec.describe EtoroAdapter, type: :service do
  let(:user) { create(:user) }
  let(:uri) { "https://public-api.etoro.com/api/v1/trading/info/real/pnl" }

  before do
    create(:api_credential, user: user, provider: "etoro")
  end

  it "authorized access" do
    credentials = user.api_credentials.find_by(provider: "etoro")
    stub_request(:get, uri).with(headers: { "x-api-key" => credentials.api_id, "x-user-key" => credentials.api_key }).to_return(status: 200, body: {
                                                                                                                                                       "clientPortfolio" => {
                                                                                                                                                         "credit" => 1000.0,
                                                                                                                                                         "unrealizedPnL" => 50.0,
                                                                                                                                                         "positions" => [],
                                                                                                                                                         "mirrors" => [],
                                                                                                                                                         "ordersForOpen" => [],
                                                                                                                                                         "orders" => [],
                                                                                                                                                         "currency" => "USD"
                                                                                                                                                       }
                                                                                                                                                     }.to_json, headers: { "Content-Type" => "application/json" })
    response = EtoroAdapter.new(user).call
    expect(response[:total_balance]).to eq(1000.0)
    expect(response[:profit_loss]).to eq(50.0)
    expect(response[:available_cash]).to eq(1000.0)
    expect(response[:total_investments]).to eq(0.0)
  end
end
