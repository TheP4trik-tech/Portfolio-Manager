class PortfolioMailer < ApplicationMailer
  default from: "notifications@example.com"

  def error_mail
    @user = params[:user]
    @url  = "http://example.com/login"
    mail(to: @user.email, subject: "Error warning")
  end

  def daily_summary_mail
    @user = params[:user]
    @last_snapshot =  @user.cash_snapshots.where(created_at: 24.hours.ago..Time.current).last
    @latest_snapshot = @user.cash_snapshots.last
    @url  = "http://example.com/login"
    mail(to: @user.email, subject: "Daily Portfolio Summary")
  end
end
