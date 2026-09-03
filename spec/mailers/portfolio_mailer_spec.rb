require "rails_helper"

RSpec.describe PortfolioMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:user_2) { create(:user) }
  let!(:last_snapshot) { create(:cash_snapshot, user: user, total_balance: 1000.0, profit_loss: 50.0, created_at: 23.hours.ago) }
  let!(:snapshot) { create(:cash_snapshot, user: user, total_balance: 211, profit_loss: 1212212, created_at: 10.hours.ago) }
  let!(:latest_snapshot) { create(:cash_snapshot, user: user, total_balance: 1200.0, profit_loss: 100.0) }

  let(:error_mail) do
    PortfolioMailer.with(user: user, provider: "etoro", error_message: "Invalid credentials").error_mail
  end
  let(:portfolio_summary_mail) do
    PortfolioMailer.with(user: user).daily_summary_mail
  end



  it "error_mail" do
    expect(error_mail.to).to eq([ user.email ])
    expect(error_mail.subject).to eq("Error warning")
    expect(error_mail.body.encoded).to include("Invalid credentials")
    expect(error_mail.body.encoded).to include("etoro")
  end

  it "portfolio_summary_mail" do
    expect(portfolio_summary_mail.to).to eq([ user.email ])
    expect(portfolio_summary_mail.subject).to eq("Daily Portfolio Summary")
    expect(portfolio_summary_mail.body.encoded).to include("200")
    expect(portfolio_summary_mail.body.encoded).to include("50")
  end


  context "when user has no snapshots in the last 24 hours" do
    it "raises an error" do
      expect {
        PortfolioMailer.with(user: user_2).daily_summary_mail.deliver_now
      }.to raise_error(RuntimeError)
    end
  end
end
