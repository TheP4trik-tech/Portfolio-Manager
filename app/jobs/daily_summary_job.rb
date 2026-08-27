class DailySummaryJob < ApplicationJob
  queue_as :mailers

  def perform
    User.joins(:cash_snapshots).distinct.find_each do |user|
      PortfolioMailer.with(user: user).daily_summary_mail.deliver_later
    rescue => e
      Rails.logger.error "Daily summary mail failed for user #{user.id}: #{e.message}"
    end
  end
end
