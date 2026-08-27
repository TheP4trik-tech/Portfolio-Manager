require 'rails_helper'

RSpec.describe DailySummaryJob, type: :job do
  let(:user) { create(:user) }
  let!(:old_snapshot) { create(:cash_snapshot, user: user, total_balance: 1000.0, profit_loss: 50.0, created_at: 23.hours.ago) }
  let!(:new_snapshot) { create(:cash_snapshot, user: user, total_balance: 1200.0, profit_loss: 100.0) }

  it "sends daily summary mail to users with snapshots" do
    expect(PortfolioMailer).to receive_message_chain(:with, :daily_summary_mail, :deliver_later)
    DailySummaryJob.perform_now
  end

  it "continues when mail fails" do
    allow(PortfolioMailer).to receive_message_chain(:with, :daily_summary_mail, :deliver_later).and_raise(RuntimeError)
    expect { DailySummaryJob.perform_now }.not_to raise_error
  end
end
