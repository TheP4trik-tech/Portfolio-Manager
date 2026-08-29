class DashboardController < ApplicationController
  def index
    ## parsing user snapshots for chart-controller.js format
    raw_snapshots = current_user.cash_snapshots
                                .order(:created_at)
                                .map { |s| { time: s.created_at.to_i, value: s.total_balance.to_f, profit_loss: s.profit_loss.to_f } }
                                .uniq { |s| s[:time] }

    @hourly_data = raw_snapshots.select { |s| s[:time] >= 7.days.ago.to_i }
    @daily_data = raw_snapshots
      .group_by { |s| Time.at(s[:time]).to_date }
      .map { |time, records| records.last }
  end
end
