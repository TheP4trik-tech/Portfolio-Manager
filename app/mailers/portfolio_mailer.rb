class PortfolioMailer < ApplicationMailer
  default from: "Acme <onboarding@resend.dev>"
  def error_mail
    @user = params[:user]
    @error_message = params[:error_message]
    @provider = params[:provider]
    @url  = new_user_session_url
    mail(to: @user.email, subject: "Error warning")
  end

  ## takes user's snapshots in 24 hour window, if there are not any or one, it will raise an error and wont continue.
  # if it succeed, user will receive the email about his porftolio change in this 24 hour window
  def daily_summary_mail
    @user = params[:user]
    recent_snapshots = @user.cash_snapshots.where(created_at: 24.hours.ago..Time.current)

    if recent_snapshots.empty?
      raise "No snapshots found for user #{@user.id} in the last 24 hours"
    end

    @last_snapshot   = recent_snapshots.order(created_at: :asc).first
    @latest_snapshot = recent_snapshots.order(created_at: :desc).first

    if @last_snapshot == @latest_snapshot
      @last_snapshot = nil
    end

    @url  = "url"
    mail(to: @user.email, subject: "Daily Portfolio Summary")
  end
end
