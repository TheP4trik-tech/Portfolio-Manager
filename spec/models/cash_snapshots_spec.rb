require "rails_helper"

RSpec.describe CashSnapshot, type: :model do
  it "is valid with valid attributes" do
    snapshot = build(:cash_snapshot)
    expect(snapshot).to be_valid
  end

  it "is invalid without user" do
    snapshot = build(:cash_snapshot, user: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid without currency" do
    snapshot = build(:cash_snapshot, currency: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid without total_balance" do
    snapshot = build(:cash_snapshot, total_balance: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid without available_cash" do
    snapshot = build(:cash_snapshot, available_cash: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid without total_investments" do
    snapshot = build(:cash_snapshot, total_investments: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid without profit_loss" do
    snapshot = build(:cash_snapshot, profit_loss: nil)
    expect(snapshot).not_to be_valid
  end

  it "is invalid with negative total_balance" do
    snapshot = build(:cash_snapshot, total_balance: -1)
    expect(snapshot).not_to be_valid
  end

  it "is invalid with negative total_investments" do
    snapshot = build(:cash_snapshot, total_investments: -1)
    expect(snapshot).not_to be_valid
  end

  it "is invalid with negative available_cash" do
    snapshot = build(:cash_snapshot, available_cash: -1)
    expect(snapshot).not_to be_valid
  end

  it "allows negative profit_loss" do
    snapshot = build(:cash_snapshot, profit_loss: -100.0)
    expect(snapshot).to be_valid
  end

  it "belongs to user" do
    snapshot = create(:cash_snapshot)
    expect(snapshot.user).to be_a(User)
  end

  it "returns snapshots from last 24 hours" do
    user = create(:user)
    old_snapshot = create(:cash_snapshot, user: user, created_at: 2.days.ago)
    recent_snapshot = create(:cash_snapshot, user: user)
    results = user.cash_snapshots.where(created_at: 24.hours.ago..Time.current)
    expect(results).to include(recent_snapshot)
    expect(results).not_to include(old_snapshot)
  end
end
