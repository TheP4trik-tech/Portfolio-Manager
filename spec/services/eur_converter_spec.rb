require 'rails_helper'

RSpec.describe EurConverter, type: :service do
  let(:user) { create(:user) }
  let!(:api_credential) { create(:api_credential, provider: "trading212", user: user) }

  let(:fake_data) do
    {
      total_balance: 1000.0,
      available_cash: 200.0,
      total_investments: 800.0,
      profit_loss: 50.0,
      currency: "GBP"
    }
  end

  it "converts to adapter data" do
    allow_any_instance_of(Trading212Adapter).to receive(:call).and_return(fake_data)
    stub_request(:get, "https://api.frankfurter.dev/v2/rates")
      .to_return(status: 200, body: [ { "quote" => "GBP", "rate" => 1.2 } ].to_json, headers: { "Content-Type" => "application/json" })

    result = EurConverter.new(user).call
    expect(result[:total_balance]).to eq(1000.0 / 1.2)
  end

  it "fails to convert adapter data" do
    allow_any_instance_of(Trading212Adapter).to receive(:call).and_return("Invalid credentials")
    expect { EurConverter.new(user).call }.to raise_error(RuntimeError)
  end
end
