require "rails_helper"

RSpec.describe SyncPortfolioJob, type: :job do
  let(:user) { create(:user) }
  let(:fake_data) do
    {
      total_balance: 1000.0,
      available_cash: 200.0,
      total_investments: 800.0,
      profit_loss: 50.0,
      currency: "EUR"
    }
  end

  before do
    create(:api_credential, user: user, provider: "trading212")
    allow_any_instance_of(EurConverter).to receive(:call).and_return(fake_data)
  end

  it "calls CashSnapshotService for users with credentials" do
    expect_any_instance_of(CashSnapshotService).to receive(:call)
    SyncPortfolioJob.perform_now
  end

  it "creates snapshot for user with credentials" do
    expect { SyncPortfolioJob.perform_now }.to change(CashSnapshot, :count).by(1)
  end

  it "continues when one user fails" do
    user2 = create(:user)
    create(:api_credential, user: user2, provider: "trading212")



    converter_for_user2 = instance_double(EurConverter)
    allow(EurConverter).to receive(:new).and_call_original
    allow(EurConverter).to receive(:new).with(user2).and_return(converter_for_user2)
    allow(converter_for_user2).to receive(:call).and_raise(RuntimeError)

    expect { SyncPortfolioJob.perform_now }.to change(CashSnapshot, :count).by(1)
  end
end
