class DailySummaryJob < ApplicationJob
  def perform
    User.joins(:cash_snapshots).distinct.find_each do |user|
      if user.daily_mail_accepted?
      PortfolioMailer.with(user: user).daily_summary_mail.deliver_later
      end
    rescue => e
      Rails.logger.error "Daily summary mail failed for user #{user.id}: #{e.message}"
    end
  end
end
