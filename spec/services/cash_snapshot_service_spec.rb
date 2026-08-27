require "rails_helper"

RSpec.describe CashSnapshotService, type: :service do
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
    allow_any_instance_of(EurConverter).to receive(:call).and_return(fake_data)
  end

  it "creates a snapshot" do
    expect { CashSnapshotService.new(user).call }.to change(CashSnapshot, :count).by(1)
  end

  it "skips zero snapshot" do
    allow_any_instance_of(EurConverter).to receive(:call).and_return(fake_data.merge(total_balance: 0.0))
    expect { CashSnapshotService.new(user).call }.not_to change(CashSnapshot, :count)
  end

  it "handles error from EurConverter" do
    allow_any_instance_of(EurConverter).to receive(:call).and_raise(RuntimeError)
    expect { CashSnapshotService.new(user).call }.not_to raise_error
  end
end
